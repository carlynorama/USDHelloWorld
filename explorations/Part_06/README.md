# How to compile the files in this folder


## References
- <https://www.whynotestflight.com/excuses/getting-scripty/>
- <https://github.com/carlynorama/swift-scripting/tree/main/example_multi_file_script>

## Don't forget to .gitignore your binaries

Since this repo is not practicing proper hygiene of corralling binary files to a proper bin directory...

If have GNU version of find: 

`find . -executable -type f >> ../.gitignore`

Apple 13.4 (BSD) does not have the `-executable` flag available. 

`find . -type f -perm +111 -print >> ../.gitignore`

## Actual Directions

Swift can't really do multi-file "scripts" as effortlessly as Python since Swift is a compiled language, but if you don't want to bother with making a package or running XCode this will get a similar result.  

compile with: `swiftc *swift -o myappname` where
- `swiftx`: swift complier
- `*swift`: include all files with names that end in `swift` (this directory nonrecursive but can point anywhere)
- `-o myappname`: `-o` means that you are about to give the compiler the name wanted for the output. 

for more info `swiftc --help`

or also ```swiftc `find . -name "*.swift" -maxdepth 1` -o myappname``` where
-  `.`: current directory
- `maxdepth`: how far down the filetree to look
- FYI: using backticks in a shell command is spawning a subshell, e.g. ``` ls -l `which python3` ```

the result will be a new item, an executable, in the file directory which can then be run via the command line with `./myappname`

```otool -L ./myappname``` will print to the console all the libraries that the Linker believes are used of your app. This swiftc compile by default is a dynamic compile  (vs static) so this is a lookup table. The files have not been copied into the app directory. `swiftc -static-executable` when compiling will do a static compile instead (if compiling for a non-Apple platform). 


---

Stage does not specify an upAxis. (fails 'StageMetadataChecker')
Stage does not specify its linear scale in metersPerUnit. (fails 'StageMetadataChecker')
Stage has missing or invalid defaultPrim. (fails 'StageMetadataChecker')
Failed!

usdchecker sphere_base.usd
usdchecker multiball.usda 