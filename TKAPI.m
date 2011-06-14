//
//  TKAPI.m
//  TimberKit
//
//  Created by Alan Smith on 6/13/11.
//  Copyright 2011 CloakedCode. All rights reserved.
//

#import "TKAPI.h"
#import "JSONKit.h"


@implementation TKAPI

@synthesize error;

+ (TKAPI*)sharedAPI
{
	static TKAPI *api = nil;
	
	if (api == nil)
	{
		api = [[[self class] alloc] init];
	}
	
	return api;
}

- (id)init
{
	if ((self = [super init]) != nil)
	{
		// For proper API use, uncomment the line below and insert your username/email and password. (Remove the other "token = ..." line.)
		// token = [[[self getMethod: @"users/auth" withParameters: [NSDictionary dictionaryWithObjectsAndKeys: @"my_username", @"email_or_username", @"my_password", @"password", nil]] objectForKey: @"token"] retain];
		token = [@"" retain];
	}
	
	return self;
}

- (void)dealloc
{
	[token release];
	
	[super dealloc];
}

- (NSDictionary*)getMethod:(NSString*)method withParameters:(NSDictionary*)params
{
	NSMutableString *url = [NSMutableString stringWithFormat: @"http://forrst.com/api/v2/%@", method];
	
	BOOL first = YES;
	for (NSString *key in params)
	{
		if (first)
		{
			[url appendFormat: @"?%@=%@", key, [params objectForKey: key]];
			first = NO;
		}
		else
		{
			[url appendFormat: @"&%@=%@", key, [params objectForKey: key]];
		}
	}
	
	NSDictionary *resp = [[NSData dataWithContentsOfURL: [NSURL URLWithString: url]] objectFromJSONData];
	
	if ([resp objectForKey: @"error"])
	{
		self.error = [resp objectForKey: @"error"];
	}
	
	if ([resp objectForKey: @"resp"])
	{
		return [resp objectForKey: @"resp"];
	}
	
	return resp;
}

@end
