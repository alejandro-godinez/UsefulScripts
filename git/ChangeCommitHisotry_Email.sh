#!/bin/bash

# WARNING: changes all history read the documentation from git below
# https://git-scm.com/book/en/v2/Git-Tools-Rewriting-History#Changing-Multiple-Commit-Messages


git filter-branch --commit-filter '
        if [ "$GIT_AUTHOR_EMAIL" = "oldemail@test.com" ];
        then
                GIT_AUTHOR_EMAIL="newemail@test.com";
                git commit-tree "$@";
        else
                git commit-tree "$@";
        fi' HEAD