---
layout: default
title: Linux shell Best Debug command line tools
parent: DevOps
---

{:refdef: style="text-align: center;"}
<img src="/images/linux-logo.png" width="128px">
{: refdef}


# Linux Debug Tools For Ops and Devops


Mainly specific client protocol to test specific server protocol, like curl to test an http server, ldapsearch for a ldap server or mail to test a SMTP relay etc.

But you will also find many ways to set proxy settings on your tools.

There are usefull tools during the deployment stages in qualification, staging, or production environment (remove them after troubleshooting).

Tags: DevOps, Debug, tools, linux, ops, deploy, interface, testing

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}


# TLDR; Install all this interfaces debug tools
```shell
dnf install -y  net-tools \
                bind-utils \
                openldap-clients \
                mailx \
                wget \
                git \
                curl \
                telnet
```

# TCP Client

## TCP Parameters 

```shell
TCP_HOST=my.domain.tld      # or : "localhost", or ip like 192.168.0.10.
TCP_PORT=80                 # ex: port 22 (ssh) ou 80 (http) etc.
```

## TCP Test with Telnet

```shell
# dnf install -y telnet # apt install -y telnet # yum install -y telnet 

telnet $TCP_HOST $TCP_PORT

telnet my.hostname.tld 443 # example

```

> For UDP use nc : 
> `nc -z -v -u $UDP_HOST $UDP_PORT`


# FTP & SFTP Client

## FTP parameters

```shell
FTP_USER=remote_username
FTP_HOST=hostname
```

## FTP Testing 

```shell
sftp $FTP_USER@$FTP_HOST
```


# HTTP & HTTPS Client


## HTTP Parameter

```shell
HTTP_PROTOCOL=http # default http; https if secured.
HTTP_HOST=www.mydomain.com # ex: www.domain.tld
HTTP_PORT=80 # default 80 not secure; 443
HTTP_ROOT_URL=$HTTP_PROTOCOL://$HTTP_HOST:$HTTP_PORT
```

## HTTP Testing with Curl


```shell
# dnf install -y curl # yum install -y curl # apt install -y curl

curl -v $HTTP_ROOT_URL

curl -v http://httpbin.org/get  # example

# or if tls/ssl certifate not valid you can temporary ignore that with -k option

curl -kv $HTTP_ROOT_URL

curl -kv https://httpbin.org/get # example
```


> You can also use `wget` to request a http server


# DNS Client


## DNS Parameters


> If you don't know the following values : Ask your administrator, the DNS manager or your integrator.

DNS variables are : 


```shell
DNS_DOMAIN=mydomain.com     # ex: mydomain.com

HOST=sub.mydomain.com          # ex: mydomain.com or subdomain.mydomain.tld (=FQDN) 
```

## DNS discovery

Retrieve DNS serveur : 

```shell
dnf install -y bind-utils # yum install -y bind-utils 

host -t ns $DNS_DOMAIN 

host -t ns domain.com # example

# or 
dig ns $DNS_DOMAIN

host -t ns domain.com # example
```

## DNS Test : Ip resolution from Host  

To get ip address from an host or FQDN :

```shell

# With Host command

host $HOST

host  sub.domain.com # example 

# or with NSlookup
nslookup $HOST

nslookup sub.domain.com # example

# or with Dig
dig $HOST

dig sub.domain.com # example
dig sub.domain.com +short # example
```


# LDAP & LDAPS Client


## LDAP Parameters

> If you don't know the following values : Ask your administrator, the SMTP manager or your integrator.

LDAP variables are : 

```shell
LDAP_PROTOCOL=ldap              # or ldaps
LDAP_HOST=                      # ex: ldap.domain.tld
LDAP_PORT=389                   # default : 389 (LDAP), 636 (LDAPS)
LDAP_URL=$LDAP_PROTOCOL://$LDAP_HOST:$LDAP_PORT
LDAP_USERS_BASE=
LDAP_BIND_FORMAT=
LDAP_GROUPE_ATTRIBUT=
LDAP_USERS_CONNECTION_STRING=
LDAP_USER_CONNECTION_STRING=
LDAP_BIND_READONLY_USER_DN=
LDAP_USER_DN=

LDAP_FILTER=

LDAP_ATTR=*                     # * for "For all attributs", ex: givenName, sn, mail, uid
```


