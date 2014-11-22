//
//  JKSpriteNode.h
//  JKGameKit
//
//  Created by Jussi Kallio on 3.11.2014.
//  Copyright (c) 2014 Kallio. All rights reserved.
//

#import "JKNodeProtocol.h"

@interface JKSpriteNode : SKSpriteNode <JKNodeProtocol>

@property (nonatomic) BOOL hasEnteredScene;
@property (nonatomic) BOOL hasExitedScene;
@property (nonatomic, weak) JKGameScene* gameScene;
@property (nonatomic, weak) JKWorldNode* world;
@property (nonatomic, weak) JKHudNode* hud;

- (void) onEnter;
- (void) onExit;

+ (instancetype)cast:(id)from;

@end
