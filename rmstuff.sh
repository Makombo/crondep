#!/bin/bash
cd $(dirname "$0")
source config.sh

crontab -r
rm -rf $my_gitdir
rm -rf $my_worktree
