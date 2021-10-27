#!/bin/bash

set -e

HERE=$( cd $( dirname $0 ) && pwd )

cd $HERE

requirements=$HERE/requirements.txt

venv3=$HERE/venv3
[[ -e $venv3 ]] && rm -rf $venv3
python3 -m venv $venv3
$venv3/bin/pip install --upgrade pip
$venv3/bin/pip install -r $requirements