```shell

Base:         "dc=example,dc=com",
Host:         "ldap.example.com",
Port:         389,
UseSSL:       false,
BindDN:       "uid=readonlysuer,ou=People,dc=example,dc=com",
BindPassword: "readonlypassword",
UserFilter:   "(uid=%s)",
GroupFilter: "(memberUid=%s)",
Attributes:   []string{"givenName", "sn", "mail", "uid"},
```

## LDAP Test


```shell
# Installation
### RHEL 7
# yum install openldap-client -y 
### RHEL 8
# dnf install openldap-clients -y


ldapsearch -x -h $LDAP_HOST \
-D $LDAP_BIND_READONLY_USER_DN \
-W \
-b $LDAP_USERS_BASE \
-s sub "(${LDAP_FILTER})" $LDAP_ATTR
```



# SMTP Client


## SMTP Parameters

> If you don't know the following values : Ask your administrator, the SMTP manager or your integrator.

SMTP variables are : 

```shell
SMTP_HOST=                              # default
SMTP_PORT=                              # default port 25 not secure, and 587 for encrypted (secure)serveur
# SMTP_USERNAME=                        # optional
# SMTP_PASSWORD=                        # optional

SMTP_SUBJECT="Test Subject"
SMTP_BODY="Test Body"
SMTP_RECIPIENT="recipient@domain.tld"   # Example
# SMTP_FROM="sender@domain.tld"         # Optional
```


## SMTP Testing with CURL


```shell
cat <<EOF > mail.txt
Content-Type: text/plain; charset=UTF-8;
From: $SMTP_FROM
To: $SMTP_RECIPIENT
Subject: $SMTP_SUBJECT

$SMTP_BODY
EOF

curl '$SMTP_HOST' --mail-from '$SMTP_FROM' --mail-rcpt '$SMTP_RECIPIENT' --upload-file mail.txt

```

With SSL use this commands line options :


```shell

curl --ssl-reqd \
  --url 'smtps://$SMTP_HOST:SMTP_PORT' \
  --user '$SMTP_USERNAME:SMTP_PASSWORD' \
  --mail-from '$SMTP_USERNAME' \
  --mail-rcpt '$SMTP_RECIPIENT' \
  --upload-file mail.txt
  
```

## SMTP Test with Mail command

Test without SMTP Authentication : 

> Troubleshooting : mail command sometimes use /tmp folder, if you don't have permission to write inside it, mail command could fail.

```shell
dnf install -y mailx # yum install -y mailx # RHEL installation of mail command

echo $SMTP_BODY | mail -S smtp=$SMTP_HOST -s $SMTP_SUBJECT $SMTP_RECIPIENT

echo "body" | mail -S smtp=hostname -s "suject" "dest@domain.org"
```

or
```shell
echo $SMTP_BODY | mail -S smtp=$SMTP_HOST -s $SMTP_SUBJECT $SMTP_RECIPIENT
```

or
```shell
echo $SMTP_BODY | mail -S smtp=$SMTP_HOST -s $SMTP_SUBJECT -r $SMTP_FROM $SMTP_RECIPIENT
```

## SMTP Testing with Telnet

With authentication :

```shell
# Get base64 Login 
perl -MMIME::Base64 -e 'print encode_base64("LOGIN_HERE");'
# => Z2NpcaxaaWx4ZZzzV2

# Get base64 Password 
perl -MMIME::Base64 -e 'print encode_base64("PWD_HERE");'
# => Z2NpNOTaREALexE4ZGV2

telnet $SMTP_HOST $SMTP_PORT
EHLO mydomain.com
AUTH LOGIN
Z2NpcmVjdWx4ZGV2
Z2NpFAUSE_CHAINEcmVmdWx4ZGV2
# => "235 2.7.0 Authentication successful"

MAIL FROM:$SMTP_FROM
RCPT TO:<${SMTP_RECIPIENT}> NOTIFY=success,failure
DATA
Subject: $SMTP_SUBJECT
<empty line, press "return" command >
$SMTP_BODY
.
# Press "." at on the last line to send email.
```



# GIT Client

## Git Parameter

```shell
GIT_URL=https://git.domain.com/repository # 
```

## Git Testing

```shell
git clone $GIT_URL
```

# Show Listened ports


