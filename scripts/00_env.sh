#!/usr/bin/env bash
# Verified on Ubuntu 24.04 / x86_64 / gcc 13.3.0 / cmake 3.28.3 / Python 3.12.3
set -euo pipefail
sudo apt-get update -qq
sudo apt-get install -y -qq build-essential cmake git python3-pip
# cFS uses POSIX message queues. The default limit (10) makes cFE SB pipe
# creation fail: OS_QueueCreate_Impl errno=22 -> CFE_EVS/CFE_ES init failure.
echo 512 | sudo tee /proc/sys/fs/mqueue/msg_max >/dev/null
echo "msg_max = $(cat /proc/sys/fs/mqueue/msg_max)"
