# USDHelloWorld

Repo for learning about the OpenUSD "fileformat". A "Universal Scene Description", OpenUSD both provides a specification (through the code structure) for how to save information on disk, but also a runtime API to weave together complex interlocking information. 

For more info and to get help: <https://forum.aousd.org/>

Related Projects: [SketchPad](https://github.com/carlynorama/SketchPad) | [GHActionsForOpenUSD](https://github.com/carlynorama/GHActionsForOpenUSD)

USD, unlike other "file formats", has a a mission to provide NON DESTRUCTIVE compilation of information. That makes USD data storage verbose, but also very flexible, and very easy to work on in teams.  

This repo focuses on understanding the specification for saving information in human readable format, the .usda file.  

Proposed Spec for USDA files discussion:  
<https://github.com/PixarAnimationStudios/OpenUSD/pull/2126> 

Proposed Spec for USDC files discussion:  
<https://github.com/PixarAnimationStudios/OpenUSD/pull/2086>

Asset Structure Guidelines:  
<https://github.com/usd-wg/assets/blob/main/docs/asset-structure-guidelines.md>



## Top Getting Started Picks

These are overviews of what USD is / what problems it was meant to solve, not technical installing the library how-tos. 

### Brief OVerview - Video

Luk, Aaron. “Universal Scene Description (OpenUSD): 4 Superpowers to Get You Started,” Video (4:11). YouTube NVIDIA Developer Channel: <https://www.youtube.com/watch?v=1RnTSZK9Sw>. Accessed: 2023 07 13.

Brief overview of what makes USD special by one of the folks who was there at the beginning. 

### In Depth Hello World - Video

Van Gelder, Dirk, "Introduction to USD," Video (26:36). NVidia-On-Demand, GTC Digital (April 2021): <https://www.nvidia.com/en-us/on-demand/session/gtcspring21-s33132/?playlistId=playList-911c5614-4b7f-4668-b9eb-37f627ac8d17>. Accessed: 2023 07 13. 

This does include some 101 how to information, but also explains why USD does things that way. Python focused.

### Longer Overview - Video

- Luk, Aaron. "An Overview of Universal Scene Description (USD) for Building Virtual Worlds," Video (39 minutes).  NVidia-On-Demand, GTC Digital Spring (March 2023). <https://www.nvidia.com/en-us/on-demand/session/gtcspring23-s52054/> Accessed: 2023 07 13. 

Has many "where to find more info" resources at the end. 

### Two Companions 

- Various Authors. Book of USD: Getting Started With Universal Scene Description. <https://remedy-entertainment.github.io/USDBook/> Accessed: 2023 07 13, <https://github.com/Remedy-Entertainment/USDBook/> Accessed: 2023 07 14.

- Various Authors. "USD Terms and Concepts." Universal Scene Description. <https://openusd.org/release/glossary.html> Accessed: 2023 07 13, <https://github.com/PixarAnimationStudios/OpenUSD/tree/release/docs> Accessed: 2023 07 13.

The glossary on the official documentation site, alphabetical by definition, cannot be read in a way that presents a cohesive narrative. 

The Book of USD resource provides simpler definitions in a useful order as an entry point to learn more.

The authors of the Book of USD recommend cross referencing what they've written with the glossary, so I list them as companions. 

### Biggest Surprise

<https://developer.nvidia.com/isaac-sim> No spoilers.


### Where to Find More

Learning content hubs

- <https://openusd.org/>
- <https://developer.nvidia.com/usd>
- <https://wiki.aswf.io/display/WGUSD/Learning+Content>
- <https://developer.apple.com/search/?q=USD>


## Misc Tips

Gotcha's that got me:

- Swift `UUID()` is too long to be a prim identifier, also may start with a number which appears to be not allowed.
- ARKit compliant usd files must be a single usdc file or a usdz archive that contains a single usdc file (plus assets).
- A defaultPrim cannot be a nested prim, e.g. no "defaultPrim = MainPrim/SubPrim"


## In This Repo

### SETUP.md

See SETUP.md for install instructions for the Pixar library and mention of USDZ Tools. 

### examples

.usda files pulled from `explorations` that are good exemplars of a learned concept. 

All of these examples pass `usdchecker` but NONE will pass `usdchecker --arkit` because none of them are usdc files. 

`usdcat -o output_test_2.usdc --flatten $USDA_ROOT_FILE_PATH_WITH_EXT`

Will make many of them pass so far.


### explorations

the support files for the learning about the USD file format series on [whynotestflight.com](http://www.whynotestflight.com). More of a dev journal / travelogue than a how to


#### TOC
- Part 1: [Handwriting USDA files to show a sphere. A python script to generate several of multiple colors.](https://www.whynotestflight.com/excuses/ooohh-a-new-file-format...-hello-usd-part-1/)
- Part 2: [Meshes, and colors and materials, oh my](https://www.whynotestflight.com/excuses/hello-usd-part-2-type-the-rainbow/)
- Part 3: [Exporting from RealityComposer](https://www.whynotestflight.com/excuses/hello-usd-part-3-reality-composer-is-my-usd-wysiwig/)
- Part 4: [first whack at getting the python tools working](https://www.whynotestflight.com/excuses/hello-usd-part-4-python-setup/)
- Part 5: [getting `usdview` to work - See SETUP.md, it's up to date](https://www.whynotestflight.com/excuses/hello-usd-part-5-python-setup-pt-2-what-really-works/)
- Part 6: [Swift script to Match Day 1](https://www.whynotestflight.com/excuses/hello-usd-part-6-same-as-part-1...-but-swift/)
- Part 7: [Getting a checker ARKit compliance checker script working](https://www.whynotestflight.com/excuses/hello-usd-part-7-where-my-error-messages-at/)
- Part 8: [Part 6, but in Package with ArgumentParser](https://www.whynotestflight.com/excuses/hello-usd-part-8-multiball-moves-to-a-package/)
- Part 9: [Learning through Writing a DSL](https://www.whynotestflight.com/excuses/hello-usd-part-9-parlez-vous-multiball-dsl-starts-here/)
- Part 10: [Reading Day, references and takeaways]()
- Part 11: More Swift than USD [StringNode Result Builder](https://www.whynotestflight.com/excuses/hello-usd-part-11-gotta-make-it-easier-to-write-file-builders/)
- Part 12: [Refactoring the USDA writer](https://www.whynotestflight.com/excuses/hello-usd-part-12-lets-make-these-filebuilders-cleaner/) using previous day's work. 
- Part 13: [simplistic USDA validation via XCTest](https://www.whynotestflight.com/excuses/hello-usd-part-13-test-test-test/)
- Part 14: [Running those tests on Linux](https://www.whynotestflight.com/excuses/hello-usd-part-14-now-to-get-github-to-run-the-tests/)
- Part 15: [Cache a USD Build with a GitHub Action](https://www.whynotestflight.com/excuses/hello-usd-part-15-can-a-github-action-cache-a-openusd-build/)


## Link Dump

### Pixar / OpenUSD

- <https://openusd.org/release/index.html>
- <https://github.com/PixarAnimationStudios/OpenUSD>
- <https://openusd.org/release/api/usd_page_front.html>
- <https://openusd.org/release/api/_usd__page__properties_of_scene_description.html#Usd_PrimSpecifiers>


### NVIDIA
- https://developer.nvidia.com/usd
- What is USD video: <https://www.youtube.com/watch?v=1RnTSZK9SwM>
- Getting started USD: (39 minutes) <https://www.nvidia.com/en-us/on-demand/session/gtcspring23-s52054/>
- Introduction to USD <https://www.nvidia.com/en-us/on-demand/session/gtcspring21-s33132/?playlistId=playList-911c5614-4b7f-4668-b9eb-37f627ac8d17>
- Plumbing the Metaverse: <https://www.nvidia.com/en-us/on-demand/session/gtcspring21-s31946/>
- <https://github.com/NVIDIA-Omniverse/USD-Tutorials-And-Examples>
- <https://docs.omniverse.nvidia.com/prod_usd/prod_kit/dev_usd/quick-start/api.html>

### ASWD USD WG

- <https://wiki.aswf.io/display/WGUSD>
- <https://wiki.aswf.io/display/WGUSD/Learning+Content>
- <https://github.com/usd-wg/assets>

### Apple
- Understand USD Fundamentals, WWDC22, https://developer.apple.com/videos/play/wwdc2022/10129/
- Working with USD <https://developer.apple.com/videos/play/wwdc2019/602/>