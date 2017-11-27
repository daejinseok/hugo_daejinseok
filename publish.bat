@echo off

hugo

echo ________________

pushd .
cd ..\daejinseok.github.io
git add --all
git commit -am "auto"
git push
popd

