#!/bin/bash
#Configs
$(dirname "$0")/rmstuff.sh

my_repo="$HOME/ec2site.git"
my_worktree=/opt/bitnami/apache2/htdocs
my_origin="ssh://git@bitbucket.org/makombo/test.git"
