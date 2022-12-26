#!/usr/bin/env bash

set -Eeuo pipefail

msg() {
  echo >&2 -e "${1-}"
}

die() {
  local msg=$1
  local code=${2-1} # default exit status 1
  msg "$msg"
  exit "$code"
}

COOKIE=$(fly ssh console -C "cat app/releases/COOKIE" -q -r iad)
IP=$(fly ips private | awk '(NR==2){ print $3; exit }')
APP_NAME=$(fly info -j | jq -r ".Name")
FULL_NODE_NAME="${APP_NAME}@${IP}"

msg "Attempting to connect to $FULL_NODE_NAME using $COOKIE"

iex --erl "-proto_dist inet6_tcp" --sname my_remote --cookie "$COOKIE" -e "IO.inspect(Node.connect(:'${FULL_NODE_NAME}'), label: \"Node Connected?\"); IO.inspect(Node.list(), label: \"Connected Nodes\")"

