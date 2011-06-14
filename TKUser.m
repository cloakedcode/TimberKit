//
//  TKUser.m
//  TimberKit
//
//  Created by Alan Smith on 6/13/11.
//  Copyright 2011 CloakedCode. All rights reserved.
//

#import "TKUser.h"
#import "TKAPI.h"


@implementation TKUser

@synthesize ID;
@synthesize username;
@synthesize name;
@synthesize url;
@synthesize postCount;
@synthesize commentCount;
@synthesize likeCount;
@synthesize followerCount;
@synthesize followingCount;
@synthesize photos;
@synthesize bio;
@synthesize isA;
@synthesize homepageURL;
@synthesize twitterUsername;
@synthesize inDirectory;
@synthesize tags;

+ (TKUser*)userWithID:(int)user
{
	NSDictionary *params = [NSDictionary dictionaryWithObject: [NSNumber numberWithInt: user] forKey: @"id"];
	NSDictionary *resp = [[TKAPI sharedAPI] getMethod: @"users/info" withParameters: params];
	
	return [[[[self class] alloc] initWithDictionary: resp] autorelease];	
}

+ (TKUser*)userWithUsername:(NSString*)username
{
	NSDictionary *params = [NSDictionary dictionaryWithObject: username forKey: @"username"];
	NSDictionary *resp = [[TKAPI sharedAPI] getMethod: @"users/info" withParameters: params];
	
	return [[[[self class] alloc] initWithDictionary: resp] autorelease];	
}

+ (NSArray*)usersFromData:(NSDictionary*)data
{
	NSMutableArray *users = [NSMutableArray array];
	
	for (NSDictionary *u in [data objectForKey: @"users"])
	{
		TKUser *user = [[TKUser alloc] initWithDictionary: u];
		
		[users addObject: user];
		[user release];
	}
	
	return users;
}

- (id)initWithDictionary:(NSDictionary*)dict
{
	if ([dict count] > 0 && (self = [super init]) != nil)
	{
		self.ID = [[dict objectForKey: @"id"] intValue];
		self.username = [dict objectForKey: @"username"];
		self.name = [dict objectForKey: @"name"];
		self.url = ([dict objectForKey: @"url"]) ? [NSURL URLWithString: [dict objectForKey: @"url"]] : nil;

		self.postCount = (int)[[dict objectForKey: @"posts"] intValue];
		self.commentCount = (int)[[dict objectForKey: @"comment_count"] intValue];
		self.likeCount = (int)[[dict objectForKey: @"like_count"] intValue];
		self.followerCount = (int)[[dict objectForKey: @"followers"] intValue];
		self.followingCount = (int)[[dict objectForKey: @"following"] intValue];		
		
		if ([dict objectForKey: @"photos"])
		{
			NSMutableDictionary *urls = [NSMutableDictionary dictionary];
			NSDictionary *ps = [dict objectForKey: @"photos"];
			
			for (NSString *key in ps)
			{
				[urls setObject: [NSURL URLWithString: [ps objectForKey: key]] forKey: key];
			}
			
			self.photos = urls;
		}
		
		self.bio = [dict objectForKey: @"bio"];
		self.isA = [dict objectForKey: @"is_a"];
		self.homepageURL = [NSURL URLWithString: [dict objectForKey: @"homepage_url"]];
		self.twitterUsername = [dict objectForKey: @"twitter"];
		self.inDirectory = (BOOL)[[dict objectForKey: @"in_directory"] intValue];
		
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
	return [NSString stringWithFormat: @"ID: %i\nUsername: %@\nName: %@\nURL: %@\nPost count: %i\nComment count: %i\nLike count: %i\nFollower count: %i\nFollowing count: %i\nPhotos: %@\nBio: %@\nIs a: %@\nHomepage URL: %@\nTwitter username: %@\nIn Directory: %i\nTags: %@\n", ID, username, name, url, postCount, commentCount, likeCount, followerCount, followingCount, photos, bio, isA, homepageURL, twitterUsername, inDirectory, tags, nil];
}

@end