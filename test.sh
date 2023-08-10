#!/bin/bash
#dpkg -b mycalc
docker build -t test_deb:0.1 .
docker run -i -t --rm test_deb:0.1 
