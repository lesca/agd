[中文](README.md)

## Proxy Guide

### Prerequisites
* `miniconda` installed

### Configure Target Server

The target server is a web server that provides HTTP/HTTPS services. If you forward traffic to the target server, it means the target server must be able to handle these requests.

Open the `proxy.ini` file and modify the following variables to match your target server. If the target server uses HTTPS, set `scheme` to `https`.

```ini
[proxy]
scheme = http
host = 192.168.2.8
port = 11080
```

Run the script:
* Linux/MacOS: `./run.sh`
* Windows: `run.bat`

The first execution will automatically install `mitmproxy` and the dependencies listed in `requirements.txt`.

If the installation fails, it's best to first remove the proxy environment using `conda env remove --name proxy`, then run the run script again.

### Configure Forwarding Lists

Open the `proxy.py` file and modify the following list variables:

* `FORWARD_DOMAINS`: List of domains to forward.
* `EXCLUDED_DOMAINS`: List of domains to exclude from forwarding.
* `LOG_KEYWORDS`: List of keywords to log.

## Trust mitmproxy CA (Required)

It's recommended to first check the official guide to understand some basic concepts: [https://docs.mitmproxy.org/stable/concepts-certificates/](https://docs.mitmproxy.org/stable/concepts-certificates/).

After installing `mitmproxy`, it creates several files in the `~/.mitmproxy` directory.

List mitmproxy CA files:
```bash
$ ls -1 ~/.mitmproxy 
mitmproxy-ca-cert.cer
mitmproxy-ca-cert.p12
mitmproxy-ca-cert.pem
mitmproxy-ca.p12
mitmproxy-ca.pem
mitmproxy-dhparam.pem
```

These are the certificates we need to install. Here are brief steps for different operating systems.

### MacOS

Open **Keychain Access** and import the `mitmproxy-ca-cert.pem` file into the **System** keychain.

By default, the certificate is not trusted. Double-click the certificate and select **Trust** -> **When using this certificate** -> **Always Trust**.

Done.

### Windows

Use the `mitmproxy-ca-cert.p12` file to import the certificate into the **Trusted Root Certification Authorities** store. Both **Current User** and **Local Machine** work. If you have administrator privileges, it's better to import it into the **Local Machine** store.

Done.

## Enjoy

After completing the above steps, you can use mitmproxy to capture and forward HTTP/HTTPS requests.

Simply run the script:
* Linux/MacOS: `./run.sh`
* Windows: `run.bat`

## Acknowledgments

* [https://docs.mitmproxy.org/stable/concepts-certificates/](https://docs.mitmproxy.org/stable/concepts-certificates/)
* [https://github.com/mitmproxy/mitmproxy](https://github.com/mitmproxy/mitmproxy)
