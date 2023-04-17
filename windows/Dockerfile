# escape=`
ARG WINDOWS_IMAGE=servercore
ARG WINDOWS_VERSION=ltsc2019
FROM mcr.microsoft.com/windows/${WINDOWS_IMAGE}:${WINDOWS_VERSION}

ARG FPC_VERSION=3.2.2
# ARG FPC_DOWNLOAD_HASH_SHA256=8c255390544b051388b577eb61c6191a04883264afe0e3369b3600a56daf7bde

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

USER ContainerAdministrator

ENV TEMP=C:\\Windows\\TEMP
#ENV FPC_INSTALL_PATH="C:\\Program Files\\FPC"

#RUN Write-Host 'Downloading Freepascal compiler ...'; `
#    `
#    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; `
#    Invoke-WebRequest `
#         # Fake user agent, otherwise redirects are not working
#        -UserAgent 'curl/7.85.0' `
#        -Uri ("'https://sourceforge.net/projects/freepascal/files/Win32/{0}/fpc-{0}.win32.and.win64.exe/download'" -f $Env:FPC_VERSION) `
#        -OutFile ("'{0}\\fpc.exe'" -f $Env:TEMP) `
#        -MaximumRedirection 10; `
#    `
#    Write-Host ('Verifying sha256 ({0}) ...' -f $Env:FPC_DOWNLOAD_HASH_SHA256); `
#    if ((Get-FileHash ("'{0}\\fpc.exe'" -f $Env:TEMP) -Algorithm sha256).Hash -ne $Env:FPC_DOWNLOAD_HASH_SHA256) { `
#    Write-Host 'FAILED!'; `
#    exit 1; `
#    }; `
#    `
#    Write-Host 'Install Freepascal compiler ...'; `
#    Start-Process -NoNewWindow -Wait -PassThru `
#        -FilePath ("'{0}\\fpc.exe'" -f $Env:TEMP) `
#        -ArgumentList ("'/VERYSILENT /NORESTART /LOG=\"{0}\\fpc.log\" /DIR=\"{1}\"'" -f $Env:TEMP, $Env:FPC_INSTALL_PATH); `
#    `
#    # Better handling of errors from log
#    Remove-Item -Force -Path ("'{0}\\fpc.exe'" -f $Env:TEMP); `
#    Remove-Item -Force -Path ("'{0}\\fpc.log'" -f $Env:TEMP);

ARG LAZARUS_VERSION=2.2.6
ARG LAZARUS_DOWNLOAD_HASH_SHA256=3AECCE3F12F9C1824DCB149142ABFBAEE4E162A2624E62CB0ECD9B7C2142B7E3
ENV LAZARUS_INSTALL_PATH="C:\\Lazarus"

RUN Write-Host 'Downloading Lazarus ...'; `
    `
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; `
    Invoke-WebRequest `
         # Fake user agent, otherwise redirects are not working
        -UserAgent 'curl/7.85.0' `
        -Uri ("'https://sourceforge.net/projects/lazarus/files/Lazarus%20Windows%2032%20bits/Lazarus%20{0}/lazarus-{0}-fpc-{1}-win64.exe/download'" -f $Env:LAZARUS_VERSION, $Env:FPC_VERSION) `
        -OutFile ("'{0}\\lazarus.exe'" -f $Env:TEMP) `
        -MaximumRedirection 10; `
    `
    Write-Host ('Verifying sha256 ({0}) ...' -f $Env:LAZARUS_DOWNLOAD_HASH_SHA256); `
    if ((Get-FileHash ("'{0}\\lazarus.exe'" -f $Env:TEMP) -Algorithm sha256).Hash -ne $Env:LAZARUS_DOWNLOAD_HASH_SHA256) { `
    Write-Host 'FAILED!'; `
    exit 1; `
    }; `
    `
    Write-Host 'Install Lazarus ...'; `
    Start-Process -NoNewWindow -Wait -PassThru `
        -FilePath ("'{0}\\lazarus.exe'" -f $Env:TEMP) `
        -ArgumentList ("'/VERYSILENT /NORESTART /LOG=\"{0}\\lazarus.log\" /DIR=\"{1}\"'" -f $Env:TEMP, $Env:LAZARUS_INSTALL_PATH); `
    `
    # Better handling of errors from log
    $NewPath = [Environment]::GetEnvironmentVariable('PATH', 'Machine') + [IO.Path]::PathSeparator + `
        ( '{0}\fpc\{1}\bin\x86_64-win64' -f $Env:LAZARUS_INSTALL_PATH, $Env:FPC_VERSION ) ; `
    [Environment]::SetEnvironmentVariable('PATH', $NewPath, 'Machine'); `
    `
    Remove-Item -Force -Path ("'{0}\\lazarus.exe'" -f $Env:TEMP); `
    Remove-Item -Force -Path ("'{0}\\lazarus.log'" -f $Env:TEMP);

USER ContainerUser
