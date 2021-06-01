ARG AWS_CLI_VERSION=2.2.7
ARG TERRAFORM_VERSION=0.15.4

FROM amazonlinux:2 as installer
ARG TERRAFORM_VERSION
RUN yum update -y \
    && yum install -y unzip \
    && curl -sSO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && unzip -j terraform_${TERRAFORM_VERSION}_linux_amd64.zip

FROM amazon/aws-cli:${AWS_CLI_VERSION}
RUN yum update -y \
    && yum install -y jq \
    && yum clean all \
    && rm -rf /var/cache/yum
COPY --from=installer /terraform /usr/local/bin/
WORKDIR /workspace
ENTRYPOINT ["terraform"]
