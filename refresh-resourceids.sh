#!/usr/bin/env bash
set -euo pipefail

stackname=$(tomlq '.default.global.parameters.stack_name' samconfig.toml | jq -r)
region=$(tomlq '.default.deploy.parameters.region' samconfig.toml | jq -r)

dir=".resourceids-${stackname}"
if [ ! -d "${dir}" ] ;
then
  mkdir "$dir"
fi

rm -f "${dir}"/*.txt "${dir}"/*.json

data=$(aws cloudformation list-stack-resources --region $region --stack-name $stackname) 
echo $data | jq > "${dir}/resources.json"
echo $data | python3 scripts/resourcedescriptionparser.py $dir
# ls -l "${dir}"