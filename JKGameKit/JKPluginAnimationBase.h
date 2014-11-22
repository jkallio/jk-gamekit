//
//  JKPluginAnimationBase.h
//  JKGameKit
//
//  Created by Jussi Kallio on 4.11.2014.
//  Copyright (c) 2014 Kallio. All rights reserved.
//

#import "JKPluginBase.h"

@interface JKPluginAnimationBase : JKPluginBase

@property (nonatomic) NSMutableDictionary* actions;
@property (nonatomic) NSNumber* activeAnimID;
@property (nonatomic) NSNumber* idleAnimID;

- (void) changeAnimation:(NSNumber*)animID;
- (void) runAnimation:(SKAction*)action;
- (void) stopAnimation;

+ (SKAction*) createAnimationWithFrames:(NSArray*)frames Freq:(float)freq Revert:(BOOL)revert;

@end
