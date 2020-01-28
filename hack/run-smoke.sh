#!/bin/bash
# Copyright 2019 Red Hat, Inc. and/or its affiliates
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


# runs all smoke tests for the operator
SCRIPT_NAME=`basename $0`

function usage(){
  printf "Run smoke tests."
  printf "\n"
  printf "\n${SCRIPT_NAME} [options]*"
  printf "\n"
  printf "\nOptions:"
  printf "\n"
  printf "\n-h | --help\n\tPrint the usage of this script."
  printf "\n--ope_name {URI}\n\tOperator image name."
  printf "\n--ope_tag {URI}\n\tOperator image tag."
  printf "\n--maven_mirror {URI}\n\tMaven mirror url to be used when building app in the tests."
  printf "\n--feature {FEATURE_NAME}\n\tRun a specific feature file."
  printf "\n--local ${BOOLEAN}\n\tSpecify whether you run test in local"
  printf "\n-c or --concurrent ${NUMBER}\n\Set the number of concurrent tests. Default is 1."
  printf "\n"
}

FEATURE=""
CONCURRENT=1

while (( $# ))
do
case $1 in
  --ope_name)
    shift
    if [[ ! ${1} =~ ^-.* ]] && [[ ! -z "${1}" ]]; then export OPERATOR_IMAGE_NAME="${1}"; shift; fi
  ;;
  --ope_tag)
    shift
    if [[ ! ${1} =~ ^-.* ]] && [[ ! -z "${1}" ]]; then export OPERATOR_IMAGE_TAG="${1}"; shift; fi
  ;;
  --maven_mirror)
    shift
    if [[ ! ${1} =~ ^-.* ]] && [[ ! -z "${1}" ]]; then export MAVEN_MIRROR_URL="${1}"; shift; fi
  ;;
  --feature)
    shift
    if [[ ! ${1} =~ ^-.* ]] && [[ ! -z "${1}" ]]; then FEATURE="${1}"; shift; fi
  ;;
  --local)
    shift
    if [[ ! ${1} =~ ^-.* ]] && [[ ! -z "${1}" ]]; then if [ "${1}" = "true" ]; then export LOCAL_TESTS=true; fi; shift; fi
  ;;
  -c|--concurrent)
    shift
    if [[ ! ${1} =~ ^-.* ]] && [[ ! -z "${1}" ]]; then export CONCURRENT="${1}"; shift; fi
  ;;
  -h|--help)
    usage
    exit 0
  ;;
  *)
    echo "Unknown arguments: ${1}"
    usage
    exit 1
  ;;
esac
done


echo "-------- Retrieve godog"
go get github.com/DATA-DOG/godog/cmd/godog

echo "-------- Running smoke tests"

cd test/smoke/ && godog -c ${CONCURRENT} --random -f progress ${FEATURE}
