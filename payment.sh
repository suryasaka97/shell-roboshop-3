#!/bin/bash

application="payment"

source ./common.sh

root_userCheck

app_setup

python_setup

systemd_setup

print_time