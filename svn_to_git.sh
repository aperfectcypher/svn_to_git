#!/bin/sh

#Arguments
#################################################################
# ./svn_to_git.sh [authors-file] [svn url] [git repo name] [Remote URL]
#
# authors file is a user names binding file structured like this:
#
# gitname = Firstname Lastname <firstname.lastname@company.com>
# gitname2 = Firstname2 Lastname <firstname.lastname2@company.com>
# ...
#


### Import the SVN repo and convert every commit to git format
git svn clone --stdlayout --authors-file=$1 $2 $3
cd $3
### Parse remote "tags", convert to local tag and delete remotes
git for-each-ref refs/remotes/origin/tags | cut -d / -f 5- | grep -v @ | while read tagname; do git tag $tagname origin/tags/$tagname; git branch -r -d origin/tags/$tagname; done
### Parse remote branches, convert to local branches and delete remotes
git for-each-ref refs/remotes | cut -d / -f 4- | grep -v @ | while read branchname; do git branch $branchname origin/$branchname; git branch -r -d origin/$branchname; done
### Delete trunk (useless, was converted to master)
git branch -D trunk
### Add our new remote
git remote add origin $4
### push everything to new remote
git push -u origin --all
