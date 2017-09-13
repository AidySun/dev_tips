#!/bin/sh

# "please input y/n:" 
read -p "please input y/n:" inputted

# "${var}+x" is parameter expansion, which evaluates to nothing if ${var} is unset.
if [ -z "inputted+x" ]; then 
    echo empty
fi
test -z $inputted && echo "please input" && read -p "" inputted 

if [ "$inputted" == "y" ]; then
    echo "YES!!!"
else
    echo "No ($inputted)"
fi

