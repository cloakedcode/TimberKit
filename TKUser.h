//
//  TKUser.h
//  TimberKit
//
//  Created by Alan Smith on 6/13/11.
//  Copyright 2011 CloakedCode. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface TKUser : NSObject {
	int ID;
	NSString *username;
	NSString *name;
	NSURL *url;
	int postCount;
	int commentCount;
	int likeCount;
	int followerCount;
	int followingCount;
	NSDictionary *photos;
	NSString *bio;
	NSString *isA;
	NSURL *homepageURL;
	NSString *twitterUsername;
	BOOL inDirectory;
	NSArray *tags;
}

@property (assign) int ID;
@property (assign) NSString *username;
@property (assign) NSString *name;
@property (assign) NSURL *url;
@property (assign) int postCount;
@property (assign) int commentCount;
@property (assign) int likeCount;
@property (assign) int followerCount;
@property (assign) int followingCount;
@property (assign) NSDictionary *photos;
@property (assign) NSString *bio;
@property (assign) NSString *isA;
@property (assign) NSURL *homepageURL;
@property (assign) NSString *twitterUsername;
@property (assign) BOOL inDirectory;
@property (assign) NSArray *tags;

+ (TKUser*)userWithID:(int)user;
+ (TKUser*)userWithUsername:(NSString*)username;

+ (NSArray*)usersFromData:(NSDictionary*)data;

- (id)initWithDictionary:(NSDictionary*)dict;

@end