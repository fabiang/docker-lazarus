# fabiang/lazarus

Freepascal (fpc) compiler + Lazarus project libraries as Docker image. Cross-compiling for i386/Win32 is included.

[![fabiang/lazarus](https://img.shields.io/docker/pulls/fabiang/lazarus.svg)](https://hub.docker.com/r/fabiang/lazarus)
[![fabiang/lazarus](https://img.shields.io/badge/License-BSD_2--Clause-orange.svg)](https://github.com/fabiang/docker-lazarus)
[![Docker Image](https://github.com/fabiang/docker-lazarus/actions/workflows/docker.yml/badge.svg)](https://github.com/fabiang/docker-lazarus/actions/workflows/docker.yml)

## Available tags

### Windows

**Note:** LTSC2019 images are deprecated and were removed from automatic build. Update to LTSC2022 or LTSC2025 asap.

* 4.8-windowsservercore-ltsc2022, 4-windowsservercore-ltsc2022
* 4.8-windowsservercore-ltsc2025, 4-windowsservercore-ltsc2025
* 4.4-windowsservercore-ltsc2022
* 4.4-windowsservercore-ltsc2025
* 4.2-windowsservercore-ltsc2022
* 4.2-windowsservercore-ltsc2025
* 3.8-windowsservercore-ltsc2022, 3-windowsservercore-ltsc2022
* 3.8-windowsservercore-ltsc2025, 3-windowsservercore-ltsc2025
* 3.6-windowsservercore-ltsc2022
* 3.6-windowsservercore-ltsc2025
* 3.4-windowsservercore-ltsc2022
* 3.4-windowsservercore-ltsc2025
* 2.2.6-windowsservercore-ltsc2022, 2.2-windowsservercore-ltsc2022, 2-windowsservercore-ltsc2022
* 2.2.6-windowsservercore-ltsc2025, 2.2-windowsservercore-ltsc2025, 2-windowsservercore-ltsc2025

### Linux

*Alpine images are considered beta*. PRs are welcome.

* 4.8-alpine, 4-alpine

## Usage

```
  docker run -it --rm `
    -v "mysourcecode:C:\\app" `
    -w "C:\\app" `
    fabiang/lazarus:4-windowsservercore-ltsc2022 `
    lazbuild.exe MyApp.lpi
```

## License

[BSD 2-Clause License](LICENSE).
