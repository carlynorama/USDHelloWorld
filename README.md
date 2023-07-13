# USDHelloWorld

Repo for learning about the OpenUSD "fileformat". A "Universal Scene Description", OpenUSD both provides a specification for information on disk, but also a runtime API to render complex schemas. This repo focuses on understanding the specification for saving information in human readable format, the .usda file.  

## Misc References

### Apple
- Understand USD Fundamentals, WWDC22, https://developer.apple.com/videos/play/wwdc2022/10129/
- Working with USD <https://developer.apple.com/videos/play/wwdc2019/602/>

### Pixar / OpenUSD

- https://openusd.org/release/index.html
- https://github.com/PixarAnimationStudios/OpenUSD
- https://x3dgraphics.com/slidesets/X3dForWebAuthors/Chapter05AppearanceMaterialTextures.pdf
- https://openusd.org/release/api/usd_page_front.html>
- https://openusd.org/release/api/_usd__page__properties_of_scene_description.html#Usd_PrimSpecifiers
- <https://docs.omniverse.nvidia.com/prod_usd/prod_kit/dev_usd/quick-start/api.html>

### NVIDIA
- https://developer.nvidia.com/usd
- What is USD video: <https://www.youtube.com/watch?v=1RnTSZK9SwM>
- Getting started USD: (39 minutes) <https://www.nvidia.com/en-us/on-demand/session/gtcspring23-s52054/>
- Introduction to USD <https://www.nvidia.com/en-us/on-demand/session/gtcspring21-s33132/?playlistId=playList-911c5614-4b7f-4668-b9eb-37f627ac8d17>
- Plumbing the Metaverse: <https://www.nvidia.com/en-us/on-demand/session/gtcspring21-s31946/>
- <https://github.com/NVIDIA-Omniverse/USD-Tutorials-And-Examples>

### ASWD USD WG

- <https://wiki.aswf.io/display/WGUSD>
- <https://wiki.aswf.io/display/WGUSD/Learning+Content>
- <https://github.com/usd-wg/assets>

## Misc Tips

Gotcha's that got me:

- Swift `UUID()` is too long to be a prim identifier.
- ARKit compliant usd files must be a single usdc file or a usdz archive that contains a single usdc file (plus assets).


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



