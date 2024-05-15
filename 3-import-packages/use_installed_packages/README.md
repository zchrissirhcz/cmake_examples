# 3_use_installed_packages

The previous directory "2_build_and_install_packages" give many open source building and installing steps. After installation, how do we use them? Since mose of them provide good "find_package" experience, we just use `find_package()` to find them, them mark each of them as required dependency for our testing-purpose target.