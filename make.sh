#!/bin/sh

if [ ! -d "build" ]; then
    mkdir build
fi

cd build; cmake ..; make -j install && ( cd .. )
