//
//  JKPluginProtocol.h
//  JKGameKit
//
//  Created by Jussi Kallio on 3.11.2014.
//  Copyright (c) 2014 Kallio. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "JKNodeProtocol.h"
@class JKGameScene;
@class JKWorldNode;
@class JKHudNode;

@protocol JKPluginProtocol <NSObject>

#pragma mark Required
@required

@property (nonatomic) BOOL isEnabled;
@property (nonatomic, weak) SKNode<JKNodeProtocol>* node;
@property (nonatomic, weak) JKGameScene* gameScene;
@property (nonatomic, weak) JKWorldNode* world;
@property (nonatomic, weak) JKHudNode* hud;

- (instancetype) initWithNode:(SKNode<JKNodeProtocol>*) node;
+ (instancetype)cast:(id)from;

#pragma mark Optional
@optional

- (void) onUpdate:(NSTimeInterval) dt;
- (void) onNodeEnter;
- (void) onNodeExit;
- (void) onGameBegin;
- (void) onGameOver;
- (void) onGamePause;
- (void) onGameResume;

@end
