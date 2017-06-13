#!/usr/bin/env bash

cd testing/tests
elm-package install -y
cd ..
elm-test