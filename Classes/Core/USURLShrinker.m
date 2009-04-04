//
//  USURLShrinker.m
//  URL Shrink
//
//  Created by Steve on 3/30/09.
//  Copyright 2009 Steve Streza. All rights reserved.
//

#import "USURLShrinker.h"

#import "TCDownload.h"
#import "USShrinkController.h"

@implementation USURLShrinker

+(void)load {
	[self registerShrinker];
}

+(void)registerShrinker{
	NSLog(@"Attempting to register %@",[self name]);
	[[USShrinkController sharedShrinkController] registerShrinkClass:self];	
}

+(BOOL)requiresAPIKey{
	return NO;
}

+(id)APIKey{
	return nil;
}

+(NSString *)name{
	return nil;
}

-(NSString *)name{
	return [[self class] name];
}

+(BOOL)canExpandURL:(NSURL *)url{
	return NO;
}

-(void)expandURL:(NSURL *)url
		  target:(id)target
		  action:(SEL)action{
	_target = target;
	_action = action;
	
	[NSThread detachNewThreadSelector:@selector(_startExpand:) toTarget:self withObject:url];
}
	
-(void)shrinkURL:(NSURL *)url
		  target:(id)target
		  action:(SEL)action{
	_target = target;
	_action = action;
	
	[NSThread detachNewThreadSelector:@selector(_startShrink:) toTarget:self withObject:url];
}

-(void)_startShrink:(NSURL *)url{
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	
	[self performShrinkOnURL:url];
	
	[pool release];
}

-(void)_startExpand:(NSURL *)url{
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	
	[self performExpandOnURL:url];
	
	[pool release];
}

-(void)performShrinkOnURL:(NSURL *)url{
	[self doneShrinking:nil];
}

-(void)performExpandOnURL:(NSURL *)url{
	[self doneExpanding:nil];
}

-(void)doneExpanding:(NSURL *)url{
	[_target performSelectorOnMainThread:_action withObject:url waitUntilDone:NO];
}

-(void)doneShrinking:(NSURL *)url{
	[_target performSelectorOnMainThread:_action withObject:url waitUntilDone:NO];
}

@end
