#!/bin/sh

set -xe

ln -fs /usr/share/zoneinfo/Asia/Singapore /etc/localtime
dpkg-reconfigure --frontend noninteractive tzdata
