//
//  JKGameKit.h
//  JKGameKit
//
//  Created by Jussi Kallio on 4.11.2014.
//  Copyright (c) 2014 Kallio. All rights reserved.
//

#ifndef JKGameKit_JKGameKit_h
#define JKGameKit_JKGameKit_h

#pragma mark -- Common helpers
#import "JKUtils.h"
#import "JKDefines.h"
#import "JKTextureCache.h"

#pragma mark -- Categories
#import "SKTexture+PatternAddition.h"

#pragma mark -- Protocols
#import "JKNodeProtocol.h"
#import "JKPluginProtocol.h"
#import "JKTouchHandlerProtocol.h"

#pragma mark -- Scenes
#import "JKScene.h"
#import "JKGameScene.h"

#pragma mark -- Base Nodes
#import "JKNode.h"
#import "JKSpriteNode.h"

#pragma mark -- Game Nodes
#import "JKWorldNode.h"
#import "JKHudNode.h"
#import "JKCameraNode.h"
#import "JKShadowedLabelNode.h"
#import "JKGameNode.h"

#pragma mark -- Plugins
#import "JKPluginBase.h"
#import "JKPluginTouchHandlerBase.h"
#import "JKPluginAnimationBase.h"
#import "JKPluginCtrlBase.h"
#import "JKPluginTouchDispatcher.h"
#import "JKPluginContactHandlerBase.h"

#endif
