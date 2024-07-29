#!/usr/bin/env bash

# Simple wrapper around gds_mha's check_instances.sh

MHAUSER=gds_mha

sudo -u "${MHAUSER}" /home/gds_mha/check_instances.sh
