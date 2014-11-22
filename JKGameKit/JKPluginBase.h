//
//  JKPluginBase.h
//  JKGameKit
//
//  Created by Jussi Kallio on 3.11.2014.
//  Copyright (c) 2014 Kallio. All rights reserved.
//

#import "JKPluginProtocol.h"
@class JKGameNode;
@class JKSpriteNode;

@interface JKPluginBase : NSObject <JKPluginProtocol>

@property (nonatomic) BOOL isEnabled;
@property (nonatomic, weak, readwrite) SKNode<JKNodeProtocol>* node;
@property (nonatomic, weak, readonly) JKGameNode* gameNode;
@property (nonatomic, weak, readonly) JKSpriteNode* spriteNode;
@property (nonatomic, weak) JKGameScene* gameScene;
@property (nonatomic, weak) JKWorldNode* world;
@property (nonatomic, weak) JKHudNode* hud;

- (instancetype) initWithNode:(SKNode<JKNodeProtocol>*) node;

+ (instancetype) createAndAttachToNode:(SKNode *)node;
+ (instancetype) createAndAttachToNode:(SKNode*)node Key:(NSString*)key;
+ (instancetype)cast:(id)from;

@end
