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

#import <Cocoa/Cocoa.h>

// Hotkey set flags
#define	HotKeyStartStop				0x1
#define HotKeyInteractMouseover		0x2
#define HotKeyPrimary				0x4
#define HotKeyPetAttack				0x8

@class SRRecorderControl;
@class PTHotKey;
@class RouteCollection;
@class RouteSet;
@class Behavior;
@class CombatProfile;
@class PvPBehavior;
@class Route;
@class ScanGridView;

@class PlayerDataController;
@class PlayersController;
@class InventoryController;
@class AuraController;
@class NodeController;
@class MovementController;
@class CombatController;
@class SpellController;
@class MobController;
@class ChatController;
@class ChatLogController;
@class ChatLogEntry;
@class Controller;
@class WaypointController;
@class ProcedureController;
@class LootController;
@class FishController;
@class MacroController;
@class OffsetController;
@class MemoryViewController;
@class StatisticsController;
@class BindingsController;
@class PvPController;
@class DatabaseManager;
@class ProfileController;
@class PluginController;

@interface BotController : NSObject {
	
	IBOutlet Controller             *controller;
    IBOutlet ChatController         *chatController;
	IBOutlet ChatLogController		*chatLogController;
    IBOutlet PlayerDataController   *playerController;
    IBOutlet MobController          *mobController;
    IBOutlet SpellController        *spellController;
    IBOutlet CombatController       *combatController;
    IBOutlet MovementController     *movementController;
    IBOutlet NodeController         *nodeController;
    IBOutlet AuraController         *auraController;
    IBOutlet InventoryController    *itemController;
    IBOutlet PlayersController      *playersController;
	IBOutlet LootController			*lootController;
	IBOutlet FishController			*fishController;
	IBOutlet MacroController		*macroController;
	IBOutlet OffsetController		*offsetController;
    IBOutlet WaypointController     *waypointController;
    IBOutlet ProcedureController    *procedureController;
	IBOutlet MemoryViewController	*memoryViewController;
	IBOutlet StatisticsController	*statisticsController;
	IBOutlet BindingsController		*bindingsController;
	IBOutlet PvPController			*pvpController;
	IBOutlet DatabaseManager		*databaseManager;
	IBOutlet ProfileController		*profileController;
	IBOutlet PluginController		*pluginController;
	
	IBOutlet Route					*Route;	// is this right?
	IBOutlet NSButton *startStopButton;
    
    IBOutlet id attackWithinText;
    IBOutlet id routePopup;
    IBOutlet id routePvPPopup;
    IBOutlet id behaviorPopup;
    IBOutlet id behaviorPvPPopup;
    IBOutlet id combatProfilePopup;
    IBOutlet id combatProfilePvPPopup;
    IBOutlet id minLevelPopup;
    IBOutlet id maxLevelPopup;
    IBOutlet NSTextField *minLevelText, *maxLevelText;
    IBOutlet NSButton *anyLevelCheckbox;
    
	// Log Out options
	IBOutlet NSButton		*logOutOnBrokenItemsCheckbox;
	IBOutlet NSButton		*logOutOnFullInventoryCheckbox;
	IBOutlet NSButton		*logOutOnTimerExpireCheckbox;
	IBOutlet NSButton		*logOutAfterStuckCheckbox;
	IBOutlet NSButton		*logOutUseHearthstoneCheckbox;
	IBOutlet NSTextField	*logOutDurabilityTextField;
	IBOutlet NSTextField	*logOutAfterRunningTextField;

	IBOutlet NSPanel *hotkeyHelpPanel;
    IBOutlet NSPanel *lootHotkeyHelpPanel;
	IBOutlet NSTextField *statusText;
	IBOutlet NSTextField *runningTimer;
    IBOutlet NSWindow *overlayWindow;
    IBOutlet ScanGridView *scanGrid;

	// view info
	IBOutlet NSView *view;
	NSSize minSectionSize, maxSectionSize;
	
	// ShortcutRecorder
	IBOutlet SRRecorderControl *startstopRecorder;
    PTHotKey *startStopBotGlobalHotkey;
	
	// UI bindings
	RouteCollection *_theRouteCollection;
	RouteCollection *_theRouteCollectionPvP;
    RouteSet *_theRouteSet;
    RouteSet *_theRouteSetPvP;
    Behavior *_theBehavior;
    Behavior *_theBehaviorPvP;
    CombatProfile *_theCombatProfile;
	PvPBehavior *_pvpBehavior;
	
	BOOL _isBotting;
	
	BOOL _useRoute;
	BOOL _useRoutePvP;
	
}

@property (readwrite, retain) RouteCollection *theRouteCollection;
@property (readwrite, retain) RouteCollection *theRouteCollectionPvP;
@property (readwrite, retain) RouteSet *theRouteSet;
@property (readwrite, retain) RouteSet *theRouteSetPvP;
@property (readwrite, retain) Behavior *theBehavior;
@property (readwrite, retain) Behavior *theBehaviorPvP;
@property (readwrite, retain) CombatProfile *theCombatProfile;
@property (readwrite, retain) PvPBehavior *pvpBehavior;

@property (readonly) NSView *view;
@property (readonly) NSString *sectionTitle;
@property NSSize minSectionSize;
@property NSSize maxSectionSize;

@property (readonly) BOOL isBotting;

- (IBAction)startBot: (id)sender;
- (IBAction)stopBot: (id)sender;

- (IBAction)editRoute: (id)sender;
- (IBAction)editRoutePvP: (id)sender;
- (IBAction)editBehavior: (id)sender;
- (IBAction)editBehaviorPvP: (id)sender;
- (IBAction)editProfile: (id)sender;
- (IBAction)editProfilePvP: (id)sender;

- (IBAction)updateStatus: (id)sender;
- (IBAction)hotkeyHelp: (id)sender;
- (IBAction)closeHotkeyHelp: (id)sender;
- (IBAction)lootHotkeyHelp: (id)sender;
- (IBAction)closeLootHotkeyHelp: (id)sender;


// test stuff
- (IBAction)test: (id)sender;

@end
