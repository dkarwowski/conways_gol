#!/usr/bin/env bash

if [ -z "$1" ] || ([ "$1" != "test" ] && [ "$1" != "visual" ]); then
    echo "usage: $0 test|visual"
    exit
fi

cat conways_life.asm conways_$1.asm > out/conways_$1.asm
