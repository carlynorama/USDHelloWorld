#!/bin/sh

## uses pyenv to control version of python
## after installing, run pyenv init in preferred
## shell for instructions to finish configuration.
export PYENV_VERSION=3.7.9

BASEPATH=$(dirname "$0")
export PATH=$PATH:$BASEPATH/bin;
export PYTHONPATH=$PYTHONPATH:$BASEPATH/lib/python

$SHELL