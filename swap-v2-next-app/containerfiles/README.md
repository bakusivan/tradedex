# podman / docker

## if you build your images with docker, just change command from podman to docker
## you need to export this vars [check details in ../env.example]:

export NEXT_PUBLIC_WALLET_CONNECT_PROJECT_ID="your key"
export NEXT_PUBLIC_ZEROEX_API_KEY="your key"

## build:

podman build --no-cache -t tradedex:latest -f Containerfile --build-arg NEXT_PUBLIC_WALLET_CONNECT_PROJECT_ID="${NEXT_PUBLIC_WALLET_CONNECT_PROJECT_ID}" --build-arg NEXT_PUBLIC_ZEROEX_API_KEY="${NEXT_PUBLIC_ZEROEX_API_KEY}" ..

## run:

podman run -di -p 3000:3000 tradedex:latest

## push:

podman push ghcr.io/bakusivan/tradedex/tradedex:latest
