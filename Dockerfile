ARG AWS_CLI_VERSION=2.2.15
ARG TERRAFORM_VERSION=0.15.5

FROM amazonlinux:2 as terraform
ARG TERRAFORM_VERSION
RUN yum update -y \
    && yum install -y unzip \
    && curl -sSO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && unzip -j terraform_${TERRAFORM_VERSION}_linux_amd64.zip

FROM amazonlinux:2 as aws-cli
ARG AWS_CLI_VERSION
RUN yum update -y \
    && yum install -y unzip \
    && curl -sSO https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWS_CLI_VERSION}.zip \
    && unzip awscli-exe-linux-x86_64-${AWS_CLI_VERSION}.zip \
    && ./aws/install --bin-dir /aws-cli-bin

FROM amazonlinux:2
RUN yum update -y \
    && yum install -y \
        groff \
        jq \
        less \
    && yum clean all \
    && rm -rf /var/cache/yum
COPY --from=terraform /terraform /usr/local/bin/
COPY --from=aws-cli /usr/local/aws-cli/ /usr/local/aws-cli/
COPY --from=aws-cli /aws-cli-bin/ /usr/local/bin/
WORKDIR /workspace
ENTRYPOINT ["terraform"]
