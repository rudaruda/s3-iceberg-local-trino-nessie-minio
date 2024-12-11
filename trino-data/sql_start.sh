#!/bin/bash

nohup /usr/lib/trino/bin/run-trino &

sleep 10

trino < /tmp/sql_start.sql

tail -f /dev/null