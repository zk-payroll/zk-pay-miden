#!/bin/bash
set -e

# ensure we kill all child processes when we exit
trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM EXIT

CLEAN=${CLEAN:-false}
ARCHIVE=${ARCHIVE:-false}
# Parse arguments for the script

while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -c|--clean)
            CLEAN=true
            shift # past argument
            ;;
        --archive)
            ARCHIVE=true
            shift # past argument
            ;;
        *)    # unknown option
            shift # past argument
            ;;
    esac
done

pushd .

# Check if we should clean the tmp directory
if [ "$CLEAN" = true ]; then
  echo "Cleaning tmp directory"
  rm -rf ./tmp
  mkdir -p ./tmp/{data,accounts} 
  
  miden-node bundled bootstrap \
    --data-directory ./tmp/data \
    --accounts-directory ./tmp/accounts
fi



miden-node bundled start \
  --data-directory ./tmp/data \
  --rpc.url http://0.0.0.0:57291


popd