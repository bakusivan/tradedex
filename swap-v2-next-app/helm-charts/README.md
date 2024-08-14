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

helm install swap-v2-next-app ./helm-charts

# TODO; test this

## ExternalDNS - godaddy.com example

helm repo add bitnami https://charts.bitnami.com/bitnami

helm install external-dns bitnami/external-dns \
  --set provider=godaddy \
  --set godaddy.apiKey="YOUR_GODADDY_API_KEY" \
  --set godaddy.apiSecret="YOUR_GODADDY_API_SECRET" \
  --set godaddy.domainFilters={yourdomain.com} \
  --set txtOwnerId="YOUR_CLUSTER_NAME"
