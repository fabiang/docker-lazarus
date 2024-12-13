# fabiang/lazarus

Freepascal (fpc) compiler + Lazarus project libraries as Docker image

[![fabiang/lazarus](https://img.shields.io/docker/pulls/fabiang/lazarus.svg)](https://hub.docker.com/r/fabiang/lazarus)
[![fabiang/lazarus](https://badgen.net/github/license/fabiang/docker-lazarus)](https://github.com/fabiang/docker-lazarus)
[![Docker Image](https://github.com/fabiang/docker-lazarus/actions/workflows/docker.yml/badge.svg)](https://github.com/fabiang/docker-lazarus/actions/workflows/docker.yml)

## Available tags

* 3.6-windowsservercore-ltsc2022, 3-windowsservercore-ltsc2022
* 3.6-windowsservercore-ltsc2019, 3-windowsservercore-ltsc2019
* 3.4-windowsservercore-ltsc2022
* 3.4-windowsservercore-ltsc2019
* 2.2.6-windowsservercore-ltsc2022, 2.2-windowsservercore-ltsc2022, 2-windowsservercore-ltsc2022
* 2.2.6-windowsservercore-ltsc2019, 2.2-windowsservercore-ltsc2019, 2-windowsservercore-ltsc2019

## Usage

```
  docker run -it --rm `
    -v "mysourcecode:C:\\app" `
    -w "C:\\app" `
    fabiang/lazarus:3-windowsservercore-ltsc2022 `
    lazbuild.exe MyApp.lpi
```

## License

[BSD 2-Clause License](LICENSE).
