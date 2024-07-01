# escape=`
ARG WINDOWS_IMAGE=servercore
ARG WINDOWS_VERSION=ltsc2019
FROM mcr.microsoft.com/windows/${WINDOWS_IMAGE}:${WINDOWS_VERSION}

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

USER ContainerAdministrator

ENV TEMP=C:\\Windows\\TEMP

ARG LAZARUS_VERSION=3.4
ARG FPC_VERSION=3.2.2
ARG LAZARUS_DOWNLOAD_HASH_SHA256=6ede48350b9890929088bd33aa441e1bf4cf813b21bc38149e3df3bbe673bbd3
ARG LAZARUS_XCOMPILE_X86_DOWNLOAD_HASH_SHA256=e16a7bee07af9dc39df7787348b8a06e87d6b7a9b64f29f5aa795d1b2b4b6f4d
ENV LAZARUS_INSTALL_PATH="C:\\Lazarus"

RUN Write-Host 'Downloading Lazarus ...'; `
    `
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; `
    Invoke-WebRequest `
         # Fake user agent, otherwise redirects are not working
        -UserAgent 'curl/7.85.0' `
        -Uri ("'https://sourceforge.net/projects/lazarus/files/Lazarus%20Windows%2064%20bits/Lazarus%20{0}/lazarus-{0}-fpc-{1}-win64.exe/download'" -f $Env:LAZARUS_VERSION, $Env:FPC_VERSION) `
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
    Write-Host 'Done installing Lazarus';

RUN Write-Host 'Downloading Lazarus Cross-Compiling Addon (x86) ...'; `
    Invoke-WebRequest `
        -UserAgent 'curl/7.85.0' `
        -Uri ("'https://sourceforge.net/projects/lazarus/files/Lazarus%20Windows%2032%20bits/Lazarus%20{0}/lazarus-{0}-fpc-{1}-cross-x86_64-win64-win32.exe/download'" -f $Env:LAZARUS_VERSION, $Env:FPC_VERSION) `
        -OutFile ("'{0}\\lazarus-cross-x86.exe'" -f $Env:TEMP) `
        -MaximumRedirection 10; `
    `
    Write-Host ('Verifying sha256 ({0}) ...' -f $Env:LAZARUS_XCOMPILE_X86_DOWNLOAD_HASH_SHA256); `
    if ((Get-FileHash ("'{0}\\lazarus-cross-x86.exe'" -f $Env:TEMP) -Algorithm sha256).Hash -ne $Env:LAZARUS_XCOMPILE_X86_DOWNLOAD_HASH_SHA256) { `
        Write-Host 'FAILED!'; `
        exit 1; `
    }; `
    `
    Write-Host 'Install Lazarus Lazarus Cross-Compiling Addon (x86) ...'; `
    Start-Process -NoNewWindow -Wait -PassThru `
        -FilePath ("'{0}\\lazarus-cross-x86.exe'" -f $Env:TEMP) `
        -ArgumentList ("'/VERYSILENT /NORESTART /LOG=\"{0}\\lazarus-cross-x86.log\" /DIR=\"{1}\"'" -f $Env:TEMP, $Env:LAZARUS_INSTALL_PATH); `
    Write-Host 'Done installing Lazarus Lazarus Cross-Compiling Addon (x86)';

RUN $NewPath = [Environment]::GetEnvironmentVariable('PATH', 'Machine') `
        + [IO.Path]::PathSeparator `
        + ( '{0}\fpc\{1}\bin\x86_64-win64' -f $Env:LAZARUS_INSTALL_PATH, $Env:FPC_VERSION ) `
        + [IO.Path]::PathSeparator `
        + ( '{0}\fpc\{1}\bin\i386-win32' -f $Env:LAZARUS_INSTALL_PATH, $Env:FPC_VERSION ) `
        + [IO.Path]::PathSeparator `
        + ( '{0}' -f $Env:LAZARUS_INSTALL_PATH ) `
        ; `
    [Environment]::SetEnvironmentVariable('PATH', $NewPath, 'Machine'); `
    `
    Remove-Item -Force -Path ("'{0}\\lazarus.exe'" -f $Env:TEMP); `
    Remove-Item -Force -Path ("'{0}\\lazarus.log'" -f $Env:TEMP); `
    Remove-Item -Force -Path ("'{0}\\lazarus-cross-x86.exe'" -f $Env:TEMP); `
    Remove-Item -Force -Path ("'{0}\\lazarus-cross-x86.log'" -f $Env:TEMP);

USER ContainerUser
