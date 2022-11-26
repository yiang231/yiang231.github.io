git init
 git add -A
 git commit -m 'deploy'
 git rm dist.sh
 git commit -m 'delete dist.sh'
 git branch 'gh-pages'
 git switch gh-pages
 git remote add origin https://github.com/yiang231/yiang231.github.io.git
 git push -f origin gh-pages
