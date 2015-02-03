//
//  JKDefines.h
//  JKGameKit
//
//  Created by Jussi Kallio on 4.11.2014.
//  Copyright (c) 2014 Kallio. All rights reserved.
//

#ifndef JKGameKit_JKDefines_h
#define JKGameKit_JKDefines_h

#define DEBUG_VERBOSE 0

#define VALUE_UNDEFINED     INT32_MAX
#define VALUE_UNDEFINED_F   INT32_MAX

#define JKLog(fmt, ...) NSLog((@"%s - #log: " fmt), __PRETTY_FUNCTION__, ##__VA_ARGS__)
#define JKWarning(fmt, ...) NSLog((@"%s - #warning: " fmt), __PRETTY_FUNCTION__, ##__VA_ARGS__)
#define JKError(fmt, ...) NSLog((@"%s - #error: " fmt), __PRETTY_FUNCTION__, ##__VA_ARGS__);
#define JKAssert(test, fmt, ...) if (!(test)) { JKError(fmt, ##__VA_ARGS__); NSAssert(test, @"#error"); }
#ifdef DEBUG
#   define JKDebugLog(fmt, ...) NSLog((@"%s - " fmt), __PRETTY_FUNCTION__, ##__VA_ARGS__)
#else
#   define JKDebugLog(...)
#endif

#if DEBUG_VERBOSE
#   define JKDebugLogVerbose(fmt, ...) NSLog((@"%s - " fmt), __PRETTY_FUNCTION__, ##__VA_ARGS__)
#else
#   define JKDebugLogVerbose(...)
#endif

#define PIXELS(x) x

#define LEVEL_FOLDER_NAME               @"levels"

#define NODE_NAME_HERO                  @"NodeHero"

#define PLUGIN_KEY_CONTROLLER           @"PluginCtrl"
#define PLUGIN_KEY_TOUCH_HANDLER        @"PluginTouchHandler"
#define PLUGIN_KEY_CONTACT_HANDLER      @"PluginContactHandler"
#define PLUGIN_KEY_PHYSICAL_PROPERTIES  @"PluginPhysProps"
#define PLUGIN_KEY_TOUCH_DISPATCHER     @"PluginTouchDispatcher"
#define PLUGIN_KEY_ANIMATION            @"PluginAnimation"

#define KEY_TOP_SENSOR @"TopSensor"
#define KEY_LEFT_SENSOR @"LeftSensor"
#define KEY_RIGHT_SENSOR @"RightSensor"
#define KEY_BOTTOM_SENSOR @"BottomSensor"

static const unsigned int kMaskAll          = (0xFFFFFFFF);
static const unsigned int kMaskNull         = (0x00000000);

static const unsigned int kCatHero          = (0x01 << 0);
static const unsigned int kCatStaticObj     = (0x01 << 1);
static const unsigned int kCatDynamicObj    = (0x01 << 2);
static const unsigned int kCatSensor        = (0x01 << 3);

static const unsigned int kCollisionMaskHero        = (kCatStaticObj | kCatDynamicObj);
static const unsigned int kCollisionMaskStaticObj   = (kCatHero | kCatDynamicObj);
static const unsigned int kCollisionMaskDynamicObj  = (kCatStaticObj | kCatDynamicObj | kCatHero);
static const unsigned int kCollisionMaskSensor      = (kMaskNull);

static const unsigned int kContactMaskHero          = (kMaskAll);
static const unsigned int kContactMaskStaticObj     = (kMaskNull);
static const unsigned int kContactMaskDynamicObj    = (kMaskNull);
static const unsigned int kContactMaskSensor        = (kMaskAll);

#endif
