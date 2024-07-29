#!/usr/bin/env bash

# Report back MCE count
warn=10000
crit=50000

function hw_mca_count()
{
  _count=$(sysctl -n hw.mca.count 2>/dev/null)

  if [ $_count -ge $crit ]; then
    echo "result=$_count; CRIT - number of MCEs critical: $_count"; _retcode=2
  elif [ $_count -ge $warn ]; then
    echo "result=$_count; WARN - number of MCEs found: $_count"; _retcode=1
  else
    echo "result=$_count; OK - number of MCEs found: $_count"; _retcode=0
  fi

  return $_retcode
}

ServiceDescription="hw_mca_count"
Output=$(hw_mca_count)
ExitCode=$?

echo "$ExitCode $ServiceDescription $Output"
exit 0
