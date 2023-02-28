#!/usr/bin/env bash

set -e

gren make src/TestsMain.gren
node app

gren make src/SeedTestsMain.gren
node app