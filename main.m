//
//  main.m
//  TimberKit
//
//  Created by Alan Smith on 6/13/11.
//  Copyright 2011 CloakedCode. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <TimberKit/TimberKit.h>

int main(int argc, char *argv[])
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	TKPost *post = [TKPost postWithTinyID: @"BMH"];
	
	NSLog(@"Post title: %@", post.title);
	
	[pool release];
    //return NSApplicationMain(argc,  (const char **) argv);
}
