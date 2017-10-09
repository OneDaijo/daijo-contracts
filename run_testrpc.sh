#!/usr/bin/env bash

# This script runs testrpc now that the options are becoming more complex.
# It is assumed that the user has testrpc installed and in his or her path.

# Attempt to kill all running testrpc instances to start fresh, but don't fail if none are found.
# Note: this is necessary because testrpc instances running on the same port cannot coexist.
pkill -f testrpc || true

# Runs testrpc in the background, creating two accounts and silencing output.
# To bump the gas limit (helpful for increasingly gas hungry test deployments).
# To see output, remove "&> /dev/null".
# To see more detailed output, use the --debug option after removing the aforementioned portion.
# To Add more accounts, repeat the first account line with a modified private key.
# To run in the foreground, remove the trailing '&'.
# Note, despite being backgrounded, this testrpc instance will be tied to this session, meaning it will terminate when
# this session ends.
testrpc --gasLimit 471238801 \
--account="0x0000000000000000000000000000000000000000000000000000000000000001,1000000000000000000000000000" \
--account="0x0000000000000000000000000000000000000000000000000000000000000002,1000000000000000000000000000" &> /dev/null &
