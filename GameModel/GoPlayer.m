//
//  GoPlayer.m
//  uGo
//
//  Created by Jacob Farkas on 7/25/08.
//  Copyright 2008 Apple Computer. All rights reserved.
//

#import "GoPlayer.h"

#import "GoReferee.h"

@implementation GoPlayer

@synthesize referee = _referee;
+ (GoPlayer*) player;
{
	return [[[self alloc] init] autorelease];
}

- (NSString *) name { return @"Default Player"; }

- (void) turnWillBegin { }

- (void) turnDidEnd { }
@end
