//
//  JKContactHandlerProtocol.h
//  JKGameKit
//
//  Created by Jussi Kallio on 15.11.2014.
//  Copyright (c) 2014 Kallio. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@class JKGameNode;

@protocol JKContactHandlerProtocol <NSObject>
@required
- (void) contactBeganWith:(JKGameNode*)nodeB;
- (void) contactEndedWith:(JKGameNode*)nodeB;
@end