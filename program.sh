#!/bin/bash


install(){
  npm i --no-package-lock
}

copy(){
  mkdir -p out/jar/ui/
  mkdir -p out/jar/src/Biff/
  cp src/Biff/index.html out/jar/ui/index.html
  cp src/Biff/style.css out/jar/ui/style.css
}

shadow(){
  clj -A:shadow:ui -M -m shadow.cljs.devtools.cli "$@"
}

repl(){
  install
  copy
  shadow clj-repl
  # (shadow/watch :main)
  # (shadow/watch :ui)
  # (shadow/repl :main)
  # :repl/quit
}

compile(){
  shadow release :ui
}

release(){
  rm -rf out
  install
  copy
  compile
}

tag(){
  COMMIT_HASH=$(git rev-parse --short HEAD)
  COMMIT_COUNT=$(git rev-list --count HEAD)
  TAG="$COMMIT_COUNT-$COMMIT_HASH"
  git tag $TAG $COMMIT_HASH
  echo $COMMIT_HASH
  echo $TAG
}

gh_pages(){
  ORIGIN=$(git config --get remote.origin.url)
  cd out/jar/ui
  git init -b gh-pages
  git remote add origin $ORIGIN
  git config --local include.path "../../../../.gitconfig"
  git add .
  git commit -m "and where's my reports?"
  git push -f origin gh-pages
  rm -rf .git
  cd ../../../
}

"$@"