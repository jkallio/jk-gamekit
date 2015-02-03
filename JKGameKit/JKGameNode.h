//
//  JKGameNode.h
//  JKGameKit
//
//  Created by Jussi Kallio on 3.11.2014.
//  Copyright (c) 2014 Kallio. All rights reserved.
//

#import "JKNode.h"
@class JKSpriteNode;
@class JKPluginCtrlBase;
@class JKPluginContactHandlerBase;

@interface JKGameNode : JKNode

@property (nonatomic) NSInteger objID;
@property (nonatomic) NSInteger objType;
@property (nonatomic) BOOL saveToXML;

@property (nonatomic, weak) JKSpriteNode* spriteNode;
@property (nonatomic, weak, readonly) JKPluginCtrlBase* controller;
@property (nonatomic, weak, readonly) JKPluginContactHandlerBase* contactHandler;

- (instancetype) initWithObjectID:(NSUInteger)oid;
- (void) setSpriteTexture:(SKTexture*)texture;

#pragma -- Sensors
- (void) setSensor:(JKGameNode*)sensor Name:(NSString*)name;
- (JKGameNode*) sensorNamed:(NSString*)name;

#pragma mark -- Custom Properties
- (void) setProperty:(NSString*)key String:(NSString*)value;
- (void) setProperty:(NSString*)key Integer:(NSInteger)value;
- (void) setProperty:(NSString*)key Float:(CGFloat)value;
- (void) setProperty:(NSString*)key Bool:(BOOL)value;
- (void) setProperty:(NSString*)key Object:(id)ref;

- (NSString*) getStringProperty:(NSString*)key;
- (NSInteger) getIntProperty:(NSString*)key;
- (CGFloat) getFloatProperty:(NSString*)key;
- (BOOL) getBoolProperty:(NSString*)key;
- (id) getObjectProperty:(NSString*)key;

@end
