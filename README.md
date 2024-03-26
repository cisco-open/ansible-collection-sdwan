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
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [Troubleshooting](#troubleshooting)
- [Containerized variant WIP](#containerized-variant-wip)
- [Useful links and Getting Started](#useful-links-and-getting-started)
- [License](#license)
- [Contributing](#contributing)

---

## Overview

[ansible-collection-sdwan](https://github.com/cisco-open/ansible-collection-sdwan) integrates the roles and modules from both repositories to create an automation workflow for Cisco SD-WAN.
By leveraging these Ansible resources, [ansible-collection-sdwan](https://github.com/cisco-open/ansible-collection-sdwan) empowers network administrators to:

- Automate Deployment: Roll out and provision Cisco SD-WAN controllers and edge devices with minimal manual intervention using [SDWAN Deployment](https://github.com/cisco-open/ansible-collection-sdwan-deployment) roles.
- Onboarding of Controllers and Edge Devices: Simplify the process of integrating controllers and edge devices into the Cisco SD-WAN fabric, using automated deployment with PnP (Plug-and-Play), using [ansible-collection-catalystwan](https://github.com/cisco-open/ansible-collection-catalystwan) modules and roles.
- Workflow for Upgrades: Structured workflow that automates the upgrade process for controllers and edge devices.

[ansible-collection-sdwan](https://github.com/cisco-open/ansible-collection-sdwan) illustrates the power of Ansible's modularity and the significant benefits of using roles, custom modules, and collections for automating network operations. It stands as an indispensable resource for organizations looking to implement Infrastructure as Code (IaC) within their network infrastructure and embrace a more agile and DevOps-oriented approach to network management.

## Prerequisites

This project utilizes a tech stack that includes Python, Ansible (and Ansible Galaxy), Boto/Boto3, authentication with AWS CLI, and finally Cisco SD-WAN.
Below you will find the necessary information to set up your environment.

Before you begin, ensure that you have administrative access to your machine to install the required software.

See section [Useful links and Getting Started](#useful-links-and-getting-started) for more in-depth documentation.

### Operating System Requirements

This project is cross-platform and can be set up on the following operating systems:

- Linux (Ubuntu, CentOS, Debian, etc.)
- macOS
- Windows (Note: Some tools might require Windows Subsystem for Linux (WSL) for full functionality)

### Python requirement

Supported version: Python >=3.8+

- Due to the [AWS SDK Python Support Policy](https://aws.amazon.com/blogs/developer/python-support-policy-updates-for-aws-sdks-and-tools/) this collection requires Python 3.8 or greater.

- Due to the requirement of [catalystwan](https://github.com/CiscoDevNet/catalystwan), this collection requires Python 3.8 or greater.

### Cloud authentication requirement

Verify that you have access to create resources with provider - AWS.

- See [AWS Ansible Authentication docs](https://docs.ansible.com/ansible/latest/collections/amazon/aws/docsite/guide_aws.html#authentication) to learn more.

- See [AWS CLI configuration](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html) to learn more.

### PnP Portal requirement

Current version of the full workflow for bringup SD-WAN assumes that users are familiar with [Cisco Plug and Play Portal](https://software.cisco.com/) and its requirements.

- See example [Cisco Plug and Play Support Guide for Cisco SD-WAN Products](https://www.cisco.com/c/dam/en_us/services/downloads/SD-WAN_pnp_support_guide.pdf).

---

## Installation

With supported version of Python installed, you can first set up your environment with:

```bash
python3 -m venv <your-venv-name>
source <your-venv-name>/bin/activate
```

And then install python and ansible requirements:

```bash
pip install -r requirements.txt
ansible-galaxy install -r requirements.yml
```

Verify that your ansible version is using python modules from vevn by using test playbook:

```bash
ansible-playbook playbooks/test_env.yml
```

If playbook finished without any failed tasks, environment is ready for next tasks.

If requirements have been installed and tasks returned information about missing packages, please see [Troubleshooting](#troubleshooting)

## Usage

### Configuration file

Full deployment and onboarding comes with predefined configuration file, that will bringup 3 controllers and all edge devices
configured in PnP portal. It's user responsibility to ensure that PnP Portal configuration is correct and fautless.

Configuration file is located in `playbooks/sdwan_config.yml`. Please complete all fields marked as `null`.

Please see [Prerequisites for Deploying Cisco SD-WAN Controllers in AWS
](https://www.cisco.com/c/en/us/td/docs/routers/sdwan/configuration/sdwan-xe-gs-book/controller-aws.html#Cisco_Concept.dita_f1fa60cb-2f60-4350-ae74-1090073ca4be) and
[Deploy Cisco SD-WAN Controllers in AWS: Tasks](https://www.cisco.com/c/en/us/td/docs/routers/sdwan/configuration/sdwan-xe-gs-book/controller-aws.html#Cisco_Concept.dita_cf1bc9b2-5641-4ebc-b571-20849085bde4) in order to learn more about prerequisites and AMI Images on AWS.

Additional step: verify that your configuration file include all required variables, by running this pre-check playbook:

```bash
ansible-playbook playbooks/test_variables.yml
```

### Final run

Finally, run full playbook:

```bash
ansible-playbook playbooks/full_deploy_and_configure.yml
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

If Ansible is pointing to the wrong virtual environment, modify the `playbooks/sdwan_config.yml` configuration file. Add this line:

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

### AWS CLI

- [Installing AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)
- [Configuring the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html)

### AWS Authentication

- [Understanding and Getting Your Security Credentials](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html)
- [Configuring AWS Credentials](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html)

### Cisco SD-WAN

- [Cisco SD-WAN Overview](https://www.cisco.com/c/en/us/solutions/enterprise-networks/sd-wan/index.html)
- [Cisco SD-WAN Documentation](https://www.cisco.com/c/en/us/support/routers/sd-wan/products-installation-and-configuration-guides-list.html)

---

## License

See [LICENSE](./LICENSE) file.

## Contributing

See [Contributing](./docs/CONTRIBUTING.md) file.
