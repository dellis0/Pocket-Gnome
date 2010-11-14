//
//  Event.h
//  Pocket Gnome
//
//  Created by Josh on 11/10/10.
//  Copyright 2010 Savory Software, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum {
	E_NONE,

//Plugin Events	
	E_PLUGIN_LOADED,
	E_PLUGIN_CONFIG,

//Player state changes	
	E_PLAYER_DIED,
	E_PLAYER_FOUND,
	
//Bot control	
	E_BOT_START,
	E_BOT_STOP,
	
//Messages	
	E_MESSAGE_RECEIVED,
	E_WHISPER_RECEIVED,
	
//Aura Events	
	E_PLAYER_AURA_GAINED,
	E_PET_AURA_GAINED,
	E_TARGET_AURA_GAINED,
	E_PLAYER_AURA_FADED,
	
	E_MAX,
} PG_EVENT_TYPE;

@interface Event : NSObject {
	
	PG_EVENT_TYPE _type;
	NSString *_selector;
}

//+ (id)eventWithType: (PG_EVENT_TYPE)type andSelector:(NSString*)selector;

@end
