#!/bin/bash

set -eo pipefail

PACKAGE=$1
ORGANIZATION=$2
BRANCH=$3
ONLY_DRY=$4
TMP="tmp_split/${RANDOM}"

ALIAS_ORIGIN="origin-${PACKAGE}"

SSH="git@github.com:${ORGANIZATION}/${PACKAGE}.git"

set -u

DIR_PWD=`pwd`

echo "Monorepo Split – ${PACKAGE}"

echo "Init environment"
cd ${DIR_PWD}
echo "mkdir -p ${DIR_PWD}/${TMP}/${PACKAGE}"
mkdir -p ${DIR_PWD}/${TMP}/${PACKAGE}

echo "git clone --bare .git ${DIR_PWD}/${TMP}/${PACKAGE}"
git clone --bare .git ${DIR_PWD}/${TMP}/${PACKAGE}

echo "cd ${DIR_PWD}/${TMP}/${PACKAGE}"
cd ${DIR_PWD}/${TMP}/${PACKAGE}

git filter-repo --subdirectory-filter packages/${PACKAGE} --force

git remote add ${ALIAS_ORIGIN} ${SSH}

echo "dry-run"
git push ${ALIAS_ORIGIN} ${BRANCH} --dry-run --verbose
git push ${ALIAS_ORIGIN} ${BRANCH} --tags --dry-run --verbose

#echo "git push"
#git push ${ALIAS_ORIGIN} ${BRANCH} --verbose
#git push ${ALIAS_ORIGIN} ${BRANCH} --tags --verbose
