# AGD

AGD stands for Anime Game Docker / Daemon.

This repository aims to build the docker image for some anime games.


## Getting Started

### Modify the `docker-compose.yaml` file

Modify the `ACCESS_IP` in the `docker-compose.yaml` file to your Linux box IP, so your game client can connect to the server.

### Run the container

```bash
docker-compose up
```

To run the container in the background, you can use the following command:

```bash
docker-compose up -d
```

To stop the container, you can use the following command:

```bash
docker-compose down
```

## Traffic Forwarding

### Method 1: Xeon's patch

By default, the Xeon's patch forward traffic to the localhost on port `21041` and `21000`. If you are running the container on a Linux box, and game client on Windows, you may need to forward the ports from Windows to the Linux box.

Let's say your Linux box IP is `192.168.2.8`. You can run the following commands in Command Prompt with administrator privileges:

```cmd
netsh interface portproxy add v4tov4 listenport=21041 listenaddress=0.0.0.0 connectport=21041 connectaddress=192.168.2.8
netsh interface portproxy add v4tov4 listenport=21000 listenaddress=0.0.0.0 connectport=21000 connectaddress=192.168.2.8
netsh interface portproxy show all
```

To reset the port forwarding rules, you can run the following command:

```cmd
netsh interface portproxy reset
```

Note: Windows port forwarding only works for TCP, not UDP. You must manually configure the ACCESS_IP in the `docker-compose.yaml` file to your Linux box IP, so your game client can connect to the server.

### Method 2: MITM Proxy

Please refer to this branch - [proxy](../../tree/proxy).

## Build the docker image

### Clone the repository

You need to decide which branch you want to build, say `xeon-5.1.50`.

```bash
BRANCH=xeon-5.1.50
git clone -branch $BRANCH https://github.com/lesca/agd.git
```

### Build

Before you start to build the image, you need to modify the proxy settings in `build.sh` in the build folder. If you don't need a proxy, remove those lines.

```bash
cd build
./build.sh
```

## Credits

- [XilonenImpact](https://git.xeondev.com/reversedrooms/XilonenImpact)
- [sakura-rs](https://git.xeondev.com/sakura-rs/sakura-rs)