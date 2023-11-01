# ARK Survival Ascended Docker Image
This project provides an Ark Survival Ascended docker image that runs
[GE-Proton](https://github.com/GloriousEggroll/proton-ge-custom) and `Steamcmd` to host an Unoffical dedicated server.
This should run on Linux machines, tested on a Debian and Ubuntu server. It runs by using GE-Proton, basically boils
down to using Wine to run Windows programs in Linux.

When Wildcard releases a Linux server build, this project will be superceded and running the Linux server directly will
be much more performant.

## Requisites
* Docker (I'm running 24.0.6)

## Building
```
docker build . -t ark-sa
```

## Running
```
docker run --mount type=bind,source=./game,target=/game ark-sa
```

### Runtime options
| Environment Variable | Default             | Description |
| ---------------------| ------------------- | ----------- |
| LAUNCH_ARGS          | TheIsland_WP?listen | Args given to the Ark Survival Ascended Server.exe process
| SKIP_UPDATE          | 0                   | Set to anything else to disable Steam's app_update and validate checks

## Logs
Logs aren't printed to stdout by the `Ark SA` server. To view them from the host, you can:

```
tail -f ./game/ShooterGame/Saved/Logs/ShooterGame.log
```

# Credits
This is entirely based on [cdp1337/ARKSurvivalAscended-Linux](https://github.com/cdp1337/ARKSurvivalAscended-Linux/) who
has done excellent work and I wouldn't be capable of doing this without using it as a reference.
