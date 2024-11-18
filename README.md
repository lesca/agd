[English](README_EN.md)

## 代理指南

### 先决条件
* 已安装 `miniconda`

### 配置目标服务器

目标服务器是一个能提供 HTTP/HTTPS 服务的 Web 服务器。如果您将流量转发到目标服务器，那么意味着前提是目标服务器能够处理这些请求。

打开 `proxy.ini` 文件并将下面的变量修改为您的目标服务器。如果目标服务器使用 HTTPS，请将 `scheme` 设置为 `https`。

```ini
[proxy]
scheme = http
host = 192.168.2.8
port = 11080
```

运行脚本：
* Linux/MacOS: `./run.sh`
* Windows: `run.bat`

第一次执行会自动安装 `mitmproxy` 和 `requirements.txt` 中的依赖项。

如果安装失败，最好需要先移除 proxy 环境 `conda env remove --name proxy`，然后再运行 run 脚本。

### 配置转发列表

打开 `proxy.py` 文件并修改下面的列表变量：

* `FORWARD_DOMAINS`：要转发的域名列表。
* `EXCLUDED_DOMAINS`：不转发的域名列表。
* `LOG_KEYWORDS`：要记录的关键字列表。

## 信任 mitmproxy CA (必须)

建议先参考官方指南以了解一些基本知识： [https://docs.mitmproxy.org/stable/concepts-certificates/](https://docs.mitmproxy.org/stable/concepts-certificates/)。

在安装 `mitmproxy` 后，它会在 `~/.mitmproxy` 目录中创建几个文件。

列出 mitmproxy CA 文件：
```bash
$ ls -1 ~/.mitmproxy 
mitmproxy-ca-cert.cer
mitmproxy-ca-cert.p12
mitmproxy-ca-cert.pem
mitmproxy-ca.p12
mitmproxy-ca.pem
mitmproxy-dhparam.pem
```

我们需要安装的就是这些证书，下面是针对不同操作系统的简要步骤。

### MacOS

打开 **钥匙串访问** 并将 `mitmproxy-ca-cert.pem` 文件导入到 **系统** 钥匙串。

默认情况下，证书不被信任。双击证书并选择 **信任** -> **使用此证书时** -> **始终信任**。

完成。

### Windows

使用 `mitmproxy-ca-cert.p12` 文件将证书导入到 **受信任的根证书颁发机构** 存储。**当前用户** 和 **本地计算机** 都可以。如果您有管理员权限，最好将其导入到 **本地计算机** 存储。

完成。

## Enjoy

上述步骤完成后，您就可以使用 mitmproxy 捕获和转发 HTTP/HTTPS 请求了。

直接运行脚本即可：
* Linux/MacOS: `./run.sh`
* Windows: `run.bat`

## 致谢

* [https://docs.mitmproxy.org/stable/concepts-certificates/](https://docs.mitmproxy.org/stable/concepts-certificates/)
* [https://github.com/mitmproxy/mitmproxy](https://github.com/mitmproxy/mitmproxy)

