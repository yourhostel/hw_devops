# apply_issuer.py

import subprocess
import time
import sys
import argparse


def run_command(command):
    """Run a command in the bash shell and return the result."""
    result = subprocess.run(['/bin/bash', '-c', command], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    return result.stdout.decode('utf-8'), result.stderr.decode('utf-8')


def check_cluster_accessibility(cluster_name, region):
    """Check if the EKS cluster is accessible without kubeconfig."""
    stdout, stderr = run_command(
        f"aws eks describe-cluster --name {cluster_name} --region {region} --query cluster.status --output text"
    )
    if stderr:
        print(f"Error checking cluster accessibility: {stderr}", file=sys.stderr)
        return False
    return stdout.strip() == "ACTIVE"


def check_cert_manager_status(namespace="cert-manager"):
    """Check for readiness of cert-manager."""
    stdout, stderr = run_command(
        f"kubectl get pods -n {namespace} -o jsonpath=\"{{.items[*].status.containerStatuses[*].ready}}\""
    )
    if stderr:
        print(f"Error checking cert-manager status: {stderr}", file=sys.stderr)
        return False

    # Checking that all containers are ready
    return "false" not in stdout.strip().split()


def resource_exists(kind, name, namespace="default"):
    """Check if a Kubernetes resource exists."""
    stdout, stderr = run_command(f"kubectl get {kind} {name} -n {namespace}")
    return not stderr.strip()  # Return True if no error message, indicating the resource exists


def apply_issuer_module(cluster_name, region, eks_cluster_endpoint, cluster_ca_certificate, cluster_token):
    """Apply the Terraform module for issuer."""
    # Update kubeconfig configuration
    stdout, stderr = run_command(f"aws eks update-kubeconfig --region {region} --name {cluster_name}")
    if stderr:
        print(f"Error updating kubeconfig: {stderr}", file=sys.stderr)
        return

    # Define provider arguments
    provider_args = (
        f"-var 'eks_cluster_endpoint={eks_cluster_endpoint}' "
        f"-var 'cluster_ca_certificate={cluster_ca_certificate}' "
        f"-var 'cluster_token={cluster_token}'"
    )

    # Check if the ClusterIssuer resource already exists
    if resource_exists("clusterissuer", "letsencrypt-prod", ""):
        print("ClusterIssuer 'letsencrypt-prod' already exists. Skipping creation.")
        return

    # Check if the https_ingress resource already exists
    if resource_exists("ingress", "https-ingress", "default"):
        print("Ingress resource 'https-ingress' already exists. Skipping creation.")
    else:
        # Apply the issuer module if the Ingress does not exist
        stdout, stderr = run_command(f"terraform apply {provider_args} -target=module.issuer -auto-approve")
        if stderr:
            print(f"Error applying issuer module: {stderr}", file=sys.stderr)
        else:
            print(stdout)


def main():
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
            print("Cluster is accessible. Updating kubeconfig...")
            break
        else:
            print("Cluster is not accessible yet. Retrying in 30 seconds...")
            time.sleep(sleep_duration)
    else:
        print("Cluster was not accessible after maximum retries. Exiting...", file=sys.stderr)
        sys.exit(1)

    # Check if cert-manager is ready
    for _ in range(max_retries):
        if check_cert_manager_status():
            print("Cert-manager is ready. Checking and applying issuer module...")
            apply_issuer_module(args.cluster_name, args.region, args.eks_cluster_endpoint,
                                args.cluster_ca_certificate, args.cluster_token)
            break
        else:
            print("Cert-manager is not ready yet. Retrying in 30 seconds...")
            time.sleep(sleep_duration)
    else:
        print("Cert-manager was not ready after maximum retries. Exiting...", file=sys.stderr)


if __name__ == "__main__":
    main()






