# OpenUSD Pixar Library Set Up Instructions for MacOS


These are the instruction to install the full library from Pixar. If your language of choice will be python and you don't need every last feature try `pip install usd-core` instead.

- <https://pypi.org/project/usd-core/>


WIP: Created 2023 07 01 for OpenUSD 23.05, Updated 07 24 for 23.08 and Ubuntu 22.04.2

## Install Steps

CMake is required. `brew install cmake` if Homebrew is installed. 

Note for Linux: USD requires CMake 3.24 or higher. `sudo apt install cmake` may not get that for you. [Check the version before installing](https://unix.stackexchange.com/questions/6284/how-do-i-check-package-version-using-apt-get-aptitude). Instructions for installing the latest version of CMake [here](https://cmake.org/install/)(official) and [here](https://graspingtech.com/upgrade-cmake/)(using snappy).

### C++ tools only

Tested with with 23.05/Python 3.11, 23.08/3.10 on MacOS 13.4.1
(Python may only used to run the build script? TODO: Be sure.) 

```zsh

cd $DOWNLOAD_DIR
git clone https://github.com/PixarAnimationStudios/OpenUSD.git
# there will now be a directory called OpenUSD in the pwd
# the below will show the build options
python3 OpenUSD/build_scripts/build_usd.py
# run with the --no-python option
python3 OpenUSD/build_scripts/build_usd.py --no-python $BUILD_DEST_DIR
```

### Python, no usdview

Tested successfully with 23.05/Python 3.9, 23.08/3.10 on MacOS 13.4.1

```zsh
git clone https://github.com/PixarAnimationStudios/OpenUSD.git
# there will now be a directory called OpenUSD in the pwd
python3 OpenUSD/build_scripts/build_usd.py --no-usdview $BUILD_DESTINATION
```
TODO: Does this also need numpy? 

### Python, usdview

Tested successfully with 23.05/Python 3.9 on MacOS 13.4.1

```zsh
pip3 install PyOpenGL
pip3 install PySide6==6.4.3 # <- Bug in USD 23.05 PySide6 >= 6.5.0 
pip3 install numpy # <- USDView asks for this later
git clone https://github.com/PixarAnimationStudios/OpenUSD.git
# there will now be a directory called OpenUSD in the pwd
python3 OpenUSD/build_scripts/build_usd.py $BUILD_DESTINATION
```

## Set Up Environment

Example script to set up the environment. 

Save this file as `$BUILD_DESTINATION/OpenUSDLauncher.command`,  Don't forget to `chmod 755 OpenUSDLauncher.command`

When using that build of OpenUSD, launch the shell by double clicking on the file.

Alternatively remove `$SHELL` at the bottom of the file, save it as `OpenUSDLauncher.sh` and run it with `. ./OpenUSDLauncher.sh` (if pwd is the script's directory.)

```sh
#!/bin/sh

## WHICH PYTHON

## Uncomment below if using pyenv to manage python version
# export PYENV_VERSION=3.9

## Uncomment below if using system installed python
# PATH="/Library/Frameworks/Python.framework/Versions/3.9/bin:${PATH}"
# export PATH


## WHICH PATH

## If script lives in the build folder the below will work.
BASEPATH=$(dirname "$0")
export PATH=$PATH:$BASEPATH/bin;
export PYTHONPATH=$PYTHONPATH:$BASEPATH/lib/python

## For use if script does not live in build folder. 
# BUILD_DESTINATION=/must/be/set
# export PATH=$PATH:$BUILD_DESTINATION/bin;
# export PYTHONPATH=$PYTHONPATH:$BUILD_DESTINATION/lib/python

## CONFIRMING ENVIRONMENT
## uncomment if desired. 
# env

## LAUNCH THE SHELL
$SHELL

```

## Verifying / Testing

### Checking the environment

```sh
which python3
python3 --version
echo $PATH
echo $PYTHONPATH
env

```

### Simple python test

Open repl in shell (`python3`) and type the following line by line (from <https://openusd.org/release/tut_helloworld.html>)

Must be executed in a directory where the user has permission to save. 

```python
from pxr import Usd, UsdGeom #This is the hard one... 
stage = Usd.Stage.CreateNew('HelloWorld.usda') 
xformPrim = UsdGeom.Xform.Define(stage, '/hello') 
spherePrim = UsdGeom.Sphere.Define(stage, '/hello/world') 
stage.GetRootLayer().Save()
# Cntrl-D to leave
```

### Check usdview

If following directly the REPL check in the same shell session the below should launch `usdview` and display a Sphere in the render window.  `usdview` takes one argument, a valid usd, usdc, usda or usdz file.

`usdview HelloWorld.usda`

## USDZ Tools

The USDZ scripts work better when run using a fresh build of the Pixar tools in the path instead of the included build and then running the script with that build's preferred python explicitly: e.g. `python3 /Applications/usdpython/usdzconvert/usdARKitChecker -v three_d_thing.usda`

TODO: Boost may have to be updated/altered to get all of the samples to run. What is the PIL module? 

## Tips on using different version of Python

### pyenv

<https://github.com/pyenv/pyenv>

Install instructions with Homebrew

```sh
brew install pyenv # and dependencies...
pyenv install 3.9
pyenv init #to get instructions on how to configure your shell
# follow instructions and relaunch shell
```

If using zsh as default shell the instructions will be 

```sh
# Load pyenv automatically by appending
# the following to 
# ~/.zprofile (for login shells)
# and ~/.zshrc (for interactive shells) :

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Restart your shell for the changes to take effect.
```

This means pyenv will take over managing Python in every zsh shell. Alternatively one could put those lines at the top of the `.command` file instead.

To then use pyenv, one choice is to call it at the beginning of any shell process, for example:

```
pyenv shell 3.9
python3 --version # expected: 3.9.17
which pip3 #expected: /Users/$USER/.pyenv/shims/pip3
pip3 install PyOpenGL #if prompted to update pip, go ahead.
pip3 install PySide6
cd $DIRECTORY_WITH_CLONED_REPO
python3 OpenUSD/build_scripts/build_usd.py $BUILD_DESTINATION 
```

