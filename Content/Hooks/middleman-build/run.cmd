SET PATH=%PATH%;%HOME%\SiteExtensions\MiddlemanExtension\Commands\Ruby-2.3.3\ruby-2.3.3-i386-mingw32\bin
cd %HOME%/site/repository
echo Installing dependencies
call bundle install --without=development,test --deployment
echo Building middleman
call bundle exec middleman build --build-dir="%HOME%/site/wwwroot"