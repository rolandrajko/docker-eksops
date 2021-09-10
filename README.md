# eksops Docker image

Based on [amazonlinux:2](https://hub.docker.com/_/amazonlinux) Docker image.

Utilities included:
- AWS CLI v2
- Helm v3
- jq
- kubectl
- Terraform v1

## Usage

```
docker run --rm -it \
    -v ${PWD}:/workspace \
    -e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
    -e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
    -e AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION} \
    -e TF_CLI_CONFIG_FILE=/workspace/.terraformrc \
    rolandrajko/eksops
```
