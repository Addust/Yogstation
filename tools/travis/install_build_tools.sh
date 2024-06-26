#!/bin/bash
set -euo pipefail

source dependencies.sh

source ~/.nvm/nvm.sh
nvm install $NODE_VERSION_PRECISE
nvm use $NODE_VERSION_PRECISE
npm install --global yarn

pip3 install --user PyYaml
pip3 install --user beautifulsoup4