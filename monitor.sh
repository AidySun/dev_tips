#!/bin/bash

while true; do  
    if pgrep -x ExManCmd >/dev/null; then  
        # echo "Program A is running."  
        echo "`ps aux | grep ExManCmd`"
    fi  

    sleep 0.01 # sleep x seconds
done
