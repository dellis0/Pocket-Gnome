//
//  Event.m
//  Pocket Gnome
//
//  Created by Josh on 11/10/10.
//  Copyright 2010 Savory Software, LLC. All rights reserved.
//

#import "Event.h"


@implementation Event

- (id) init
{
    self = [super init];
    if (self != nil) {
		_type = E_NONE;
    }
    return self;
}

- (id)initWithType: (NSString*)path {
    self = [self init];
    if (self != nil) {

		
    }
    return self;
}

/*+ (id)pluginWithPath: (NSString*)path {
	return [[[Plugin alloc] initWithPath: path] autorelease];
}*/

@end
