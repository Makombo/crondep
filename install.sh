#!/bin/bash

cd $(dirname "$0")
source config.sh

function error_exit {
    echo "$1" >&2   ## Send message to stderr. Exclude >&2 if you don't want it that way.
    exit "${2:-1}"  ## Return a code specified by $2 or 1 by default.
}

#Conventions
the_post_receive_hook=$my_gitdir/hooks/post-receive
the_pre_receive_hook=$my_gitdir/hooks/pre-receive
the_puller=$my_gitdir/puller/pull
the_log=$my_gitdir/puller/pull.log

#Script
#echo "...  check if $my_worktree is symlink"
#if [[ -L $my_worktree ]]; then
#  error_exit " ... Working tree is a symlink!"
#fi

echo "... doing git init at $my_gitdir"
 $(which git) init --bare $my_gitdir
my_git="$(which git) --work-tree=$my_worktree --git-dir=$my_gitdir" 

#echo "...  backing up worktree $my_worktree to original_backup branch at $my_origin"
echo "...  checking if worktree $my_worktree already exists"
if [ -d "$my_worktree" ]; then
  error_exit " ... Working tree already exists"
	#$my_git branch original_backup
	#$my_git checkout original_backup
	#$my_git add .
	#$my_git commit -m "Initial commit for backup of original"
	#$my_git push -u $my_origin original_backup 
	#$my_git checkout master
else 
	mkdir -p "$my_worktree"
fi

echo "... doing git pull from $my_origin"
  $my_git pull $my_origin master 
  

cat << EOF > $the_post_receive_hook
#!/bin/sh
$my_git checkout -f
EOF

cat << EOF > $the_pre_receive_hook
#!/bin/sh
$my_git clean -fd
$my_git reset --hard HEAD
EOF

mkdir -p $my_gitdir/puller
cat << EOF > $the_puller
#!/bin/sh
cd $my_gitdir 
$my_git pull $my_origin master 
EOF

echo "... setting permissions of $the_post_receive_hook, $the_pre_receive_hook, $the_puller"
chmod +x $the_post_receive_hook $the_pre_receive_hook $the_puller

echo "... setting cron job"
(crontab -l ; echo "* * * * * $the_puller > $the_log 2>&1") | sort - | uniq - | crontab -
#(crontab -l ; echo "0 * * * * rm $the_log 2>&1") | sort - | uniq - | crontab -

echo ""
echo "===== Installation Complete !! ====="
