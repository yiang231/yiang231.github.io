# `deploy.sh`

# 当发生错误时中止脚本
set -e
npm cache clean -f

npm install -g remove-node-modules
remove-node-modules

# npm install rimraf -g
# rimraf node_modules

rm -rf dist
cd -
