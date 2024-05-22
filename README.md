# Cisco SDWAN aaC

```text

            ┌───────────────────────────────┐
            │          cisco.sdwan          │
            └───────▲───────────────▲───────┘
                    │               │
             ┌──────┘               └──────┐
             │                             │
 ┌───────────┴──────────────┐    ┌─────────┴──────────┐
 │  cisco.sdwan_deployment  │    │ cisco.catalystwan  │
 └──────────────────────────┘    └────────────────────┘

```

[ansible-collection-sdwan](https://github.com/cisco-open/ansible-collection-sdwan) combine [SDWAN Deployment](https://github.com/cisco-open/ansible-collection-sdwan-deployment) and
[Ansible Wrapper using catalystwan library](https://github.com/cisco-open/ansible-collection-catalystwan) collections inside one tool.

Let users to fully deploy, onboard and upgrade their SD-WAN topology.

## Table of Contents

- [Overview](#overview)
- [Requirements](#requirements)
- [Installing this collection](#installing-this-collection)
- [Using this collection](#using-this-collection)
- [Troubleshooting](#troubleshooting)
- [Containerized variant WIP](#containerized-variant-wip)
- [Contributing](#contributing)
- [Useful links and Getting Started](#useful-links-and-getting-started)
- [License](#license)
- [Code of Conduct](#code-of-conduct)
- [Releasing, Versioning and Depracation](#releasing-versioning-and-deprecation)

---

## Overview

[ansible-collection-sdwan](https://github.com/cisco-open/ansible-collection-sdwan) integrates the roles and modules from both repositories to create an automation workflow for Cisco SD-WAN.
By leveraging these Ansible resources, [ansible-collection-sdwan](https://github.com/cisco-open/ansible-collection-sdwan) empowers network administrators to:

- Automate Deployment: Roll out and provision Cisco SD-WAN controllers and edge devices with minimal manual intervention using [SDWAN Deployment](https://github.com/cisco-open/ansible-collection-sdwan-deployment) roles.
- Onboarding of Controllers and Edge Devices: Simplify the process of integrating controllers and edge devices into the Cisco SD-WAN fabric, using automated deployment with PnP (Plug-and-Play), using [ansible-collection-catalystwan](https://github.com/cisco-open/ansible-collection-catalystwan) modules and roles.
- Workflow for Upgrades: Structured workflow that automates the upgrade process for controllers and edge devices.

[ansible-collection-sdwan](https://github.com/cisco-open/ansible-collection-sdwan) illustrates the power of Ansible's modularity and the significant benefits of using roles, custom modules, and collections for automating network operations. It stands as an indispensable resource for organizations looking to implement Infrastructure as Code (IaC) within their network infrastructure and embrace a more agile and DevOps-oriented approach to network management.

## Requirements

This project utilizes a tech stack that includes Python, Ansible (and Ansible Galaxy), AWS cloud (Boto/Boto3, authentication with AWS CLI)
Azure cloud (ansible azure collection) and finally Cisco SD-WAN.
Below you will find the necessary information to set up your environment.

Before you begin, ensure that you have administrative access to your machine to install the required software.

See section [Useful links and Getting Started](#useful-links-and-getting-started) for more in-depth documentation.

### Operating System Requirements

This project is cross-platform and can be set up on the following operating systems:

- Linux (Ubuntu, CentOS, Debian, etc.)
- macOS
- Windows (Note: Some tools might require Windows Subsystem for Linux (WSL) for full functionality)

### Python requirement

Supported version: Python >=3.10+

- Due to [ansible-core==2.16](https://docs.ansible.com/ansible/latest/reference_appendices/release_and_maintenance.html#ansible-core-support-matrix) requirement, this collection requires Python 3.10 or greater.

### Cloud authentication requirement

Verify that you have access to create resources with your provider:

#### AWS

- See [AWS Ansible Authentication docs](https://docs.ansible.com/ansible/latest/collections/amazon/aws/docsite/guide_aws.html#authentication) to learn more.

- See [AWS CLI configuration](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html) to learn more.

#### Azure

- See [Authenticating with Azure](https://docs.ansible.com/ansible/latest/scenario_guides/guide_azure.html#authenticating-with-azure)

### PnP Portal requirement

Current version of the full workflow for bringup SD-WAN assumes that users are familiar with [Cisco Plug and Play Portal](https://software.cisco.com/) and its requirements.

- See example [Cisco Plug and Play Support Guide for Cisco SD-WAN Products](https://www.cisco.com/c/dam/en_us/services/downloads/SD-WAN_pnp_support_guide.pdf).

---

## Installing this collection

### Install by cloning this repostiory - recommended way

You can install collection by first cloning this repository:

```bash
git clone git@github.com:cisco-open/ansible-collection-sdwan.git
```

Then setting your python environment.
Recommended way: use supported version of Python (>=3.10) and set up your environment with:

```bash
python3 -m venv <your-venv-name>
source <your-venv-name>/bin/activate
pip install -r requirements.txt --no-deps
```

And then install ansible requirements:

```bash
ansible-galaxy install -r requirements.yml
```

### Install with Ansible Galaxy

***Note*** that when installing this collection with `ansible-galaxy` command, it will be placed inside your system collections path. That migth introduce additional complexity for using configuration files etc.

You can install this collection with the Ansible Galaxy CLI (requires `ansible` package installed)

```bash
ansible-galaxy collection install cisco.sdwan
```

The python module dependencies are not installed by ansible-galaxy. They can be manually installed using pip.
Recommended way: use supported version of Python (>=3.10) and set up your environment with:

```bash
python3 -m venv <your-venv-name>
source <your-venv-name>/bin/activate
```

And then install python requirements:

```bash
pip install -r requirements.txt --no-deps
```

</br></br>

***Note***: For python packages installation troubleshooting see [python-packages-installation](#5-python-packages-installation)

Verify that your ansible version is using python modules from vevn by using test playbook:

For AWS:

```bash
ansible-playbook playbooks/aws/test_env.yml
```

For Azure:

```bash
ansible-playbook playbooks/azure/test_env.yml
```

If playbook finished without any failed tasks, environment is ready for next tasks.

If requirements have been installed and tasks returned information about missing packages, please see [Troubleshooting](#troubleshooting)

## Using this collection

### Ansible Vault prerequisite

In this section, suggested usage of Ansible Vault with Vault password stored in files is presented.
While not mandatory, it is recommended to utilize Ansible Vault for securing sensitive data such as credentials and secret keys.
Ansible Vault provides encryption capabilities that help in maintaining the security of your secrets within your playbooks.
However, the management of secrets is ultimately at your discretion, and you may employ any other method that aligns with your security policies and operational practices.
Feel free to use any other manager to encrypt `pnp_username` and `pnp_password` variables.

#### Using Ansible Vault to securely provide PnP Portal credentials

First, create file with ansible-valut password that will be used to secure your vault.
Example file: `vault-password.txt`, created with content:

```txt
mysafepassword
```

Then, supply values for pnp credentials in pnp_credentials.yml file. For azure you can use `playbooks/azure/pnp_credentials.yml`
and for aws `playbooks/aws/pnp_credentials.yml`.

Encrypt the pnp credentials file with your valut password by running:

```bash
ansible-vault encrypt --vault-password-file=vault-password.txt playbooks/azure/pnp_credentials.yml
```

From now, `playbooks/azure/pnp_credentials.yml` or `playbooks/aws/pnp_credentials.yml` file will be encrypted.

In order to run playbook that requires pnp_credentials, users have to specify path for ansible vault password file.
Example:

```bash
ansible-playbook playbooks/azure/test_vault_usage.yml --vault-password-file=vault-password.txt
```

### Configuration file

Full deployment and onboarding comes with predefined configuration file, that will bringup 3 controllers and all edge devices
configured in PnP portal. It's user responsibility to ensure that PnP Portal configuration is correct and fautless.

Configuration file is located in:

- for Azure: `playbooks/azure/sdwan_config.yml`
- for AWS: `playbooks/aws/sdwan_config.yml`.

Please complete all fields marked as `null`.

Please see [Prerequisites for Deploying Cisco SD-WAN Controllers in AWS
](https://www.cisco.com/c/en/us/td/docs/routers/sdwan/configuration/sdwan-xe-gs-book/controller-aws.html#Cisco_Concept.dita_f1fa60cb-2f60-4350-ae74-1090073ca4be) and
[Deploy Cisco SD-WAN Controllers in AWS: Tasks](https://www.cisco.com/c/en/us/td/docs/routers/sdwan/configuration/sdwan-xe-gs-book/controller-aws.html#Cisco_Concept.dita_cf1bc9b2-5641-4ebc-b571-20849085bde4) in order to learn more about prerequisites and AMI Images on AWS.

Additional step: verify that your configuration file include all required variables, by running this pre-check playbook:

AWS:

```bash
ansible-playbook playbooks/aws/test_variables.yml --vault-password-file=vault-password.txt
```

Azure:

```bash
ansible-playbook playbooks/aws/test_variables.yml --vault-password-file=vault-password.txt
```

### Final run

Finally, run full playbook, depending on your cloud provider:

```bash
ansible-playbook playbooks/azure/full_deploy_and_configure.yml --vault-password-file=vault-password.txt
```

```bash
ansible-playbook playbooks/aws/full_deploy_and_configure.yml --vault-password-file=vault-password.txt
```

---

## Troubleshooting

Follow these steps to troubleshoot common issues:

### 1. Verify Your Ansible Version and Virtual Environment

Activate your virtual environment and run the command:

```bash
(example-venv) ➜  cisco.sdwan git:(master) ✗ ansible --version
```

Check that the 'ansible python module location' points to your virtual environment, for instance: `/Users/myuser/Work/cisco.sdwan/example-venv`.

### 2. Correct Ansible Version Pointing to the Wrong Virtual Environment

If Ansible is pointing to the wrong virtual environment, modify the `sdwan_config.yml` configuration file. Add this line:

```yml
ansible_python_interpreter: "/<path-to-your-venv>/bin/python"
```

Replace `<path-to-your-venv>` with the correct path.

### 3. Update Ansible Collections

To update your Ansible collections, run the following command:

```bash
ansible-galaxy collection install -r requirements.yml --upgrade
```

### 4. Double-Check Ansible Collection Installation Location

Ansible defaults to installing the collection in `~/.ansible/collections`. This can cause problems if you're using the wrong collection version. Ensure your collection version is correct if you run into issues.

### 5. Python packages installation

Python packages requirements are formed to include all dependencies.
Therefore if you face issues with installation, note that there is known confict:

```log
    The user requested packaging
    catalystwan 0.31.2 depends on packaging<24.0 and >=23.0
    azure-cli-core 2.34.0 depends on packaging<22.0 and >=20.9
```

solved by using: `pip install -r requirements.txt --no-deps` command.

---

## Containerized variant WIP

Section Under Construction!

---

## Useful links and Getting Started

### Python

- [Download Python](https://www.python.org/downloads/)
- [Getting Started with Python](https://docs.python.org/3/using/index.html)

### Virtual Environment (venv)

To manage dependencies, it is recommended to use Python's built-in `venv` module to create a virtual environment.

- [Creating Virtual Environments](https://docs.python.org/3/library/venv.html)

### Ansible

- [Install Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
- [Getting Started with Ansible](https://docs.ansible.com/ansible/latest/user_guide/intro_getting_started.html)

### Ansible Galaxy

Ansible Galaxy provides pre-packaged units of work known as roles, and it can be used to share and use content with Ansible.

- [Using Ansible Galaxy](https://galaxy.ansible.com/docs/)

### Ansible Vault

- [Protecting sensitive data with Ansible vault](https://docs.ansible.com/ansible/latest/vault_guide/index.html)

### AWS CLI

- [Installing AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)
- [Configuring the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html)

### AWS Authentication

- [Understanding and Getting Your Security Credentials](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html)
- [Configuring AWS Credentials](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html)

### Azure Authentication

- [Authenticating with Azure](https://docs.ansible.com/ansible/latest/scenario_guides/guide_azure.html#authenticating-with-azure)

### Cisco SD-WAN

- [Cisco SD-WAN Overview](https://www.cisco.com/c/en/us/solutions/enterprise-networks/sd-wan/index.html)
- [Cisco SD-WAN Documentation](https://www.cisco.com/c/en/us/support/routers/sd-wan/products-installation-and-configuration-guides-list.html)

---

## License

See [LICENSE](./LICENSE) file.

## Contributing

See [Contributing](./docs/CONTRIBUTING.md) file.

## Code of Conduct

See [Code of Conduct](./docs/CODE_OF_CONDUCT.md) file.

## Releasing, Versioning and Deprecation

This collection follows Semantic Versioning. More details on versioning can be found in [Understanding collection versioning](https://docs.ansible.com/ansible/latest/dev_guide/developing_collections_distributing.html#understanding-collection-versioning).

New minor and major releases as well as deprecations will follow new releases and deprecations of the Cisco Catalystwan SDK, a Python SDK, which this project relies on.
