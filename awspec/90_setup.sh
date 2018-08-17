#!/bin/sh

export AWS_DEFAULT_REGION=ap-northeast-1

declare -a GEN_TYPES
GEN_TYPES+=(ec2)
GEN_TYPES+=(network_acl)
GEN_TYPES+=(route_table)
GEN_TYPES+=(security_group)
GEN_TYPES+=(vpc)
GEN_TYPES+=(subnet)

declare -a GEN_NOVPC_TYPES
GEN_NOVPC_TYPES+=(eip)

gem install bundler
bundle install --path vendor/bundler
bundle exec awspec init

pushd .
mkdir -p spec
cd spec
for vpc in $(aws ec2 describe-vpcs --query 'Vpcs[].VpcId' --output text)
do
    mkdir -p ./${vpc}
    for _type in ${GEN_TYPES[@]}
    do
        echo "Generating spec ${_type} for ${vpc}"
        echo "require 'spec_helper'" > ./${vpc}/prod_${_type}_spec.rb
        bundle exec awspec generate ${_type} ${vpc} >> ./${vpc}/prod_${_type}_spec.rb
    done
done

# not require vpc-id
mkdir -p ./common
for _type in ${GEN_NOVPC_TYPES[@]}
do
    echo "Generating spec for ${_type}"
    echo "require 'spec_helper'" > ./common/prod_${_type}_spec.rb
    bundle exec awspec generate ${_type} >> ./common/prod_${_type}_spec.rb
done

popd
./inject_definition.rb
