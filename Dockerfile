ARG TERRAFORM_VERSION=0.15.4
ARG AWS_CLI_VERSION=2.2.7

FROM amazon/aws-cli:${AWS_CLI_VERSION}

RUN yum update -y \
    && yum install -y yum-utils \
    && yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo \
    && yum install -y jq terraform-${TERRAFORM_VERSION} \
    && yum clean all

WORKDIR /workspace
ENTRYPOINT ["terraform"]
