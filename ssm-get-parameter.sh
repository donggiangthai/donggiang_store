#!/usr/bin/env bash

ssm_prefix="$1"
shift
parameter_name="$1"
shift
profile="$1"
shift

if [[ -n $profile ]]; then
  return_value=$(
    aws ssm get-parameter \
      --name "$ssm_prefix/$parameter_name" \
      --with-decryption \
      --region 'us-east-1' \
      --profile "$profile" \
      --query 'Parameter.Value'
  )
else
  return_value=$(
    aws ssm get-parameter \
      --name "$ssm_prefix/$parameter_name" \
      --with-decryption \
      --region 'us-east-1' \
      --query 'Parameter.Value'
  )
fi

echo "$return_value"
