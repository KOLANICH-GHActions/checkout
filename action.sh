#!/usr/bin/env bash

set -xe;
repository=$1;
ref=$2;
path=$3;
fetchDepth=$4;
submodules=$5;

THIS_SCRIPT_DIR=`dirname "${BASH_SOURCE[0]}"`;
THIS_SCRIPT_DIR=`realpath "${THIS_SCRIPT_DIR}"`;

echo "##[group] Cloning $repository";
if [[ $repository == https://* ]] || [[ $repository == git@* ]]
then :
else
	repository=https://github.com/${repository};
fi;

if [ -z "${path}" ]; then
	repoName=$(python3 $THIS_SCRIPT_DIR/getRepoName.py ${repository});
	path=$(realpath $repoName);
fi;

prevCWD=$PWD;

if [ -z "${ref}" ]; then
	git clone --depth=${fetchDepth} ${repository} ${path};
	cd ${path};
else
	remoteName=origin;
	mkdir -p ${path};
	cd ${path};
	git init;
	git remote add ${remoteName} ${repository};
	git fetch origin ${ref} --depth=${fetchDepth};
	git checkout ${ref};
fi

if [ -z "${submodules}" ] || [ "${submodules}" -eq "0" ]; then
	:
else
	git submodule update --init --recursive;
fi;

cd $prevCWD;
echo "##[endgroup]";
