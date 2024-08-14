# helm

## you need to export this vars [check details in ../env.example]

export NEXT_PUBLIC_WALLET_CONNECT_PROJECT_ID="your key"
export NEXT_PUBLIC_ZEROEX_API_KEY="your key"

## configure kubectl with aws cli

aws eks --region [your-region] update-kubeconfig --name [your-cluster-name]

aws eks --region eu-north-1 update-kubeconfig --name my-eks-cluster

## configure registry secrets

USERNAME=$(git config --global user.name)

EMAIL=$(git config --global user.email)

export CR_PAT="your github registry token"

echo $CR_PAT | podman login ghcr.io -u USERNAME --password-stdin

kubectl create secret docker-registry ghcr-secret \
  --docker-server=ghcr.io \
  --docker-username=$USERNAME \
  --docker-password=$CR_PAT \
  --docker-email=$EMAIL

## helm command

helm install swap-v2-next-app ./helm-charts \
  --set env.NEXT_PUBLIC_WALLET_CONNECT_PROJECT_ID=$NEXT_PUBLIC_WALLET_CONNECT_PROJECT_ID \
  --set env.NEXT_PUBLIC_ZEROEX_API_KEY=$NEXT_PUBLIC_ZEROEX_API_KEY
