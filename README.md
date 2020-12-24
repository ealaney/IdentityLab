# Identity Lab

IdentityLab seeks to provide an automated, standardized way in which to explore Identity and Access Management (IAM) topics, procedures, and products.

## Purpose

When exploring Identity and Access Management concepts and software, one of the big challenges is trying to experiment with realistic scenarios and data while protecting the production environments that you want to ultimately protect.

This lab seeks to allow the user to explore Identity and Access Management (IAM) concepts, ideas, practices, and products, using the most common infrastructure and endpoints. By building on top of the DetectionLab project, IdentityLab provides a Windows domain with security tools and best practices for system logging, enabling easier review of the impact of IAM products and procedures.

Using the BadBlood toolkit, it is possible to populate the Active Directory domain with test data.  This can aid in IAM experiments that target Active Directory and Windows.

## Products

The IAM server includes scripts to install and configure the following IAM products:

* [WSO2 Identity Server](https://wso2.com/identity-and-access-management/) [on GitHub](https://github.com/wso2/product-is/releases/latest)

### Products Under Consideration

* [Aerobase](https://aerobase.io/iam)
* [Apache Syncope](https://syncope.apache.org/) - identity lifecycle management, identity storage, provisioning engines, and access management
* [Central Authentication Services (CAS)](https://www.apereo.org/projects/cas)
* [FreeIPA](https://www.freeipa.org/page/Main_Page) - centralized authentication and authorization for Linux systems. This is the "Identity Server" role previously bundled with Red Hat Enterprise Linux / CentOS.
* [MidPoint](https://evolveum.com/midpoint/) - identity management and identity governance
* [OpenIAM](https://www.openiam.com/) - single sign-on, user and group management, flexible authentication, and automated provisioning. An Identity Governance product is also available.
* [Shibboleth Consortium](https://www.shibboleth.net/) - web single sign-on, authentication, and user data aggregation. Can perform policy enforcement on authentication requests.
* [Soffid](http://www.soffid.com/) - single sign-on and identity management through identity provisioning, workflow features, reporting, and a unified directory.

---

NOTE: The DetectionLab warning bears repeating. This lab has not been hardened and runs with default vagrant credentials. Please do not connect or bridge it to any networks you care about. This lab is deliberately designed to be insecure; the primary purpose of it is to provide visibility and introspection into each host.

## Acknowledgements

IdentityLab stands on the shoulders of Chris Long's excellent DetectionLab project. Read more about Detection Lab on the [project web site](https://detectionlab.network/) or on [GitHub](https://github.com/clong/DetectionLab) or on [Medium](https://medium.com/@clong/introducing-detection-lab-61db34bed6ae)

## Building Identity Lab

*Note*: If you only want to run hosts, you only need a valid, working Vagrant environment.

Being based on Detection Lab, Identity Lab has the same requirements. Check the Detection Lab requirements as described in the following links.

* [Prerequisites](https://www.detectionlab.network/introduction/prerequisites/)
* [MacOS - Virtualbox or VMware Fusion](https://www.detectionlab.network/deployment/macosvm/)
* [Windows - Virtualbox or VMware Workstation](https://www.detectionlab.network/deployment/windowsvm/)
* [Linux - Virtualbox or VMware Workstation](https://www.detectionlab.network/deployment/linuxvm/)
* [AWS via Terraform](https://www.detectionlab.network/deployment/aws/)
* [Azure via Terraform & Ansible](https://www.detectionlab.network/deployment/azure/)
* [ESXi via Terraform & Ansible](https://www.detectionlab.network/deployment/esxi/)
* [HyperV](https://www.detectionlab.network/deployment/hyperv/)
* [LibVirt](https://www.detectionlab.network/deployment/libvirt/)

---

## Documentation

In progress.

---

## Contributing

Do you have an IAM solution or package that you would like to see included in Identity Lab?  Open an issue and let's discuss it!

If you want to contribute code, please do all of your development in a feature branch on your own fork of IdentityLab. Contribution guidelines can be found here: [CONTRIBUTING.md](./CONTRIBUTING.md)
