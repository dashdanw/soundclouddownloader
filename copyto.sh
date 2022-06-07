#!/bin/bash
for D in $(find * -mindepth 0 -maxdepth 0 -type d)
do
    ./user_rip.sh $D
done
