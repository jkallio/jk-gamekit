//
//  XMLElementObject.m
//  BadPuppies
//
//  Created by Jussi Kallio on 15.11.2013.
//  Copyright (c) 2013 Jussi Kallio. All rights reserved.
//

#import "JKDefines.h"
#import "JKXMLHelper.h"
#import "JKObjectXML.h"

@implementation JKObjectXML

- (id) init
{
    if (self = [super init])
    {
        _objID = VALUE_UNDEFINED;
        _objType = VALUE_UNDEFINED;
        _position = CGPointZero;
        _zPosition = 0.0f;
        _rotation = 0.0f;
        _size = CGSizeMake(0.0f, 0.0f);
        _color = [SKColor clearColor];
    }
    return self;
}

- (void) setObjID:(NSInteger)objID
{
    _objID = objID;
    [self setProperty:[NSNumber numberWithInteger:objID] ForKey:XML_KEY_OBJ_ID];
}

- (void) setObjType:(NSInteger)objType
{
    _objType = objType;
    [self setProperty:[NSNumber numberWithInteger:objType] ForKey:XML_KEY_OBJ_TYPE];
}

- (void) setPosition:(CGPoint)position
{
    _position = position;
    [self setProperty:[NSValue valueWithCGPoint:position] ForKey:XML_KEY_POSITION];
}

- (void) setZPosition:(CGFloat)zPosition
{
    _zPosition = zPosition;
    [self setProperty:[NSNumber numberWithFloat:zPosition] ForKey:XML_KEY_ZPOS];
}

- (void) setRotation:(CGFloat)rotation
{
    _rotation = rotation;
    [self setProperty:[NSNumber numberWithFloat:rotation] ForKey:XML_KEY_ROTATION];
}

- (void) setSize:(CGSize)size
{
    _size = size;
    [self setProperty:[NSValue valueWithCGSize:size] ForKey:XML_KEY_SIZE];
}

- (void) setColor:(UIColor *)color
{
    _color = color;
    [self setProperty:color ForKey:XML_KEY_COLOR];
}

- (void) setIntProperty:(NSInteger)value ForKey:(NSString *)key
{
    [self setProperty:[NSNumber numberWithInteger:value] ForKey:key];
}

- (void) setFloatProperty:(NSInteger)value ForKey:(NSString *)key
{
    [self setProperty:[NSNumber numberWithFloat:value] ForKey:key];
}

- (void) setStringProperty:(NSString *)value ForKey:(NSString *)key
{
    [self setProperty:value ForKey:key];
}

- (void) setProperty:(id)obj ForKey:(NSString *)key
{
    if (!_propertyList)
    {
        _propertyList = [NSMutableDictionary new];
    }
    [_propertyList setObject:obj forKey:key];
}


@end
