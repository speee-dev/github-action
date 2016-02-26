#!/bin/bash

cd $(dirname $(readlink -e $0))
. /etc/profile.d/rbenv.sh

./bin/rake "$@"
