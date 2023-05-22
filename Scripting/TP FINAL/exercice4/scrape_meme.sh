#!/bin/bash

curl -s "http://apimeme.com/?ref=apilist.fun" > page.html
grep -o '"[^"]*">' page.html | sed 's/"//;s/">//' > name_memes.txt