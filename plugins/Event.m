//
//  Event.m
//  Pocket Gnome
//
//  Created by Josh on 11/10/10.
//  Copyright 2010 Savory Software, LLC. All rights reserved.
//

#import "Event.h"


@implementation Event

- (id) init{
    self = [super init];
    if (self != nil) {
		_type = E_NONE;
		_selector = nil;
		_exclusive = NO;
    }
    return self;
}

- (id)initWithType: (PG_EVENT_TYPE)type andSelector:(NSString*)selector{
    self = [self init];
    if (self != nil) {
		_type = type;
		_selector = [[selector copy] retain];		
    }
    return self;
}

+ (id)eventWithType: (PG_EVENT_TYPE)type andSelector:(NSString*)selector{
	return [[[Event alloc] initWithType: type andSelector:selector] autorelease];
}

@synthesize type = _type;
@synthesize exclusive = _exclusive;

- (SEL)selector{
	return NSSelectorFromString(_selector);	
}

@end
