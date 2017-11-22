# docker-wine
[Wine](https://www.winehq.org/) on Docker with [Dynamic Graphic](https://github.com/yantis/docker-dynamic-video)
drivers and [VirtualGL](https://github.com/yantis/docker-virtualgl) with both local and remote support.

It should work out of the box with all Nvidia cards and Nvidia drivers and most other cards as well that use Mesa drivers.
It is setup to auto adapt to whatever drivers you may have installed as long as they are the most recent ones for your branch.

On Docker hub [wine](https://registry.hub.docker.com/u/yantis/wine/)
on Github [docker-wine](https://github.com/yantis/docker-wine/)

## Breakdown

### RUN

1. set xhost
Allows your local user to access the xsocket. Change yourusername or use $(whoami) or $USER if your shell supports it.
```
xhost +si:localuser:$(whoami)
```

2. docker run
```
docker run \
    --privileged \
    --rm \
    -ti \
    -e DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
    -v /tmp/wine:/home/docker/wine/ \
    -v /etc/localtime:/etc/localtime:ro \
    --device /dev/snd \
    -u docker \
    test-wine /bin/bash
```
