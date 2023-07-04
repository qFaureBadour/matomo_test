#!/bin/bash
# This script is used to trigger capistrano to deploy on our servers depending on the git branch you're pushing on.
# Then it creates SENTRY releases and environements for lisibility purposes.
set -e

export SENTRY_RELEASE_VERSION=$(sentry-cli releases propose-version)
echo "SENTRY_RELEASE_VERSION : " $SENTRY_RELEASE_VERSION

if [ "${CIRCLE_BRANCH}" == "pre-release" ]; then
    cap preprod deploy 
    #sentry-cli releases new -p ${CIRCLE_PROJECT_REPONAME} $SENTRY_RELEASE_VERSION
    #sentry-cli releases set-commits --auto $SENTRY_RELEASE_VERSION
    #sentry-cli releases deploys $SENTRY_RELEASE_VERSION new -e recette
fi
if [ "${CIRCLE_BRANCH}" == "master" ]; then
    echo "${CIRCLE_BRANCH}"
    cap production deploy
    #sentry-cli releases new -p ${CIRCLE_PROJECT_REPONAME} $SENTRY_RELEASE_VERSION
    #sentry-cli releases set-commits --auto $SENTRY_RELEASE_VERSION
    #sentry-cli releases deploys $SENTRY_RELEASE_VERSION new -e production
fi
