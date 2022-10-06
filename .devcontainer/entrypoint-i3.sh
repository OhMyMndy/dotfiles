#!/usr/bin/env bash


DISPLAY=:3 supervisord --nodaemon \
    --config ~/.config/i3/novnc-supervisor.conf


exec "$@"