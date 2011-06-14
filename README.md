# TimberKit #
TimberKit is an ObjC/Cocoa wrapper for the [Forrst](http://forrst.com) [API](http://forrst.com/api) in the form of a framework.

## There's something better already out there ##
I wrote TimberKit before I was aware of a much more complete wrapper:

https://github.com/bnmuller/FTForrstEngine

I highly recommend you use that library instead of TimberKit.

Props Ben!

## Example usage ##
  ```objective-c
  TKPost *post = [TKPost postWithTinyID: @"BHM"];

  NSLog(@"%@", post.title);
  ```
