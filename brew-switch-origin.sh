#!/bin/bash
# Author: John Yuan <https://github.com/john-yuan>
# Github: https://github.com/john-yuan/brew-switch-origin

# See also:
# https://mirrors.ustc.edu.cn/help/brew.git.html
# https://mirrors.ustc.edu.cn/help/homebrew-core.git.html

readonly ACTION="$1"
readonly USE_ORIGIN="$2"
readonly BREW_REPO_DIR="$(brew --repo)"
readonly BREW_CORE_REPO_DIR="$(brew --repo)/Library/Taps/homebrew/homebrew-core"

# github
readonly BREW_ORIGIN_GITHUB="https://github.com/Homebrew/brew.git"
readonly BREW_CORE_ORIGIN_GITHUB="https://github.com/Homebrew/homebrew-core.git"

# ustc
readonly BREW_ORIGIN_USTC="https://mirrors.ustc.edu.cn/brew.git"
readonly BREW_CORE_ORIGIN_USTC="https://mirrors.ustc.edu.cn/homebrew-core.git"

if [ "$ACTION" == "" ]
then
    echo "Usage: $0 [check|use] [options]"
    exit
fi

if [ "$ACTION" == "check" ]
then
    if [ -d "$BREW_REPO_DIR" ]
    then
        cd $BREW_REPO_DIR
        echo
        echo "homebrew($BREW_REPO_DIR):"
        git remote -v
    fi

    if [ -d "$BREW_CORE_REPO_DIR" ]
    then
        cd $BREW_CORE_REPO_DIR
        echo
        echo "homebrew-core($BREW_CORE_REPO_DIR):"
        git remote -v
    fi
    echo
    exit
fi

if [ "$ACTION" == "use" ]
then
    if [ "$USE_ORIGIN" == "" ]
    then
        echo "No origin specified."
        echo "Usage: $0 use [github|ustc]"
        exit 1
    fi

    BREW_ORIGIN_FOUND="NO"
    BREW_ORIGIN=""
    BREW_CORE_ORIGIN=""

    if [ "$USE_ORIGIN" == "github" ]
    then
        BREW_ORIGIN_FOUND="YES"
        BREW_ORIGIN="$BREW_ORIGIN_GITHUB"
        BREW_CORE_ORIGIN="$BREW_CORE_ORIGIN_GITHUB"
    fi

    if [ "$USE_ORIGIN" == "ustc" ]
    then
        BREW_ORIGIN_FOUND="YES"
        BREW_ORIGIN="$BREW_ORIGIN_USTC"
        BREW_CORE_ORIGIN="$BREW_CORE_ORIGIN_USTC"
    fi

    if [ "$BREW_ORIGIN_FOUND" == "NO" ]
    then
        echo "Unknown origin \"$USE_ORIGIN\""
        echo "Usage: $0 use [github|ustc]"
        exit 1
    fi

    if [ -d "$BREW_REPO_DIR" ]
    then
        if [ "$BREW_ORIGIN" != "" ]
        then
            cd $BREW_REPO_DIR
            echo
            echo "Changing origin of homebrew($BREW_REPO_DIR)"
            echo
            echo "Previous:"
            git remote -v
            git remote set-url origin $BREW_ORIGIN
            echo
            echo "Now:"
            git remote -v
        fi
    fi

    if [ -d "$BREW_CORE_REPO_DIR" ]
    then
        if [ "$BREW_CORE_ORIGIN" != "" ]
        then
            cd $BREW_CORE_REPO_DIR
            echo
            echo "Changing origin of homebrew-core($BREW_CORE_REPO_DIR)"
            echo
            echo "Previous:"
            git remote -v
            git remote set-url origin $BREW_CORE_ORIGIN
            echo
            echo "Now:"
            git remote -v
        fi
    fi
    echo
    exit
fi

echo "Unknown action \"$ACTION\""
echo "Usage: $0 [check|use] [options]"
exit 1