```shell
dnf install -y net-tools # yum install -y net-tools 
netstat -planteu
```

# PROXY HTTP : Reach a HTTP serveur Through a Proxy

> How to set proxy which allow to reach a http serveur on another network (commonly on internet)

Proxy parameters:
```shell
PROXY_HOST=proxy.domain.com
PROXY_PORT=8080              # ex: 8080, or 443, etc.
# PROXY_USERNAME=__YOUR_PROXY_USERNAME__ 
# PROXY_PASSWORD=__YOUR_PROXY_PASSWORD__

URL=https://httpbin.org/get # Example
```

## Set proxy globaly on linux

```shell
vi /etc/profile.d/http_proxy.sh

export http_proxy=$PROXY_HOST:$PROXY_PORT
export https_proxy=$PROXY_HOST:$PROXY_PORT

```

Example :

```shell
vi /etc/profile.d/http_proxy.sh

export http_proxy=proxy.domain.com:443
export https_proxy=proxy.domain.com:443

```

You can check if this variables are loaded :
```shell
env | grep -i "proxy"
```


## Curl behind a proxy

```shell
curl -v --proxy $PROXY_HOST:$PROXY_PORT  $URL

# Exemple 
curl -kv --proxy http://myproxy.domain.tld:8080  https://httpbin.org/get

```

## Git behind a proxy

Globaly :
```shell
git config --global http.proxy http://$PROXY_HOST:$PROXY_HOST
git config --global https.proxy http://$PROXY_HOST:$PROXY_HOST 

# unset
# git config --global --unset http.proxy
# git config --global --unset https.proxy
```

Specific for a repository :
```shell
git config --global http.https://domain.com.proxy http://proxyUsername:proxyPassword@proxy.server.com:port
```

or edit the ~/.gitconfig :

```shell
[http]
[http "https://domain.com"]
	proxy = http://proxyUsername:proxyPassword@proxy.server.com:port
```

## Docker behind a proxy

### Docker daemon add proxy settings

```shell
cat /etc/systemd/system/docker.service.d/http-proxy.conf
[Service]
Environment="HTTP_PROXY=http://$PROXY_HOST:$PROXY_PORT"
Environment="HTTPS_PROXY=http://$PROXY_HOST:$PROXY_PORT"
Environment="NO_PROXY=localhost,mydomain.com"

...

sudo systemctl daemon-reload
sudo systemctl restart docker

```

### Docker build behind Proxy

```shell
docker build --build-arg http_proxy=http://$PROXY_HOST:$PROXY_PORT --build-arg https_proxy=http://$PROXY_HOST:$PROXY_PORT . 

# Example for MAVEN inside a container 
# Add at top of Dockerfile : ARG MAVEN_OPTS
docker build --build-arg MAVEN_OPTS="-Dhttp.proxyHost=$PROXY_HOST -Dhttp.proxyPort=$PROXY_PORT -Dhttps.proxyHost=$PROXY_HOST -Dhttps.proxyPort=$PROXY_PORT" .


```

## NPM (Javascript packager) behind a Proxy

```shell
npm config set proxy http://$PROXY_HOST:$PROXY_PORT
npm config set https-proxy http://$PROXY_HOST:$PROXY_PORT
```

## PIP (Python packager) behind a Proxy

```shell
pip install --proxy=http://$PROXY_HOST:$PROXY_PORT -r requirements.txt
```

## Gitlab Runner behind a proxy

```shell
mkdir /etc/systemd/system/gitlab-runner.service.d
vi /etc/systemd/system/gitlab-runner.service.d/http-proxy.conf

[Service]
Environment="HTTP_PROXY=http://$PROXY_HOST:$PROXY_PORT"
Environment="HTTPS_PROXY=http://$PROXY_HOST:$PROXY_PORT"
# save & quit ESC +  ":wq"

systemctl daemon-reload
sudo systemctl restart gitlab-runner
systemctl show --property=Environment gitlab-runner
gitlab-runner stop
gitlab-runner start
```

## Maven (Java Packaging)

```shell
export MAVEN_OPTS="-Dhttp.proxyHost=$PROXY_HOST -Dhttp.proxyPort=$PROXY_PORT -Dhttps.proxyHost=$PROXY_HOST -Dhttps.proxyPort=$PROXY_PORT"
# set MAVEN_OPTS.
```
