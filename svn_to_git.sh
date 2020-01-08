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



git svn clone –stdlayout –authors-file=$2 $1 $3
cd $3
git for-each-ref refs/remotes/tags | cut -d / -f 4- | grep -v @ | while read tagname; do git tag $tagname tags/$tagname; git branch -r -d tags/$tagname; done
git for-each-ref refs/remotes | cut -d / -f 4- | grep -v @ | while read branchname; do git branch $branchname origin/$branchname; git branch -r -d origin/$branchname; done
git branch -D trunk
git remote add origin $4
git push -u origin --all