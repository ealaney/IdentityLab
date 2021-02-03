# Identity Lab

Identity Lab seeks to provide an automated, standardized way in which to explore Identity and Access Management (IAM) topics, procedures, and products.

## Purpose

When exploring Identity and Access Management concepts and software, one of the big challenges is trying to experiment with realistic scenarios and data while protecting the production environments that you want to ultimately protect.

This lab seeks to allow the user to explore Identity and Access Management (IAM) concepts, ideas, practices, and products, using the most common infrastructure and endpoint types. Providing a hands-on approach instead of a theoretical one has always worked better for me, and I hope it does for you too.

## Products

The IAM server includes scripts to install and configure the following IAM products:

* [WSO2 Identity Server](https://wso2.com/identity-and-access-management/) (also on [GitHub](https://github.com/wso2/product-is/releases/latest))

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

**NOTE**: This lab is deliberately designed to be insecure. It has not been hardened and runs with default vagrant credentials. Its primary purpose is to provide visibility into each application, host, and resource. Please do not connect or bridge it to any networks you care about.

## Acknowledgements

Identity Lab incorporates Chris Long's excellent Detection Lab project. Detection Lab demonstrated how to automated the building of a Windows Domain Controller, a task that had previously seemed too massive to tackle. Once I cleared that hurdle, the rest of the path became clear. Read more about Detection Lab on the [project web site](https://detectionlab.network/) or on [GitHub](https://github.com/clong/DetectionLab) or on [Medium](https://medium.com/@clong/introducing-detection-lab-61db34bed6ae). By incorporating the Detection Lab project, Identity Lab is able to provide a Windows domain with security tools and consolidated system logging, enabling easier review of the impact of IAM products and procedures.

Identity Lab also incorporates the [BadBlood](https://kalilinuxtutorials.com/badblood/) toolkit, populating the lab's Active Directory domain with test data.  This can aid in IAM experiments that target Active Directory and Windows. You can get more information on the [project web site](https://kalilinuxtutorials.com/badblood/) or on [GitHub](https://github.com/davidprowe/badblood). **Caution: BadBlood makes irrevocable changes to the AD domain against which it runs.**

The sample applications are mostly from the [WSO2](https://wso2.com/) Sample Applications project. You can read more in the WSO2 [Tutorial](https://is.docs.wso2.com/en/5.10.0/learn/deploying-the-sample-app/) or check out the [GitHub repo](https://github.com/wso2/samples-is/).

## Building Identity Lab

If you only want to run hosts, you only need a valid, working Vagrant environment with sufficient resources to run the machine images. If you want to customize the machine images used in Identity Lab, you will need additional tools and resources.

### Running with Vagrant

Identity Lab was developed on Windows and Ubuntu Linux using Vagrant 2.2.14 with an Oracle VirtualBox 6.1 provider. Vagrant supports other host OSes and providers, but while those should work fine, they have not been tested. At this time, I cannot provide assistance with other providers.

* 55GB+ of free disk space
* 16GB+ of RAM highly recommended (for reference, my test machine has 32GB and 48GB, respectively)
* Vagrant 2.2.9+
* Oracle VM VirtualBox 6.1.16+

**Note**: I encountered a bug in VirtualBox 6.1.14 that caused Vagrant machine builds to fail. This bug was fixed in 6.1.16.

### Customizing Images

If you want to customize the machine images by building your own Vagrant boxes, you will also need the following resources:

* Packer 1.6.0+

Incorporating the Detection Lab project means Identity Lab has many of the same requirements. You should also check the Detection Lab requirements as described on the project web site. These resources may provide enough information to get Identity Lab running on a different Vagrant provider, such as LibVirt or AWS.

* [Detection Lab Prerequisites](https://www.detectionlab.network/introduction/prerequisites/)

---

## Documentation

In progress.

---

## Contributing

Do you have an IAM solution or package that you would like to see included in Identity Lab?  Open an issue and let's discuss it!

If you want to contribute code, please do all of your development in a feature branch on your own fork of Identity Lab. Contribution guidelines can be found here: [CONTRIBUTING.md](./CONTRIBUTING.md)
