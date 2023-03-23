#!/bin/sh

sensors | grep "Package id 0:" | tr -d '+°C' | sed 's/\.0//' | awk '{print $4}'
