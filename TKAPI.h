//
//  TKAPI.h
//  TimberKit
//
//  Created by Alan Smith on 6/13/11.
//  Copyright 2011 CloakedCode. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface TKAPI : NSObject {
	NSString *token;
	NSString *error;
}

@property (assign) NSString *error;

+ (TKAPI*)sharedAPI;

- (NSDictionary*)getMethod:(NSString*)method withParameters:(NSDictionary*)params;

@end
