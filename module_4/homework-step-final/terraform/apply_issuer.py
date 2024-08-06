# apply_issuer.py

import subprocess
import time
import sys
import argparse

LOG_FILE = "/tmp/apply_issuer.log"


def write_to_log(message):
    """Write a message to the log file."""
    with open(LOG_FILE, "a") as f:
        f.write(message + "\n")


def run_command(command):
    """Run a command in the bash shell and return the result."""
    write_to_log(f"Running command: {command}")
    result = subprocess.run(['/bin/bash', '-c', command], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    stdout = result.stdout.decode('utf-8')
    stderr = result.stderr.decode('utf-8')
    write_to_log(f"stdout: {stdout}")
    write_to_log(f"stderr: {stderr}")
    return stdout, stderr


def check_cluster_accessibility(cluster_name, region):
    """Check if the EKS cluster is accessible without kubeconfig."""
    stdout, stderr = run_command(
        f"aws eks describe-cluster --name {cluster_name} --region {region} --query cluster.status --output text"
    )
    if stderr:
        write_to_log(f"Error checking cluster accessibility: {stderr}")
        return False
    return stdout.strip() == "ACTIVE"


def check_cert_manager_status(namespace="cert-manager"):
    """Check for readiness of cert-manager."""
    stdout, stderr = run_command(
        f"kubectl get pods -n {namespace} -o jsonpath=\"{{.items[*].status.containerStatuses[*].ready}}\""
    )
    if stderr:
        write_to_log(f"Error checking cert-manager status: {stderr}")
        return False

    # Checking that all containers are ready
    return "false" not in stdout.strip().split()


def resource_exists(kind, name, namespace="default"):
    """Check if a Kubernetes resource exists."""
    stdout, stderr = run_command(f"kubectl get {kind} {name} -n {namespace}")
    if stderr:
        write_to_log(f"Error checking if resource {kind}/{name} exists: {stderr}")
        return False
    return True


def apply_issuer_module(cluster_name, region, eks_cluster_endpoint, cluster_ca_certificate, cluster_token):
    """Apply the Terraform module for issuer."""
    # Update kubeconfig configuration
    stdout, stderr = run_command(f"aws eks update-kubeconfig --region {region} --name {cluster_name}")
    if stderr:
        write_to_log(f"Error updating kubeconfig: {stderr}")
        return

    # Define provider arguments
    provider_args = (
        f"-var 'eks_cluster_endpoint={eks_cluster_endpoint}' "
        f"-var 'cluster_ca_certificate={cluster_ca_certificate}' "
        f"-var 'cluster_token={cluster_token}'"
    )

    # Check if the ClusterIssuer resource already exists
    if resource_exists("clusterissuer", "letsencrypt-prod", ""):
        write_to_log("ClusterIssuer 'letsencrypt-prod' already exists. Skipping creation.")
        return

    # Check if the https_ingress resource already exists
    if resource_exists("ingress", "https-ingress", "default"):
        write_to_log("Ingress resource 'https-ingress' already exists. Skipping creation.")
    else:
        # Apply the issuer module if the Ingress does not exist
        stdout, stderr = run_command(f"terraform apply {provider_args} -target=module.issuer -auto-approve")
        if stderr:
            write_to_log(f"Error applying issuer module: {stderr}")
        else:
            write_to_log(stdout)


def main():
    # Clear the log file at the start
    open(LOG_FILE, "w").close()

    parser = argparse.ArgumentParser(description="Apply issuer module after cert-manager is ready.")
    parser.add_argument('--cluster_name', required=True, help="Name of the EKS cluster")
    parser.add_argument('--region', required=True, help="AWS region of the EKS cluster")
    parser.add_argument('--eks_cluster_endpoint', required=True, help="EKS cluster endpoint")
    parser.add_argument('--cluster_ca_certificate', required=True, help="Base64 encoded CA certificate")
    parser.add_argument('--cluster_token', required=True, help="Kubernetes cluster token")

    args = parser.parse_args()

    max_retries = 3
    sleep_duration = 15  # in seconds

    # Check if the cluster is accessible
    for _ in range(max_retries):
        if check_cluster_accessibility(args.cluster_name, args.region):
            write_to_log("Cluster is accessible. Updating kubeconfig...")
            break
        else:
            write_to_log("Cluster is not accessible yet. Retrying in 30 seconds...")
            time.sleep(sleep_duration)
    else:
        write_to_log("Cluster was not accessible after maximum retries. Exiting...")
        sys.exit(1)

    # Check if cert-manager is ready
    for _ in range(max_retries):
        if check_cert_manager_status():
            write_to_log("Cert-manager is ready. Checking and applying issuer module...")
            apply_issuer_module(args.cluster_name, args.region, args.eks_cluster_endpoint,
                                args.cluster_ca_certificate, args.cluster_token)
            break
        else:
            write_to_log("Cert-manager is not ready yet. Retrying in 30 seconds...")
            time.sleep(sleep_duration)
    else:
        write_to_log("Cert-manager was not ready after maximum retries. Exiting...")
        sys.exit(1)

    # Print the log at the end
    with open(LOG_FILE, "r") as f:
        print(f.read())


if __name__ == "__main__":
    main()








