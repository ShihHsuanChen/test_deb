# test_deb

test create installer for Linux (debian)

## Install

```sh
$ pip install -e .
```

## Run main

```sh
$ python main.py
```


## Build

```sh
$ config2cmd build-compose.yml -r build
```

## Build Installer for debian

```sh
$ ./build_deb.sh
```

# Test install in docker container

```sh
$ ./test.sh
Sending build context to Docker daemon  71.37MB
Step 1/8 : FROM ubuntu:18.04
 ---> f9a80a55f492
Step 2/8 : ENV DEB_NAME="mycalc_0.0.1_amd64.deb"
 ---> Using cache
 ---> e577aec1d9bd
Step 3/8 : COPY dist_wizard/$DEB_NAME /home/
 ---> fdb9862e2695
Step 4/8 : ENV DEB_PATH="/home/$DEB_NAME"
 ---> Running in 7814afb737ee
Removing intermediate container 7814afb737ee
 ---> e0c7a60e792d
Step 5/8 : RUN chmod a+rwx $DEB_PATH
 ---> Running in f2f71939dc54
Removing intermediate container f2f71939dc54
 ---> 17124e4589aa
Step 6/8 : RUN dpkg -i $DEB_PATH
 ---> Running in c93df94741e4
Selecting previously unselected package mycalc.
(Reading database ... 4050 files and directories currently installed.)
Preparing to unpack /home/mycalc_0.0.1_amd64.deb ...
Unpacking mycalc (0.0.1) ...
Setting up mycalc (0.0.1) ...
Removing intermediate container c93df94741e4
 ---> d9f0bece9d6b
Step 7/8 : WORKDIR /home/
 ---> Running in ff8a053a87ec
Removing intermediate container ff8a053a87ec
 ---> 29293bfeb0f1
Step 8/8 : CMD ["MyCalc", "-n", "5", "6", "7"]
 ---> Running in a0f8c1a27df1
Removing intermediate container a0f8c1a27df1
 ---> 7178a44a1421
Successfully built 7178a44a1421
Successfully tagged test_deb:0.1
18.0
```
