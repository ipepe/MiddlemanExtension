REM mkdir SiteExtensions\MiddlemanExtension

echo Install WebJob
mkdir %HOME%\site\wwwroot\app_data\jobs\triggered\middleman-build
cp %HOME%\SiteExtensions\MiddlemanExtension\Hooks\middleman-build\run.cmd %HOME%\site\wwwroot\app_data\jobs\triggered\middleman-build\run.cmd
cp %HOME%\SiteExtensions\MiddlemanExtension\Hooks\middleman-build\settings.job %HOME%\site\wwwroot\app_data\jobs\triggered\middleman-build\settings.job

IF NOT EXIST Commands (
    mkdir Commands
)
pushd .\Commands

pushd %temp%

echo Download Dependencies
curl -LOs http://dl.bintray.com/oneclick/rubyinstaller/ruby-2.2.2-i386-mingw32.7z
curl -LOs http://dl.bintray.com/oneclick/rubyinstaller/defunct/DevKit-tdm-32-4.5.2-20110712-1620-sfx.exe
curl -LOks https://raw.githubusercontent.com/rubygems/rubygems/master/lib/rubygems/ssl_certs/index.rubygems.org/GlobalSignRootCA.pem

echo Unpacking Dependencies
start /wait d:\7zip\7za x ruby-2.2.2-i386-mingw32.7z -o%HOME%\SiteExtensions\MiddlemanExtension\Commands\Ruby-2.2.2
start /wait d:\7zip\7za x DevKit-tdm-32-4.5.2-20110712-1620-sfx.exe -o%HOME%\SiteExtensions\MiddlemanExtension\Commands\RubyDevKit
cp GlobalSignRootCA.pem %HOME%\SiteExtensions\MiddlemanExtension\Commands\Ruby-2.2.2\ruby-2.2.2-i386-mingw32\lib\ruby\2.2.0\rubygems\ssl_certs\GlobalSignRootCA.pem

popd

echo Configure RubyDevKit

pushd RubyDevKit

SET PATH=%PATH%;%HOME%\SiteExtensions\MiddlemanExtension\Commands\Ruby-2.2.2\ruby-2.2.2-i386-mingw32\bin

call ruby dk.rb init
echo - %HOME%/SiteExtensions/MiddlemanExtension/Commands/Ruby-2.2.2/ruby-2.2.2-i386-mingw32 >> config.yml
call ruby dk.rb install

popd

echo Ruby installed. Cleaning up Zip Files
rm %temp%\ruby-2.2.2-i386-mingw32.7z
rm %temp%\DevKit-tdm-32-4.5.2-20110712-1620-sfx.exe

echo Install Bundler and Middleman

SET SSL_CERT_FILE=D:\Program Files\Git\usr\ssl\certs

call gem install bundler middleman:"< 4" --no-ri --no-rdoc

popd