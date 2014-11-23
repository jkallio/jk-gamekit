//
//  JKGameNode.m
//  JKGameKit
//
//  Created by Jussi Kallio on 3.11.2014.
//  Copyright (c) 2014 Kallio. All rights reserved.
//

#import "JKDefines.h"
#import "JKUtils.h"
#import "JKGameScene.h"
#import "JKSpriteNode.h"
#import "JKWorldNode.h"
#import "JKGameNode.h"

static NSUInteger _ObjIDPool = 0;

@interface JKGameNode()
@property (nonatomic) NSHashTable* sensorsToAttach;
@property (nonatomic) NSHashTable* joints;
@end

@implementation JKGameNode
@synthesize controller = _controller;
@synthesize contactHandler = _contactHandler;

- (instancetype) init
{
    if (self = [super init])
    {
        _objID = ++_ObjIDPool;
        _objType = -1;
        
        _sensorsToAttach = [NSHashTable weakObjectsHashTable];
        _joints = [NSHashTable weakObjectsHashTable];
    }
    return self;
}

- (instancetype) initWithObjectID:(NSUInteger)oid
{
    if (self = [self init])
    {
        if (oid > _ObjIDPool)
        {
            _ObjIDPool = oid;
        }
        _objID = oid;
    }
    return self;
}

- (void) onEnter
{
    [super onEnter];
    
    for (JKGameNode* sensor in self.sensorsToAttach)
    {
        SKPhysicsJoint* joint = [SKPhysicsJointFixed
                                 jointWithBodyA:self.physicsBody bodyB:sensor.physicsBody
                                 anchor:CGPointMake(self.parent.position.x + self.position.x, self.parent.position.y + self.position.y)];
        [self.scene.physicsWorld addJoint:joint];
        [self.joints addObject:joint];
    }
    [self.sensorsToAttach removeAllObjects];
    
    NSAssert(self.name, @"GameNode must have name");
}

- (void) onExit
{
    for (SKPhysicsJoint* joint in self.joints)
    {
        [self.scene.physicsWorld removeJoint:joint];
    }
    [self.joints removeAllObjects];
}

- (void) setSpriteNode:(JKSpriteNode *)spriteNode
{
    spriteNode.name = @"SubnodeSprite";
    [self addChild:spriteNode];
    _spriteNode = spriteNode;
}

- (void) setSpriteTexture:(SKTexture*)texture
{
    if (!_spriteNode)
    {
        [self setSpriteNode:[JKSpriteNode spriteNodeWithTexture:texture]];
    }
    else
    {
        [_spriteNode setTexture:texture];
    }
}

- (JKPluginCtrlBase*) controller
{
    if (!_controller)
    {
        _controller = [self.userData objectForKey:PLUGIN_KEY_CONTROLLER];
    }
    return _controller;
}

- (JKPluginContactHandlerBase*) contactHandler
{
    if (!_contactHandler)
    {
        _contactHandler = [self.userData objectForKey:PLUGIN_KEY_CONTACT_HANDLER];
    }
    return _contactHandler;
}

- (void) setSensor:(JKGameNode*)sensor Name:(NSString*)name
{
    JKAssert(sensor.spriteNode, @"SpriteNode not set");
    
    sensor.name = name;
    sensor.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:sensor.spriteNode.size];
    sensor.physicsBody.categoryBitMask = kCatSensor;
    sensor.physicsBody.collisionBitMask =  kCollisionMaskSensor;
    sensor.physicsBody.contactTestBitMask = kContactMaskSensor;
    [self addChild:sensor];
    [self.sensorsToAttach addObject:sensor];
}

- (JKGameNode*) sensorNamed:(NSString*)name
{
    return [JKGameNode cast:[self childNodeWithName:name]];
}

#pragma mark --
#pragma mark Property Setters
- (void) setProperty:(NSString*)key String:(NSString*)value
{
    if (!self.userData)
    {
        self.userData = [NSMutableDictionary dictionary];
    }
    [self.userData setObject:value forKey:key];
}

- (void) setProperty:(NSString *)key Integer:(NSInteger)value
{
    if (!self.userData)
    {
        self.userData = [NSMutableDictionary dictionary];
    }
    [self.userData setObject:[NSNumber numberWithInteger:value] forKey:key];
}

- (void) setProperty:(NSString*)key Float:(CGFloat)value
{
    if (!self.userData)
    {
        self.userData = [NSMutableDictionary dictionary];
    }
    [self.userData setObject:[NSNumber numberWithFloat:value] forKey:key];
}

- (void) setProperty:(NSString *)key Bool:(BOOL)value
{
    if (!self.userData)
    {
        self.userData = [NSMutableDictionary dictionary];
    }
    [self.userData setObject:[NSNumber numberWithInteger:value ? 1 : 0] forKey:key];
}


#pragma mark --
#pragma mark Property Getters
- (NSString*) getStringProperty:(NSString*)key
{
    NSObject* prop = [self.userData objectForKey:key];
    if (prop)
    {
        NSAssert([prop isKindOfClass:[NSString class]], @"Invalid type %@", [prop class]);
    }
    return (NSString*)prop;
}

- (NSInteger) getIntProperty:(NSString*)key
{
    NSObject* prop = [self.userData objectForKey:key];
    if (prop)
    {
        NSAssert([prop isKindOfClass:[NSNumber class]], @"Invalid type %@", [prop class]);
    }
    return [(NSNumber*)prop integerValue];
}

- (CGFloat) getFloatProperty:(NSString*)key
{
    NSObject* prop = [self.userData objectForKey:key];
    if (prop)
    {
        NSAssert([prop isKindOfClass:[NSNumber class]], @"Invalid type %@", [prop class]);
    }
    return [(NSNumber*)prop floatValue];
}

- (BOOL) getBoolProperty:(NSString*)key
{
    NSObject* prop = [self.userData objectForKey:key];
    if (prop)
    {
        NSAssert([prop isKindOfClass:[NSNumber class]], @"Invalid type %@", [prop class]);
    }
    return ([(NSNumber*)prop integerValue] != 0);
}

@end
