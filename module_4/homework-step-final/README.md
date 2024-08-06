# Step final

 [homework-step-final.md](https://gitlab.com/dan-it/groups/devops2/homework/-/blob/main/homework-step-final.md)

## Task 1 Create GitHub/GitLab repo with

- test python backend server. Just script which listening on some port and respond 200 on / 
- Dockerfile with everything needed to run this script
- GitHub actions or GitLab CI which will build docker image automatically and push to docker hub. Use Github secrets or Gitlab variables to store your docker hub creds

### Execution:
1. Created workflows in the root of the git repository [.github/workflows/main.yml](https://github.com/yourhostel/hw_devops/blob/main/.github/workflows/main.yml)
2. A trigger is set to run workflows in response to changes in the [project folder](https://github.com/yourhostel/hw_devops/tree/main/module_4/homework-step-final) only.
```yml
on:
  push:
    branches:
      - main
    paths:
      - 'module_4/homework-step-final/python/**'
```
3. Added [app.py](https://github.com/yourhostel/hw_devops/blob/main/module_4/homework-step-final/app.py) and [Dockerfile](https://github.com/yourhostel/hw_devops/blob/main/module_4/homework-step-final/Dockerfile) to the project.
4. Added repository secrets.
![final-1 (1).jpg](screenshots%2Ftask-1%2Ffinal-1%20%281%29.jpg)
5. Checking the workflows.
![final-1 (2).jpg](screenshots%2Ftask-1%2Ffinal-1%20%282%29.jpg)
![final-1 (3).jpg](screenshots%2Ftask-1%2Ffinal-1%20%283%29.jpg)
![final-1 (4).jpg](screenshots%2Ftask-1%2Ffinal-1%20%284%29.jpg)

## Task 2 Write terraform code to create EKS cluster
- use code from lection_scripts/lesson-20240620/EKS
- one node group with one node
- nginx ingress controller
### Execution:
1. Create a [Terraform Configuration](https://github.com/yourhostel/hw_devops/tree/main/module_4/homework-step-final/terraform)
2. Create a `terraform.tfvars`
```markdown
region      = "eu-north-1"
name        = "yourhostel"
prefix      = "yourhostel"
vpc_id      = "<vpc-id>"
subnets_ids = ["<subnet-id-1>", "<subnet-id-2>", "<subnet-id-3>"]
tags        = {
  Environment = "test"
  TfControl   = "true"
}
```
```markdown
/terraform$ tree
.
├── main.tf
├── modules
│   ├── cluster
│   │   ├── main.tf
│   │   └── variables.tf
│   └── ingress
│       ├── main.tf
│       └── variables.tf
├── terraform.tfvars
└── variables.tf
```
```bash
terraform init
terraform plan -out=tfplan
terraform apply tfplan
aws eks update-kubeconfig --region eu-north-1 --name yourhostel
```
![final-2 (1).jpg](screenshots%2Ftask-2%2Ffinal-2%20%281%29.jpg)
![final-2 (2).jpg](screenshots%2Ftask-2%2Ffinal-2%20%282%29.jpg)
![final-2 (3).jpg](screenshots%2Ftask-2%2Ffinal-2%20%283%29.jpg)
### Useful commands:
```bash
kubectl get pods -n kube-system -l app.kubernetes.io/name=ingress-nginx
kubectl get ingress --all-namespaces
kubectl get svc -n kube-system
kubectl describe svc yourhostel-nginx-ingress-ingress-nginx-controller -n kube-system

terraform plan -destroy
terraform destroy

terraform init -upgrade
terraform refresh

# LOCK_ID - this is the lock ID shown in the error message
terraform force-unlock LOCK_ID 
terraform state list
ps aux | grep terraform

# Cleaning up states and plans
rm -f terraform.tfstate \
&& rm -f terraform.tfstate.backup \
&& rm -f tfplan\
&& rm -f terraform.log

rm -rf .terraform
terraform init -reconfigure
```
## Task 3 Write terraform code which will install Cert manager, Sealed Secrets, ArgoCD to EKS using helm chart
- add certificate cluster issuer to EKS using kubernetes provider and kubernetes_manifest resource
- if you have own DNS domain, then argocd should use your dns name when expose over ingress
- generate SSL certificiate for the used DNS name and optionally use HTTPS
- each helm release should use own namespace
1. Added module my own [VPC](https://github.com/yourhostel/hw_devops/tree/main/module_4/homework-step-final/terraform/modules/vpc). Forwarding to module.cluster and output to console subnets_ids and vpc_id values.
```markdown
vpc
├── main.tf
├── modules
│   └── vpc
│       ├── main.tf
│       └── variables.tf
└── variables.tf
```
2. Added load_balancer_ips output extraction in  null_resource.fetch_elb_ipsm to [module.ingress](https://github.com/yourhostel/hw_devops/blob/main/module_4/homework-step-final/terraform/modules/ingress/main.tf)
```terraform
resource "null_resource" "fetch_elb_ips" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = <<EOT
     aws ec2 describe-network-interfaces \
     --filters "Name=description,Values='ELB net/$(echo ${local.lb_hostname} | cut -d'-' -f1)*'" \
     --query 'NetworkInterfaces[*].Association.PublicIp' \
     --output json > /tmp/elb_ips.json
    EOT
  }
}
```
- the command `$(echo ${local.lb_hostname} | cut -d'-' -f1)` cuts from `a8b4bc81a22f3423ea48f2326e0a1d48-3b8c3a4c5611714e.elb.eu-north-1.amazonaws.com` only the first part that corresponds to the ELB identifier `a8b4bc81a22f3423ea48f2326e0a1d48`
- `cut -d'-' -f1` splits the string at the - character and selects the first field `-f1`
- Option `--query 'NetworkInterfaces[*].Association.PublicIp'` 
- `NetworkInterfaces[*]`: This syntax uses JMESPath, a query language for JSON.
- `NetworkInterfaces` is an array containing all network interfaces that match the given filters. The asterisk [*] indicates that the query is for all elements of the array, i.e. all network interfaces that are returned by the command.
- `.Association` refers to a property that contains information about the associations of this interface. This may include data such as associations to public IP addresses or other resources.
- `.PublicIp`: This option selects only public IP addresses from the association information of each network interface. If the network interface is associated with a public IP, that IP will be returned; if there is no association, the result will be null or a missing value.

- Essentially, this command is executed
```bash
aws ec2 describe-network-interfaces \
--filters "Name=description,Values='ELB net/a8b4bc81a22f3423ea48f2326e0a1d48*'" \
--query 'NetworkInterfaces[*].{NetworkInterfaceId:NetworkInterfaceId, Description:Description, Association:Association}'
```
![final-3 (1).jpg](screenshots%2Ftask-3%2Ffinal-3%20%281%29.jpg)

3. Start from scratch fully automatic cluster deployment
```bash
rm -f terraform.tfstate \
&& rm -f terraform.tfstate.backup \
&& rm -f tfplan
terraform init
terraform plan -out=tfplan
terraform apply tfplan
aws eks update-kubeconfig --region eu-north-1 --name yourhostel # if necessary, update the config
```
![final-3 (2).jpg](screenshots%2Ftask-3%2Ffinal-3%20%282%29.jpg)
![final-3 (3).jpg](screenshots%2Ftask-3%2Ffinal-3%20%283%29.jpg)
![final-3 (4).jpg](screenshots%2Ftask-3%2Ffinal-3%20%284%29.jpg)
4. Created module [dns_updater](https://github.com/yourhostel/hw_devops/tree/main/module_4/homework-step-final/terraform/modules/dns_updater) for updating DNS records.

5. Added a script [update_dns.py](https://github.com/yourhostel/hw_devops/blob/main/module_4/homework-step-final/terraform/modules/dns_updater/update_dns.py) for automatic update of DNS records of type A of subdomain final.tyshchenko.online via API interface of hosting provider ukraine.com.ua.
![final-3 (5).jpg](screenshots%2Ftask-3%2Ffinal-3%20%285%29.jpg)
- Checking
![final-3 (6).jpg](screenshots%2Ftask-3%2Ffinal-3%20%286%29.jpg)
![final-3 (7).jpg](screenshots%2Ftask-3%2Ffinal-3%20%287%29.jpg)
6. The script [update_dns.py](https://github.com/yourhostel/hw_devops/blob/main/module_4/homework-step-final/terraform/modules/dns_updater/update_dns.py) has been updated with the logic for installing an ALIAS record in the final.tyshchenko.online domain. If it is missing, then A-type records are installed (effective only if there is one subnet and it is not possible to install CNAME, ALIAS or ANAME).
- A check for balancer readiness has also been added.
```py
    max_attempts = 10
    attempt = 0
    successful = False

    while attempt < max_attempts and not successful:
        data = {
            "data": subdomain_alias,
            "subdomain_id": subdomain_alias_id,
            "priority": priority
        }
        response = requests.post(url, headers=headers, data=data)
        if response.status_code == 200:
            successful = True
        else:
            time.sleep(30)  # Wait before retrying
        attempt += 1

    if successful:
        responses[subdomain_alias] = response.json()
    else:
        responses['error'] = "Failed to update DNS after multiple attempts"
```
![final-3 (8).jpg](screenshots%2Ftask-3%2Ffinal-3%20%288%29.jpg)
![final-3 (9).jpg](screenshots%2Ftask-3%2Ffinal-3%20%289%29.jpg)
7. Installing [Cert Manager](https://github.com/yourhostel/hw_devops/blob/main/module_4/homework-step-final/terraform/modules/cert_manager/main.tf) and creating kubernetes_manifests:[cluster_issuer, https_ingress](https://github.com/yourhostel/hw_devops/blob/main/module_4/homework-step-final/terraform/modules/issuer/main.tf)
- The issuer module should be uncommented in the [main file](https://github.com/yourhostel/hw_devops/blob/main/module_4/homework-step-final/terraform/main.tf) only after the cluster is fully deployed.
- After checking the http availability, you need to uncomment this module, update and apply the plan.
```HCL
module "issuer" {
  source = "./modules/issuer"
  depends_on = [module.cert_manager]

  providers = {
    kubernetes = kubernetes
    helm       = helm
  }
}
```
![final-3 (10).jpg](screenshots%2Ftask-3%2Ffinal-3%20%2810%29.jpg)
![final-3 (11).jpg](screenshots%2Ftask-3%2Ffinal-3%20%2811%29.jpg)
![final-3 (12).jpg](screenshots%2Ftask-3%2Ffinal-3%20%2812%29.jpg)
### Useful commands:
```bash
kubectl get certificates -A
kubectl describe ingress https-ingress -n default
curl -vI https://final.tyshchenko.online
kubectl describe clusterissuer letsencrypt-prod -n cert-manager
kubectl describe certificate <certificate_name> -n default # my certificate name final-tyshchenko-online-tls
kubectl logs -l app.kubernetes.io/instance=cert-manager -n cert-manager
# certificate validity period
echo | openssl s_client -connect final.tyshchenko.online:443 2>/dev/null | openssl x509 -noout -dates
```