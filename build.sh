#!/bin/sh

docker pull phusion/baseimage
docker build -t xforty.net/omd "$(dirname "$0")"
