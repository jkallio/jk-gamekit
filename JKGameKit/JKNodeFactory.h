//
//  JKNodeFactory.h
//  JKGameKit
//
//  Created by Jussi Kallio on 2.2.2015.
//  Copyright (c) 2015 Kallio. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@class JKGameNode;
@class JKObjectXML;

@interface JKNodeFactory : NSObject

- (JKGameNode*) createGameNodeWithXMLObject:(JKObjectXML*)xmlObject;
@end
