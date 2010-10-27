//
//  ObjLua.m
//  Lua
//
//  Created by ProbablyInteractive on 5/27/09.
//  Copyright 2009 Probably Interactive. All rights reserved.
//

#import "wax.h"
#import "wax_class.h"
#import "wax_instance.h"
#import "wax_struct.h"
#import "wax_helpers.h"
#import "wax_gc.h"
#import "wax_server.h"

#import "lauxlib.h"
#import "lobject.h"
#import "lualib.h"

#import "linenoise.h" // For the REPL

static void addGlobals(lua_State *L);
static int waxRoot(lua_State *L);
static int waxPrint(lua_State *L);
static int tolua(lua_State *L);
static int toobjc(lua_State *L);
static int exitApp(lua_State *L);
static int objcDebug(lua_State *L);

lua_State *wax_currentLuaState() {
    static lua_State *L;    
    if (!L) L = lua_open();
    
    return L;
}

void uncaughtExceptionHandler(NSException *e) {
    printf("ERROR: Uncaught exception %s\n", [[e description] UTF8String]);
}

void wax_setup() {
	NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler); 
	
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager changeCurrentDirectoryPath:[[NSBundle mainBundle] bundlePath]];
    
    lua_State *L = wax_currentLuaState();
    
    luaL_openlibs(L); 
    luaopen_wax(L);
    addGlobals(L);
	
	[wax_gc start];
}

void wax_startWithExtensions(lua_CFunction func, ...) {  
	
	wax_setup();
	
	lua_State *L = wax_currentLuaState();

	if (func) { // Load extentions
        func(L);
		
        va_list ap;
        va_start(ap, func);
        while((func = va_arg(ap, lua_CFunction))) func(L);
		
        va_end(ap);
    }
	
	// load all of our scripts!
	/*if (luaL_dofile(L, "/Volumes/HD/Users/Josh/Library/Application Support/PocketGnome/plugins/init.lua") != 0) {
		fprintf(stderr,"Fatal error opening wax scripts: %s\n", lua_tostring(L,-1));
		NSLog(@"error?");
	}*/
}

void wax_start() {
    wax_startWithExtensions(nil);
}

void wax_startWithServer() {		
	wax_setup();
	[wax_server class]; // You need to load the class somehow via the wax.framework
	lua_State *L = wax_currentLuaState();
	
	// Load all the wax lua scripts
    if (luaL_dofile(L, "/scripts/wax/init.lua") != 0) {
        fprintf(stderr,"Fatal error opening wax scripts: %s\n", lua_tostring(L,-1));
    }
	
	Class WaxServer = objc_getClass("WaxServer");
	if (!WaxServer) [NSException raise:@"Wax Server Error" format:@"Could load Wax Server"];
	
	[WaxServer start];
}

void wax_end() {
    lua_close(wax_currentLuaState());
}

void luaopen_wax(lua_State *L) {
    luaopen_wax_class(L);
    luaopen_wax_instance(L);
    luaopen_wax_struct(L);
}

static void addGlobals(lua_State *L) {
	
    lua_getglobal(L, "wax");
    if (lua_isnil(L, -1)) {
        lua_pop(L, 1); // Get rid of the nil
        lua_newtable(L);
        lua_pushvalue(L, -1);
        lua_setglobal(L, "wax");
    }
    
    lua_pushnumber(L, WAX_VERSION);
    lua_setfield(L, -2, "version");
    
    lua_pushstring(L, [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"] UTF8String]);
    lua_setfield(L, -2, "appVersion");
    

    lua_pushcfunction(L, waxRoot);
    lua_setfield(L, -2, "root");

	lua_register(L, "print", waxPrint);
	
    lua_pushcfunction(L, objcDebug);
    lua_setfield(L, -2, "debug");    
    
    lua_pop(L, 1); // pop the wax global off
    

    lua_pushcfunction(L, tolua);
    lua_setglobal(L, "tolua");
    
    lua_pushcfunction(L, toobjc);
    lua_setglobal(L, "toobjc");
    
    lua_pushcfunction(L, exitApp);
    lua_setglobal(L, "exitApp");
    
    lua_pushstring(L, [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] UTF8String]);
    lua_setglobal(L, "NSDocumentDirectory");
    
    lua_pushstring(L, [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0] UTF8String]);
    lua_setglobal(L, "NSLibraryDirectory");
    
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    lua_pushstring(L, [cachePath UTF8String]);
    lua_setglobal(L, "NSCacheDirectory");

    NSError *error = nil;
    [[NSFileManager defaultManager] createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes: nil error:&error];
    if (error) {
        wax_log(LOG_DEBUG, @"Error creating cache path. %@", [error localizedDescription]);
    }
}

static int waxPrint(lua_State *L) {
    NSLog(@"%s", luaL_checkstring(L, 1));
    return 0;
}

static int waxRoot(lua_State *L) {
    luaL_Buffer b;
    luaL_buffinit(L, &b);
    luaL_addstring(&b, WAX_DATA_DIR);
    
	int i;
    for (i = 1; i <= lua_gettop(L); i++) {
        luaL_addstring(&b, "/");
        luaL_addstring(&b, luaL_checkstring(L, i));
    }

    luaL_pushresult(&b);
                       
    return 1;
}

static int tolua(lua_State *L) {
    if (lua_isuserdata(L, 1)) { // If it's not userdata... it's already lua!
        wax_instance_userdata *instanceUserdata = (wax_instance_userdata *)luaL_checkudata(L, 1, WAX_INSTANCE_METATABLE_NAME);
        wax_fromInstance(L, instanceUserdata->instance);
    }
    
    return 1;
}

static int toobjc(lua_State *L) {
    id *instancePointer = wax_copyToObjc(L, "@", 1, nil);
    id instance = *(id *)instancePointer;
    
    wax_instance_create(L, instance, NO);
    
    if (instancePointer) free(instancePointer);
    
    return 1;
}

static int exitApp(lua_State *L) {
    exit(0);
    return 0;
}

static int objcDebug(lua_State *L) {
    NSLog(@"DEBUGGEG!");
    return 0;
}