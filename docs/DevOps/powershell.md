---
layout: default
title: PowerShell Debug Tools for DevOps
parent: DevOps
---

PowerShell Debug Tools for Ops


## Client TCP

```powershell
$TCP_HOST="myhostname.domain.com" # or : "localhost", or ip like 192.168.0.10.
$TCP_PORT=443


Test-NetConnection -ComputerName $TCP_HOST -Port $TCP_PORT -InformationLevel "Detailed"
```


## FTP and SFTP Client

```powershell
$FTP_USER=remote_username
$FTP_HOST=hostname

Install-Module -Name Posh-SSH

$SFTPSession = New-SFTPSession -ComputerName $FTP_HOST -Credential (Get-Credential)
Get-SFTPItem -SessionId $SFTPSession.SessionId -Path /home/myuser/myfile.txt -Destination c:\myfolder

```

> See also [WinSCP Module](https://winscp.net/eng/docs/library_powershell).


## HTTP & HTTPS Client


```powershell
$HTTP_PROTOCOL="https"              # default http; https if secured.
$HTTP_HOST="www.mydomain.com"       # ex: www.domain.tld
$HTTP_PORT="443"                    # default 80 not secure; 443
$HTTP_PATH="/"                    # / or path/to/ressource

$HTTP_URI=${HTTP_PROTOCOL}://${HTTP_HOST}:${HTTP_PORT}${HTTP_PATH}

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$webcall = Invoke-WebRequest -Uri $HTTP_URI -UseBasicParsing

Write-Host ($webcall | Format-Table | Out-String)
```


<!-- 

## Client DNS

DNS discovery
DNS Test : Ip resolution from Host

-->

## LDAP & LDAPS Client

> If you want a GUI LDAP client, get the free LDAP Browser 4.5 (not the paid administrator version). 

```powershell
$LDAP_PROTOCOL="ldap"               # or ldaps
$LDAP_HOST=                         # ex: ldap.domain.tld
$LDAP_PORT="389"                    # default : 389 (LDAP), 636 (LDAPS)
$LDAP_URL=$LDAP_PROTOCOL://$LDAP_HOST:$LDAP_PORT
$LDAP_USERS_BASE=
$LDAP_BIND_FORMAT=
$LDAP_GROUPE_ATTRIBUT=
$LDAP_USERS_CONNECTION_STRING=
$LDAP_USER_CONNECTION_STRING=
$LDAP_BIND_READONLY_USER_DN=
$LDAP_USER_DN=

$LDAP_FILTER=

$LDAP_ATTR="*"                      # * for "For all attributs", ex: givenName, sn, mail, uid
```

Check user exist : 
```powershell
[adsi]"$LDAP_USER_CONNECTION_STRING"
```

Check AD auth  : 
```powershell
Function Test-ADUserAuthentication {
    param(
    [parameter(Mandatory=$true)]
    [string]$ADUserLogin,
    [parameter(Mandatory=$true)]
    [string]$ADUserPassword)
    ((New-Object DirectoryServices.DirectoryEntry -ArgumentList "",$ADUserLogin,$ADUserPassword).psbase.name) -ne $null
}

$ADUserLogin = "account"
$ADUserPassword = "pass"

Test-ADUserAuthentication -ADUserLogin $ADUserLogin -ADUserPassword $ADUserPassword

```

Check Member of a group :

```powershell
Import-Module ActiveDirectory
Get-ADGroupMember $GROUP_NAME | select name,distinguishedname 
```

## SMTP Client


```powershell
$SMTP_HOST="smtp.domain.com"             # default
$SMTP_PORT="25"                          # default port 25 not secure, and 587 for encrypted (secure)serveur
# $SMTP_USERNAME=                        # optional
# $SMTP_PASSWORD=                        # optional

$SMTP_SUBJECT="Test Subject"
$SMTP_BODY="Test Body"
$SMTP_RECIPIENT="recipient@domain.com"   # Example
# $SMTP_FROM="sender@domain.com"         # Optional, don't add this if your server are not trusted by the recipient smtp server.


Send-MailMessage -SmtpServer $SMTP_HOST -Port $SMTP_PORT -To $SMTP_RECIPIENT -Subject $SMTP_SUBJECT -Body $SMTP_BODY

```


# Show Listened ports

```powershell
Get-NetTCPConnection -State Listen,Established
```

<!-- 
TODO / A
PROXY HTTP : Reach a HTTP serveur Through a Proxy
Set proxy globaly on linux
Curl behind a proxy
Git behind a proxy

Docker behind a proxy
Docker daemon add proxy settings
Docker build behind Proxy

NPM behind a Proxy
PIP behind a Proxy
Gitlab Runner behind a proxy
-->