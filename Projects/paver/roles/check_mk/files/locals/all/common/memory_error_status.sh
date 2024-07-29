#!/usr/bin/env bash

# Reports back memory error status
# Rules:
#  - 1 uncorrectable memory error -> CRIT
#  - 50+ correctable memory errors -> CRIT
#  - otherwise, report but OK

harderr_limit=1
softerr_limit=50

function test_ipmitool()
{
  ipmitool sel info >/dev/null 2>&1
  return $?
}

function memory_error_status()
{
  test_ipmitool
  if [ $? -gt 0 ]; then
    echo "result=1; WARN - ipmitool missing"
    return 255
  fi

  _harderr=$(ipmitool sel list 2>/dev/null| grep -w 'Uncorrectable ECC' | wc -l)
  _softerr=$(ipmitool sel list 2>/dev/null| grep -w 'Correctable ECC '| wc -l)
  ((_allerr=_harderr+_softerr))

  if [ $_harderr -ge $harderr_limit ]; then
    echo "result=$_allerr; CRIT - uncorrectable memory errors: $_harderr"; _retcode=2
  elif [ $_softerr -ge $softerr_limit ]; then
    echo "result=$_allerr; WARN - correctable memory errors: $_softerr"; _retcode=1
  else
    echo "result=$_allerr; OK - memory errors: $_allerr"; _retcode=0
  fi

  return $_retcode
}

ServiceDescription="memory_error_status"
Output=$(memory_error_status)
ExitCode=$?

echo "$ExitCode $ServiceDescription $Output"
exit 0
