#!/bin/sh
set -eo pipefail

# for integer comparisons: check_counts <testValue> <expectedValue> <testName>
check_counts() {
 if [ $1 -eq $2 ]
 then
   echo "√ $3"
 else
   echo "✗ $3"
   tests_failed=$((tests_failed+1))
fi
}

tests_failed=0

VPC_ID=`cat terraform-out/terraform-out.json | jq -r '.vpc_id.value'`
export AWS_DEFAULT_REGION=eu-west-1

subnet_count=`aws ec2 describe-subnets | jq --arg VPC_ID "$VPC_ID" '.Subnets[]| select (.VpcId==$VPC_ID)' | jq -s length`
check_counts $subnet_count 3 "Expected # of Subnets"

exit $tests_failed