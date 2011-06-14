//
//  TKPost.h
//  TimberKit
//
//  Created by Alan Smith on 6/13/11.
//  Copyright 2011 CloakedCode. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum _TKPostType {
	TKPostTypeCode,
	TKPostTypeSnap,
	TKPostTypeLink,
	TKPostTypeQuestion,
} TKPostType;

typedef enum _TKPostSortOrder {
	TKPostSortOrderRecent,
	TKPostSortOrderPopular,
	TKPostSortOrderBest,
} TKPostSortOrder;

@class TKUser;

@interface TKPost : NSObject {
	int ID;
	NSString *tinyID;
	TKUser *user;
	TKPostType type;
	NSURL *permaURL;
	NSDate *createdAt;
	NSDate *updatedAt;
	BOOL isPublished;
	BOOL isPublic;
	
	NSString *title;
	NSURL *url;
	NSString *content;
	NSString *description;
	NSString *formattedDescription;
	
	int likeCount;
	int commentCount;
	
	NSDictionary *snaps;
	
	NSArray *tags;
}

@property (assign) int ID;
@property (assign) NSString *tinyID;
@property (assign) TKUser *user;
@property (assign) TKPostType type;
@property (assign) NSURL *permaURL;
@property (assign) NSDate *createdAt;
@property (assign) NSDate *updatedAt;
@property (assign) BOOL isPublished;
@property (assign) BOOL isPublic;

@property (assign) NSString *title;
@property (assign) NSURL *url;
@property (assign) NSString *content;
@property (assign) NSString *description;
@property (assign) NSString *formattedDescription;

@property (assign) int likeCount;
@property (assign) int commentCount;

@property (assign) NSDictionary *snaps;

@property (assign) NSArray *tags;

+ (NSArray*)allPosts;
+ (NSArray*)allPostsAfterPostID:(int)post;

+ (NSArray*)postsOfUser:(int)user;
+ (NSArray*)postsOfUser:(int)user limitTo:(int)limit;
+ (NSArray*)postsOfUser:(int)user limitTo:(int)limit afterPostID:(int)post;
+ (NSArray*)postsOfUser:(int)user limitTo:(int)limit ofType:(TKPostType)type;
+ (NSArray*)postsOfUser:(int)user limitTo:(int)limit afterPostID:(int)post ofType:(TKPostType)type;

+ (NSArray*)postsOfType:(TKPostType)type sortBy:(TKPostSortOrder)order page:(int)num;

+ (TKPost*)postWithID:(int)post;
+ (TKPost*)postWithTinyID:(NSString*)post;

+ (NSArray*)postsFromData:(NSDictionary*)data;

- (id)initWithDictionary:(NSDictionary*)dict;

@end
