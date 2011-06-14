//
//  TKPost.m
//  TimberKit
//
//  Created by Alan Smith on 6/13/11.
//  Copyright 2011 CloakedCode. All rights reserved.
//

#import "TKPost.h"
#import "TKUser.h"
#import "TKAPI.h"

@interface TKPost (Private)

+ (NSString*)_stringFromType:(TKPostType)type;

@end


@implementation TKPost

@synthesize ID;
@synthesize tinyID;
@synthesize user;
@synthesize type;
@synthesize permaURL;
@synthesize createdAt;
@synthesize updatedAt;
@synthesize isPublished;
@synthesize isPublic;

@synthesize title;
@synthesize url;
@synthesize content;
@synthesize description;
@synthesize formattedDescription;

@synthesize likeCount;
@synthesize commentCount;

@synthesize snaps;

@synthesize tags;

+ (NSArray*)allPosts
{
	return [self postsFromData: [[TKAPI sharedAPI] getMethod: @"posts/all" withParameters: nil]];
}

+ (NSArray*)allPostsAfterPostID:(int)post
{
	NSDictionary *params = [NSDictionary dictionaryWithObject: [NSNumber numberWithInt: post] forKey: @"after"];
	return [self postsFromData: [[TKAPI sharedAPI] getMethod: @"posts/all" withParameters: params]];
}

+ (NSArray*)postsOfUser:(int)user
{
	return [self postsOfUser: user limitTo: 10];
}

+ (NSArray*)postsOfUser:(int)user limitTo:(int)limit
{
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithInt: user], @"id", [NSNumber numberWithInt: limit], @"limit", nil];
	return [self postsFromData: [[TKAPI sharedAPI] getMethod: @"user/posts" withParameters: params]];
}

+ (NSArray*)postsOfUser:(int)user limitTo:(int)limit afterPostID:(int)post
{
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithInt: user], @"id", [NSNumber numberWithInt: limit], @"limit", [NSNumber numberWithInt: post], @"after", nil];
	return [self postsFromData: [[TKAPI sharedAPI] getMethod: @"user/posts" withParameters: params]];
}

+ (NSArray*)postsOfUser:(int)user limitTo:(int)limit ofType:(TKPostType)type
{
	NSString *t = [self _stringFromType: type];
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithInt: user], @"id", [NSNumber numberWithInt: limit], @"limit", t, @"type", nil];
	return [self postsFromData: [[TKAPI sharedAPI] getMethod: @"user/posts" withParameters: params]];
}

+ (NSArray*)postsOfUser:(int)user limitTo:(int)limit afterPostID:(int)post ofType:(TKPostType)type
{
	NSString *t = [self _stringFromType: type];
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithInt: user], @"id", [NSNumber numberWithInt: limit], @"limit", t, @"type", [NSNumber numberWithInt: post], @"after", nil];
	return [self postsFromData: [[TKAPI sharedAPI] getMethod: @"user/posts" withParameters: params]];
}

+ (NSArray*)postsOfType:(TKPostType)type sortBy:(TKPostSortOrder)order page:(int)num
{
	NSString *s;
	
	switch (order)
	{
		case TKPostSortOrderRecent:
			s = @"recent";
			break;
		case TKPostSortOrderPopular:
			s = @"popular";
			break;
		case TKPostSortOrderBest:
			s = @"best";
			break;
		default:
			s = @"recent";
	}
	
	NSString *t = [self _stringFromType: type];
	
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: t, @"post_type", s, @"sort", [NSNumber numberWithInt: num], @"page", nil];
	return [self postsFromData: [[TKAPI sharedAPI] getMethod: @"posts/list" withParameters: params]];
}

+ (TKPost*)postWithID:(int)post
{
	NSDictionary *params = [NSDictionary dictionaryWithObject: [NSNumber numberWithInt: post] forKey: @"id"];
	NSDictionary *resp = [[TKAPI sharedAPI] getMethod: @"posts/show" withParameters: params];
	
	return [[[self alloc] initWithDictionary: resp] autorelease];
}

+ (TKPost*)postWithTinyID:(NSString*)post
{
	NSDictionary *params = [NSDictionary dictionaryWithObject: post forKey: @"tiny_id"];
	NSDictionary *resp = [[TKAPI sharedAPI] getMethod: @"posts/show" withParameters: params];
	
	return [[[self alloc] initWithDictionary: resp] autorelease];
}

