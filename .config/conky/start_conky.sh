#! /bin/bash

sleep 2
conky -q -d -c $HOME/.config/conky/monitor &
conky -q -d -c $HOME/.config/conky/db.conky &