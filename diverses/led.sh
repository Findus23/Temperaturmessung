#!/bin/bash
gpio mode 13 out
gpio mode 12 out
gpio mode 3 out

gpio write 3 0
gpio write 12 0
gpio write 13 0

while true
do
	gpio write 3 1
	sleep 5
	gpio write 3 0
	sleep 0.5
	gpio write 3 1
	sleep 0.5
	gpio write 3 0
	sleep 0.5
	gpio write 3 1
	sleep 0.5
	gpio write 3 0
	sleep 0.5
	gpio write 3 1
	sleep 0.5
	gpio write 3 0
	gpio write 13 1
	sleep 2
	gpio write 13 0
	gpio write 12 1
	sleep 8
	gpio write 13 1
	sleep 2 
	gpio write 12 0
	gpio write 13 0
done
#rand=$((RANDOM % 3))
#case "$rand" in
#		"0")gpio write 3 1
#			gpio write 12 0
#			gpio write 13 0
#			;;
#		"1")gpio write 3 0
#			gpio write 12 1	
#			gpio write 13 0 
#			;;
#		"2")gpio write 3 0
#			gpio write 12 0
#			gpio write 13 1 
#			;;
#esac
