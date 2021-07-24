ARG AWS_CLI_VERSION=2.2.22
ARG KUBECTL_VERSION=1.21.3
ARG TERRAFORM_VERSION=1.0.3

FROM amazonlinux:2 as aws-cli
ARG AWS_CLI_VERSION
RUN yum update -y \
    && yum install -y unzip \
    && curl -sSO https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWS_CLI_VERSION}.zip \
    && unzip awscli-exe-linux-x86_64-${AWS_CLI_VERSION}.zip \
    && ./aws/install --bin-dir /aws-cli-bin

FROM amazonlinux:2 as terraform
ARG TERRAFORM_VERSION
RUN yum update -y \
    && yum install -y unzip \
    && curl -sSO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && unzip -j terraform_${TERRAFORM_VERSION}_linux_amd64.zip

FROM amazonlinux:2 as kubectl
ARG KUBECTL_VERSION
RUN curl -sSLO https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
    curl -sSLO https://dl.k8s.io/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl.sha256 \
    echo "$(<kubectl.sha256) kubectl" | sha256sum --check \
    chmod +x kubectl

FROM amazonlinux:2
RUN yum update -y \
    && yum install -y \
        gettext \
        groff \
        jq \
        less \
    && yum clean all \
    && rm -rf /var/cache/yum
COPY --from=aws-cli /usr/local/aws-cli/ /usr/local/aws-cli/
COPY --from=aws-cli /aws-cli-bin/ /usr/local/bin/
COPY --from=kubectl /kubectl /usr/local/bin/
COPY --from=terraform /terraform /usr/local/bin/
WORKDIR /workspace
ENTRYPOINT ["terraform"]
