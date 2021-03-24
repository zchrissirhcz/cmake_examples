Set-PSDebug -Trace 0

$BUILD_DIR="vs2019-x64"

if(!(test-path $BUILD_DIR))
{
    New-Item -ItemType Directory -Force -Path $BUILD_DIR
}

cd $BUILD_DIR

cmake ..\.. -G "Visual Studio 16 2019" -A x64 -DCMAKE_BUILD_TYPE=Release $(type ..\options.txt) \

cd ..