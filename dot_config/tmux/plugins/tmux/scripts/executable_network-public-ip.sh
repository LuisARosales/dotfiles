#!/usr/bin/env bash

# setting the locale, some users have issues with different locales, this forces the correct one
export LC_ALL=en_US.UTF-8
LAST_EXEC_FILE="/tmp/.dracula-tmux-public-ip-last-exec"
DATAFILE="/tmp/.dracula-tmux-public-ip"
RUN_EACH=86400
TIME_NOW=$(date +%s)
TIME_LAST=$(cat "${LAST_EXEC_FILE}" 2>/dev/null || echo "0")

current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $current_dir/utils.sh

main() {
  IP_SERVER="ifconfig.me"
  if [ "$(expr ${TIME_LAST} + ${RUN_EACH})" -lt "${TIME_NOW}" ]; then
 	ip=$(curl -s "$IP_SERVER")
	IP_LABEL=$(get_tmux_option "@dracula-network-public-ip-label" "")
	echo "${TIME_NOW}" > "${LAST_EXEC_FILE}"
	echo "$IP_LABEL $ip" > "${DATAFILE}"
   
  fi
  cat "${DATAFILE}"
}

# run the main driver
main