+ (NSArray*)postsFromData:(NSDictionary*)data
{
	NSMutableArray *posts = [NSMutableArray array];
	
	for (NSDictionary *p in [data objectForKey: @"posts"])
	{
		TKPost *post = [[self alloc] initWithDictionary: p];
		
		[posts addObject: post];
		[post release];
	}
	
	return posts;
}

- (id)initWithDictionary:(NSDictionary*)dict
{
	if ([dict count] > 0 && (self = [super init]) != nil)
	{
		self.ID = [[dict objectForKey: @"id"] intValue];
		self.tinyID = [dict objectForKey: @"tiny_id"];
		self.permaURL = ([dict objectForKey: @"url"]) ? [NSURL URLWithString: [dict objectForKey: @"post_url"]] : nil;
		
		NSString *t = [dict objectForKey: @"post_type"];
		
		if ([t isEqualToString: @"code"])
		{
			self.type = TKPostTypeCode;
		}
		else if ([t isEqualToString: @"snap"])
		{
			self.type = TKPostTypeSnap;
		}
		else if ([t isEqualToString: @"link"])
		{
			self.type = TKPostTypeLink;
		}
		else if ([t isEqualToString: @"question"])
		{
			self.type = TKPostTypeQuestion;
		}
		
		NSDateFormatter *dateForm = [[NSDateFormatter alloc] init];
		[dateForm setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
		self.createdAt = [dateForm dateFromString: [dict objectForKey: @"created_at"]];
		self.updatedAt = [dateForm dateFromString: [dict objectForKey: @"updated_at"]];
		[dateForm release];
		
		self.user = [[[TKUser alloc] initWithDictionary: [dict objectForKey: @"user"]] autorelease];
		
		self.isPublished = (BOOL)[[dict objectForKey: @"published"] intValue];
		self.isPublic = (BOOL)[[dict objectForKey: @"public"] intValue];
		
		self.title = [dict objectForKey: @"title"];
		self.url = ([dict objectForKey: @"url"]) ? [NSURL URLWithString: [dict objectForKey: @"url"]] : nil;
		self.content = [dict objectForKey: @"content"];
		self.description = [dict objectForKey: @"description"];
		self.formattedDescription = [dict objectForKey: @"formatted_description"];
		
		self.likeCount = (int)[[dict objectForKey: @"like_count"] intValue];
		self.commentCount = (int)[[dict objectForKey: @"comment_count"] intValue];
		
		if ([dict objectForKey: @"snaps"])
		{
			NSMutableDictionary *urls = [NSMutableDictionary dictionary];
			NSDictionary *ss = [dict objectForKey: @"snaps"];
			
			for (NSString *key in ss)
			{
				[urls setObject: [NSURL URLWithString: [ss objectForKey: key]] forKey: key];
			}
			
			self.snaps = urls;
		}
		
		if ([dict objectForKey: @"tags"])
		{
			self.tags = [dict objectForKey: @"tags"];
		}
		else if ([dict objectForKey: @"tag_string"])
		{
			self.tags = [[dict objectForKey: @"tag_string"] componentsSeparatedByString: @","];
		}
	}
	
	return self;
}

- (NSString*)description
{
	return [NSString stringWithFormat: @"ID: %i\nTiny ID: %@\nType: %i\nPerma URL: %@\nCreated at: %@\nUpdated at: %@\nIs published: %i\nIs public: %i\nTitle: %@\nURL: %@\nContent: %@\nDescription: %@\nFormatted description: %@\nLike count: %i\nComment count: %i\nSnaps: %@\nTags: %@\n", ID, tinyID, type, permaURL, createdAt, updatedAt, isPublished, isPublic, title, url, content, description, formattedDescription, likeCount, commentCount, snaps, tags, nil];
}

@end

@implementation TKPost (Private)

+ (NSString*)_stringFromType:(TKPostType)type
{
	NSString *t;
	
	switch (type)
	{
		case TKPostTypeCode:
			t = @"code";
			break;
		case TKPostTypeSnap:
			t = @"snap";
			break;
		case TKPostTypeLink:
			t = @"link";
			break;
		case TKPostTypeQuestion:
			t = @"question";
			break;
		default:
			[NSException raise: @"Invalid post type" format: @"Post type %d is invalid", type];
	}
	
	return t;
}

@end

