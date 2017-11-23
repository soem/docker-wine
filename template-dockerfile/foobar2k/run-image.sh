docker run \
    --privileged \
    --rm \
    -ti \
    -e DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
    -v /tmp/wine:/home/docker/wine/ \
    -v ~/Downloads:/home/docker/Downloads:ro \
    -v ~/Music:/home/docker/Music:ro \
    -v /etc/localtime:/etc/localtime:ro \
    --device /dev/snd \
    -u docker \
    archlinux-wine-foobar2k