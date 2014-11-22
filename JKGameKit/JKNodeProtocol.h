//
//  JKNodeProtocol.h
//  JKGameKit
//
//  Created by Jussi Kallio on 3.11.2014.
//  Copyright (c) 2014 Kallio. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@class JKGameScene;
@class JKWorldNode;
@class JKHudNode;

@protocol JKNodeProtocol <NSObject>

#pragma mark Required
@required

@property (nonatomic) BOOL hasEnteredScene;
@property (nonatomic) BOOL hasExitedScene;
@property (nonatomic, weak) JKGameScene* gameScene;
@property (nonatomic, weak) JKWorldNode* world;
@property (nonatomic, weak) JKHudNode* hud;

- (void) onEnter;
- (void) onExit;

+ (instancetype)cast:(id)from;

#pragma mark Optional
@optional

- (void) onUpdate:(NSTimeInterval) dt;
- (void) onGameBegin;
- (void) onGameOver;
- (void) onGamePause;
- (void) onGameResume;

@end
