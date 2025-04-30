#!/bin/bash
binary=`basename $0`
export LD_LIBRARY_PATH=/target/libs
exec /target/release/$binary "$@"
