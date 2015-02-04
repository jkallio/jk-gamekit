//
//  XMLHelper.h
//  BadPuppies
//
//  Created by Jussi Kallio on 15.11.2013.
//  Copyright (c) 2013 Jussi Kallio. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@class GDataXMLElement;
@class JKObjectXML;
@class JKGameNode;

// Level keys
#define XML_KEY_LEVEL               @"level"
#define XML_KEY_OBJECT_LIST         @"objectList"
#define XML_KEY_OBJECT              @"object"

// Object properties
#define XML_KEY_OBJ_ID              @"obj_id"
#define XML_KEY_OBJ_TYPE            @"obj_type"
#define XML_KEY_POSITION            @"position"
#define XML_KEY_ZPOS                @"z_position"
#define XML_KEY_ROTATION            @"rotation"
#define XML_KEY_SIZE                @"size"
#define XML_KEY_COLOR               @"color"

/// Attribute Keys
#define XML_ATTRB_VALUE_TYPE        @"value_type"
#define XML_ATTRB_FLOAT_PRECISION   @"precision"
#define XML_ATTRB_OBJ_ID            @"id"

// Value types for XML Element
#define VALUE_TYPE_STRING           @"string"
#define VALUE_TYPE_INTEGER          @"integer"
#define VALUE_TYPE_FLOAT            @"float"
#define VALUE_TYPE_POINT            @"point"
#define VALUE_TYPE_SIZE             @"size"
#define VALUE_TYPE_COLOR_RGBA       @"rgba"

@interface JKXMLHelper : NSObject

+ (GDataXMLElement*) createIntegerElement:(NSInteger)value Named:(NSString *)name;
+ (GDataXMLElement*) createFloatElement:(CGFloat)value Precision:(NSInteger)precision Named:(NSString *)name;
+ (GDataXMLElement*) createStringElement:(NSString*)value Named:(NSString*)name;
+ (GDataXMLElement*) createPointElement:(CGPoint)value Named:(NSString *)name;
+ (GDataXMLElement*) createSizeElement:(CGSize)value Named:(NSString *)name;
+ (GDataXMLElement*) createColorElement:(SKColor*)value Named:(NSString *)name;

+ (NSInteger)   getIntValueFromElement:(GDataXMLElement *)element;
+ (CGFloat)     getFloatValueFromElement:(GDataXMLElement *)element;
+ (NSString*)   getStringValueFromElement:(GDataXMLElement *)element;
+ (CGPoint)     getPointValueFromElement:(GDataXMLElement*)element;
+ (CGSize)      getSizeValueFromElement:(GDataXMLElement*)element;
+ (SKColor*)    getColorValueFromElement:(GDataXMLElement*)element;

+ (JKObjectXML*) parseObjectFromElement:(GDataXMLElement*)root;
+ (JKObjectXML*) xmlObjectFromGameNode:(JKGameNode*)gameNode;
+ (GDataXMLElement*) xmlElementFromGameNode:(JKGameNode*)gameNode;

@end
