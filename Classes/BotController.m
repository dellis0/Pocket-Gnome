/*
 * Copyright (c) 2007-2010 Savory Software, LLC, http://pg.savorydeviate.com/
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 * $Id$
 *
 */

#import "BotController.h"

#import "RouteCollection.h"
#import "RouteSet.h"
#import "Behavior.h"
#import "PvPBehavior.h"
#import "CombatProfile.h"
#import "PluginController.h"

#import "PTHeader.h"
#import <ShortcutRecorder/ShortcutRecorder.h>

#import "Event.h"


@interface BotController ()

@property (readwrite, assign) BOOL useRoute;
@property (readwrite, assign) BOOL useRoutePvP;

@end

@implementation BotController



/***
 
 STARTING OVER AHHH!
 
 What things should we care about here?  That we don't want lua to handle.
	Selected routes/behavior/profile (from UI)
 
 
 
 
 
 **/


- (id)init{
    self = [super init];
    if (self != nil) {
		_theRouteCollection = nil;
		_theRouteCollectionPvP = nil;
		_theRouteSet = nil;
		_theRouteSetPvP = nil;
		_theBehavior = nil;
		_theBehaviorPvP = nil;
		_theCombatProfile = nil;
		_pvpBehavior = nil;
		
		_isBotting = NO;
		
		[NSBundle loadNibNamed: @"Bot" owner: self];
    }
    return self;
}

- (void) dealloc{
    [super dealloc];
}

- (void)awakeFromNib {
	self.minSectionSize = [self.view frame].size;
	self.maxSectionSize = [self.view frame].size;
	
	// ShortcutRecorder
	[startstopRecorder setCanCaptureGlobalHotKeys: YES];
	KeyCombo combo2 = { NSCommandKeyMask, kSRKeysEscape };
    if ( [[NSUserDefaults standardUserDefaults] objectForKey: @"StartstopCode"] )
		combo2.code = [[[NSUserDefaults standardUserDefaults] objectForKey: @"StartstopCode"] intValue];
    if ( [[NSUserDefaults standardUserDefaults] objectForKey: @"StartstopFlags"] )
		combo2.flags = [[[NSUserDefaults standardUserDefaults] objectForKey: @"StartstopFlags"] intValue];
	[startstopRecorder setDelegate: self];
    [startstopRecorder setKeyCombo: combo2];
	
	// set up overlay window (what was this for?)
	/*[overlayWindow setLevel: NSFloatingWindowLevel];
    if([overlayWindow respondsToSelector: @selector(setCollectionBehavior:)])
		[overlayWindow setCollectionBehavior: NSWindowCollectionBehaviorMoveToActiveSpace];*/
	
}

@synthesize minSectionSize;
@synthesize maxSectionSize;
@synthesize view;

@synthesize theRouteCollection = _theRouteCollection;
@synthesize theRouteCollectionPvP = _theRouteCollectionPvP;
@synthesize theRouteSet = _theRouteSet;
@synthesize theRouteSetPvP = _theRouteSetPvP;
@synthesize theBehavior = _theBehavior;
@synthesize theBehaviorPvP = _theBehaviorPvP;
@synthesize pvpBehavior = _pvpBehavior;
@synthesize theCombatProfile = _theCombatProfile;

@synthesize isBotting =  _isBotting;

- (NSString *)sectionTitle{
	return @"Start/Stop Bot";
}

#pragma mark ShortcutRecorder Delegate

- (void)toggleGlobalHotKey:(SRRecorderControl*)sender
{
	if (startStopBotGlobalHotkey != nil) {
		[[PTHotKeyCenter sharedCenter] unregisterHotKey: startStopBotGlobalHotkey];
		[startStopBotGlobalHotkey release];
		startStopBotGlobalHotkey = nil;
	}
    
    KeyCombo keyCombo = [sender keyCombo];
    
    if((keyCombo.code >= 0) && (keyCombo.flags >= 0)) {
		startStopBotGlobalHotkey = [[PTHotKey alloc] initWithIdentifier: @"StartStopBot"
															   keyCombo: [PTKeyCombo keyComboWithKeyCode: keyCombo.code
																							   modifiers: [sender cocoaToCarbonFlags: keyCombo.flags]]];
		
		[startStopBotGlobalHotkey setTarget: startStopButton];
		[startStopBotGlobalHotkey setAction: @selector(performClick:)];
		
		[[PTHotKeyCenter sharedCenter] registerHotKey: startStopBotGlobalHotkey];
    }
}

- (void)shortcutRecorder:(SRRecorderControl *)recorder keyComboDidChange:(KeyCombo)newKeyCombo {
	
    if(recorder == startstopRecorder) {
		[[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithInt: newKeyCombo.code] forKey: @"StartstopCode"];
		[[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithInt: newKeyCombo.flags] forKey: @"StartstopFlags"];
		[self toggleGlobalHotKey: startstopRecorder];
    }
	
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark UI

- (IBAction)startBot: (id)sender{
	
	// get information from the UI so plugins don't have to!	
	_useRoute = [[[NSUserDefaults standardUserDefaults] objectForKey: @"UseRoute"] boolValue];
	_useRoutePvP = [[[NSUserDefaults standardUserDefaults] objectForKey: @"UseRoutePvP"] boolValue];
	
    if ( self.useRoute ) {
		self.theRouteCollection = [[routePopup selectedItem] representedObject];
		self.theRouteSet = [_theRouteCollection startingRoute];
    } else {
		self.theRouteSet = nil;
		self.theRouteCollection = nil;
    }
	
	self.theBehavior = [[behaviorPopup selectedItem] representedObject];
    self.theCombatProfile = [[combatProfilePopup selectedItem] representedObject];
	
	if ( self.useRoutePvP )
		self.pvpBehavior = [[routePvPPopup selectedItem] representedObject];
	else
		self.pvpBehavior = nil;
	
	// fire LUA event
	[pluginController performEvent:E_BOT_START withObject:nil];
}
- (IBAction)stopBot: (id)sender{
	
	
	// fire LUA event
	[pluginController performEvent:E_BOT_STOP withObject:nil];
}

- (IBAction)test: (id)sender{
	[pluginController performEvent:E_BOT_START withObject:nil];
}


@end