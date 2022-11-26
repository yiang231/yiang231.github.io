# `deploy.sh`

# 当发生错误时中止脚本
set -e
#不要更新依赖
#npm i -g npm-check-updates
#ncu -u
#npm update
npm i
mkdir dist
cd dist
#写入<github-username>.github.io仓库gh-pages分支文件
echo -e "git init\n git add -A\n git commit -m 'deploy'\n git rm dist.sh\n git commit -m 'delete dist.sh'\n git branch 'gh-pages'\n git switch gh-pages\n git remote add origin https://github.com/yiang231/yiang231.github.io.git\n git push -f origin gh-pages" > dist.sh
#写入CNAME文件，自定义域名
echo "yjdl.eu.org" > CNAME
npm run build
cd -
#使用说明
#  Git Bash中运行
#  使用以下命令sh deploy.sh
