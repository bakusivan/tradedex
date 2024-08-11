# TOFU

## export this vars:

export AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id)
export AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key)
export AWS_DEFAULT_REGION=$(aws configure get region)

## run these commands:

podman run --rm -it -v $(pwd):/workspace -w /workspace ghcr.io/opentofu/opentofu:latest init

podman run --rm -it -v $(pwd):/workspace -w /workspace -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY -e AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION ghcr.io/opentofu/opentofu:latest apply -auto-approve

podman run --rm -it -v $(pwd):/workspace -w /workspace -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY -e AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION ghcr.io/opentofu/opentofu:latest destroy -auto-approve
