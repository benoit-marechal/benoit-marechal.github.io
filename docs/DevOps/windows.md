---
layout: default
title: Windows Best Debug Tools
parent: DevOps
---

This is my Top Windows App for Debuging and Troubleshooting interfaces and connections issues.


This "Awesome list" of software is dedicated to **Integration Testing**, **Deploy Testing**, **DevOps**, **Troubleshooting** and **Debug** on Windows. 

On RUN step, or on Production environment : It's best to use portable version so you can easily remove them after troubleshooting, for security purpose.

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}


# FTP & SFTP Client

1. [WinSCP](https://winscp.net/eng/downloads.php)
1. [FileZilla](https://filezilla-project.org/download.php?show_all=1)

# JDBC / SQL Client

1. [dbeaver](https://portapps.io/app/dbeaver-portable/)

# HTTP(s) Client

1. Firefox
1. Chrome
1. Command Line Tool : [curl](https://curl.se/windows/)
1. [Postman](https://www.postman.com/downloads/)

# SSH Client

1. [Putty](https://www.putty.org/)
1. [mRemoteNG](https://mremoteng.org/download)
1. [Tabby](https://tabby.sh/app) : Cmd + Powershell + SSh + Git Bash

# RDP Client

1. [mRemoteNG](https://mremoteng.org/download)
1. MobaXterm

# LDAP & LDAPS Client

1. [LDAP Browser](https://www.ldapadministrator.com/download.htm#browser) : Get the free community version

# Text Editor

1. [Notepad++](https://notepad-plus-plus.org/downloads/)

# IDE

1. [Visual Studio Code](https://code.visualstudio.com/download)


# Debug Tools

1. [PowerToys](https://learn.microsoft.com/en-us/windows/powertoys/install) 
1. [BGInfo](https://docs.microsoft.com/en-us/sysinternals/downloads/bginfo)
1. [OpenSSH](https://www.openssh.com/)
1. [Open SSL](https://slproweb.com/products/Win32OpenSSL.html)
1. [SumatraPDF](https://www.sumatrapdfreader.org/download-free-pdf-viewer)
1. [TcpView](https://docs.microsoft.com/en-us/sysinternals/downloads/tcpview)
1. [PSTools](https://docs.microsoft.com/en-us/sysinternals/downloads/pstools)
1. [TreeSize](https://customers.jam-software.de/downloadTrial.php?language=EN&article_no=80)
1. [ScreenToGIF Windows](https://www.screentogif.com/)
1. [Lock Hunter](https://lockhunter.com/download.htm) Déverrouiller un fichier lock par un processus (non portable)
1. [WinMerge](https://winmerge.org/downloads/?lang=fr)
1. [AutoRun](https://docs.microsoft.com/fr-fr/sysinternals/downloads/autoruns) : Voir exhaustivement les applications lancée au démarrage Windows
1. [GreenshotPortable](https://getgreenshot.org/version-history/)

# Linux Commands on Windows

- Bash on Windows [WSL 2](https://learn.microsoft.com/en-us/windows/wsl/install-on-server)
- [Linux Command for Windows](http://unxutils.sourceforge.net/)
- [Git Bash](https://gitforwindows.org/)

# DNS 

Flush dns :

```
ipconfig /flushdns
```



# ClearType

To stop Aliasing : 

- get cleartype.ps1 file and run it :

```powershell
cleartype.ps1 1
```

Then add new scheduled task on session startup 

- Open Task Scheduler
- Create a new task
- Action : 
  - command: `powershell`
  - parameter : `E:\isi\cleartype.ps1 1`
