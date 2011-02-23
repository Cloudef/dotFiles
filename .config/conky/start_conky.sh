#! /bin/bash

sleep 2
conky -q -d -c $HOME/.config/conky/monitor.conky &
(conky -q -d -c $HOME/.config/conky/calendar.conky && conky -q -d -c $HOME/.config/conky/db.conky) &
conky -q -d -c $HOME/.config/conky/time.conky &