#!/bin/sh

[ -n "${AWS_DEFAULT_REGION}" ] && export AWS_REGION=${AWS_DEFAULT_REGION}
if [ -n $1 ]
then
    option=" SPEC=$1"
fi
bundle exec rake spec $option
