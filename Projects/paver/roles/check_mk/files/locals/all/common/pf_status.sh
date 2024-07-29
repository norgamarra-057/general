#!/usr/bin/env bash

# Check pf status and raise critical error if it is not enabled

function pf_status
{
  if [ -c /dev/pf ]; then
    _status=$(pfctl -si 2>&1 | awk '{if ($1 ~ /^Status/){ print $2 }}')
  else
    _status="not loaded"
  fi
  case $_status in
    "Enabled")  echo "result=0; OK - pf is $_status"; _retcode=0 ;;
            *)  echo "result=2; CRIT - pf is $_status"; _retcode=2 ;;
  esac
  return $_retcode
}

ServiceDescription="pf_status"
Output=$(pf_status)
ExitCode=$?

echo "$ExitCode $ServiceDescription $Output"
exit 0
