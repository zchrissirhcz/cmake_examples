# 2_build_install_packages

## Use packages
There are many C/C++ open source projects there. We don't re-invent wheels, but we use these wheels. As these third party projects are just consumed by our project, instead of modifying them (most cases), **it might be a good practice to just use their "packages", i.e. header files, library files, instead of their source code**. The generated header files + library files, is called **artifacts**.

How do we get third-party project's artifacts? Some open source project authors provide prebuilt ones, other doesn't. And you may also customize some options for building instead of the prebuilt one. So, **let's build and install 3rd-party project artifacts manually**.

In these directory, I put my daily used packages' building and installing steps(scripts). Hope they can insight you.

## Artifacts Directory
I suggest every C/C++ developer keep an local "artifacts" directory, to store 3rd-party packages. It's OK for one project to put artifacts under its own directory, but common packages like OpenCV, GoogleTest, if you just use it without customization, I prefer reusing artifacts, hence, a global artifacts storing directory is quite useful.

Say, on Linux / MacOS, I use:
```bash
export ARTIFACTS_DIR=~/artifacts
```
And under `$ARTIFACTS_DIR`, each subdirectory is an package's name, then next level is its version, next level is platform/architecture.

And all the building and installing examples under this directory, will install artifacts to `${ARFIFACTS_DIR}`.

By using `${ARTIFACTS_DIR}` as prefix to packages, we have cross-machine same experience: for same package with same version and same platform, we use same path variables on different machines. Quite standard.

## Switching version / branches / tags
Before running these building and installing scripts, people should manually git clone reops, and manually choose branch / tags, then modify building scripts, specifing proper installing directory for correct version.
