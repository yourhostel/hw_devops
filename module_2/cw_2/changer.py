import os

file_path = "/home/tysser/PycharmProjects/hw_devops/module_2/cw_2/project/variable.tf"

new_value = 'm5.large'

with open(file_path, 'r') as file:
    file_data = file.read()

new_file_data = file_data.replace('default     = "t2.micro"', f'default     = "{new_value}"')

with open(file_path, 'w') as file:
    file.write(new_file_data)

print(f'Value in variable.tf has been changed to {new_value}')



# from pathlib import Path
# from git import Repo
#
# home_dir = Path.home()
# project_dir = Path.home() / "PycharmProjects" / "hw_devops" / "module_2" / "cw_2" / "project"
#
# print(project_dir)
# repo_url = "git@github.com:yourhostel/terraform.git"
#
#
# def clone_repo():
#     local_path = project_dir
#     try:
#         Repo.clone_from(repo_url, local_path)
#         print(f"Git repository cloned successfully in {local_path}")
#     except Exception as e:
#         print(f"Error with cloning repo: {e}")
#
#
# clone_repo()
