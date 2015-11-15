#!/bin/bash

DEPS=$(
for i in /usr/local/bin/* /usr/local/sbin/*
do
	ldd $i
done | awk '{print $3}' | sort -u
)

for i in $DEPS
do
	dpkg -S $i
done | awk -F: '{print $1}' | sort -u

