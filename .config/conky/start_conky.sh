#! /bin/bash

sleep 2
conky -q -d -c $HOME/.config/conky/clock.conky &
conky -q -d -c $HOME/.config/conky/db.conky &