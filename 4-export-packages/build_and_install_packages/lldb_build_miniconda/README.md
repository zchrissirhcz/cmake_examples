Only tested on ubuntu 20.04

1. install miniconda3
2. install apt dependencies that enable auto completion
sudo apt install swig libedit-dev libeditline-dev
brew install swig libedit
3. enter conda base env
4. build clang with `build-clang.sh`
5.(mac only)
cd ~/work/github/LLVM
cd lldb
./scripts/macos-setup-codesign.sh
5. build lldb with `build-lldb-miniconda.sh`
6. resolve the python shared lib's symbolic link for lldb build
7. install clang and lldb
8. resolve lldb installation paths python shared lib's symbollic link
9. create lldb's soft link. Or, put to path via modify ~/.pathrc
