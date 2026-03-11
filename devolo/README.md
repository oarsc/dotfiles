#!/bin/bash

## Build docker image with
```sh
docker build -t devolo .
```

## Run with distrobox
Create container
```sh
distrobox create --name cockpitbox --image devolo
```

Run container
```sh
distrobox enter cockpitbox -- /opt/devolo/dlancockpit/bin/dlancockpit
```

Create bin
```sh
# enter with
distrobox enter cockpitbox

# set bin at host with
distrobox-export --bin /opt/devolo/dlancockpit/bin/dlancockpit
```

## Without distrobox
```sh
export XAUTHORITY=~/.Xauthority
xhost +local:
docker run -it -e DISPLAY=$DISPLAY -e XAUTHORITY=$XAUTHORITY -v $XAUTHORITY:$XAUTHORITY -v /tmp/.X11-unix:/tmp/.X11-unix --network=host --name devoloo devolo
```

`xhost` needed. If not available, install with:
```sh
sudo pacman -S xorg-xhost
sudo apt install x11-xserver-utils
```

If `$XAUTHORITY` does not exists, and `~/.Xauthority` does not exist either:
```sh
touch ~/.Xauthority
xauth generate :1 . trusted  # (replace :1 with the result of: echo $DISPLAY)
```sh