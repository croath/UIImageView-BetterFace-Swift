UIImageView-BetterFace-Swift
============================

The Swift version of https://github.com/croath/UIImageView-BetterFace

##Why?

 - Have problems showing the resized image previews? 
 - People in the preview only have chins but not faces?
 - A group photo doesn't look well?

Try UIImageView-BetterFace!

##Preview

![preview](https://raw.github.com/croath/UIImageView-BetterFace/master/doc/preview.png)

##How?

 1. drag `UIImageView+BetterFace.h` and `UIImageView+BetterFace.m` to your project
 2. add CoreImage.framework to your project
 3. import the .h file
 4. add `hack_uiimageview_bf();` to your `main` function
 5. add this:`[anImageView setNeedsBetterFace:YES];`
 6. done
 7. still have problems? clone the project and see the demo.
