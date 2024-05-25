#!/bin/bash

# Stop all multipass instances
multipass stop --all

# Delete all multipass instances
multipass delete --all

# Purge all deleted instances
multipass purge
