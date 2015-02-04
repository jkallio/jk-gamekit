//
//  XMLHelper.m
//  BadPuppies
//
//  Created by Jussi Kallio on 15.11.2013.
//  Copyright (c) 2013 Jussi Kallio. All rights reserved.
//
#import "JKDefines.h"
#import "JKUtils.h"
#import "GDataXMLNode.h"
#import "JKObjectXML.h"
#import "JKWorldNode.h"
#import "JKGameNode.h"
#import "JKSpriteNode.h"
#import "JKXMLHelper.h"
#import "GDataXMLElement+elementForName.h"

@implementation JKXMLHelper

+ (GDataXMLElement*) createIntegerElement:(NSInteger)value Named:(NSString *)name
{
    GDataXMLElement* element = [GDataXMLElement elementWithName:name stringValue:NSStringFromInteger(value)];
    [element addAttribute:[GDataXMLElement elementWithName:XML_ATTRB_VALUE_TYPE stringValue:VALUE_TYPE_INTEGER]];
    return element;
}

+ (GDataXMLElement*) createFloatElement:(CGFloat)value Precision:(NSInteger)precision Named:(NSString *)name
{
    GDataXMLElement* element = [GDataXMLElement elementWithName:name stringValue:NSStringFromFloat(value, precision)];
    [element addAttribute:[GDataXMLElement elementWithName:XML_ATTRB_VALUE_TYPE stringValue:VALUE_TYPE_FLOAT]];
    [element addAttribute:[GDataXMLElement elementWithName:XML_ATTRB_FLOAT_PRECISION stringValue:NSStringFromInteger(precision)]];
    return element;
}

+ (GDataXMLElement*) createStringElement:(NSString*)value Named:(NSString*)name
{
    GDataXMLElement* element = [GDataXMLElement elementWithName:name stringValue:value];
    [element addAttribute:[GDataXMLElement elementWithName:XML_ATTRB_VALUE_TYPE stringValue:VALUE_TYPE_STRING]];
    return element;
}

+ (GDataXMLElement*) createPointElement:(CGPoint)value Named:(NSString *)name
{
    GDataXMLElement* element = [GDataXMLNode elementWithName:name];
    [element addAttribute:[GDataXMLElement elementWithName:XML_ATTRB_VALUE_TYPE stringValue:VALUE_TYPE_POINT]];
    [element addChild:[JKXMLHelper createFloatElement:value.x Precision:5 Named:@"x"]];
    [element addChild:[JKXMLHelper createFloatElement:value.y Precision:5 Named:@"y"]];
    return element;
}

+ (GDataXMLElement*) createSizeElement:(CGSize)value Named:(NSString *)name
{
    GDataXMLElement* element = [GDataXMLNode elementWithName:name];
    [element addAttribute:[GDataXMLElement elementWithName:XML_ATTRB_VALUE_TYPE stringValue:VALUE_TYPE_SIZE]];
    [element addChild:[JKXMLHelper createFloatElement:value.width Precision:5 Named:@"width"]];
    [element addChild:[JKXMLHelper createFloatElement:value.height Precision:5 Named:@"height"]];
    return element;
}

+ (GDataXMLElement*) createColorElement:(SKColor*)value Named:(NSString *)name
{
    CGColorRef cgColor = value.CGColor;
    int numOfComponents = (int)CGColorGetNumberOfComponents(cgColor);
    const CGFloat* components = CGColorGetComponents(cgColor);
    
    GDataXMLElement* element = nil;
    if (numOfComponents == 4)
    {
        element = [GDataXMLNode elementWithName:name];
        [element addAttribute:[GDataXMLElement elementWithName:XML_ATTRB_VALUE_TYPE stringValue:VALUE_TYPE_COLOR_RGBA]];
        [element addChild:[JKXMLHelper createFloatElement:components[0] Precision:5 Named:@"red"]];
        [element addChild:[JKXMLHelper createFloatElement:components[1] Precision:5 Named:@"green"]];
        [element addChild:[JKXMLHelper createFloatElement:components[2] Precision:5 Named:@"blue"]];
        [element addChild:[JKXMLHelper createFloatElement:components[3] Precision:5 Named:@"alpha"]];
    }
    return element;
}

+ (NSInteger) getIntValueFromElement:(GDataXMLElement *)element
{
    NSInteger value = VALUE_UNDEFINED;
    NSString* type = [element attributeForName:XML_ATTRB_VALUE_TYPE].stringValue;
    if ([type isEqualToString:VALUE_TYPE_INTEGER])
    {
        value = element.stringValue.integerValue;
    }
    else
    {
        JKAssert(NO, @"Invalid value type=%@", type);
    }
    return value;
}

+ (CGFloat) getFloatValueFromElement:(GDataXMLElement *)element
{
    CGFloat fvalue = VALUE_UNDEFINED_F;
    NSString* type = [element attributeForName:XML_ATTRB_VALUE_TYPE].stringValue;
    if ([type isEqualToString:VALUE_TYPE_FLOAT])
    {
        fvalue = element.stringValue.floatValue;
    }
    else
    {
        JKAssert(NO, @"Invalid value type=%@", type);
    }
    return fvalue;
}

+ (NSString *) getStringValueFromElement:(GDataXMLElement *)element
{
    NSString* value = nil;
    NSString* type = [element attributeForName:XML_ATTRB_VALUE_TYPE].stringValue;
    if ([type isEqualToString:VALUE_TYPE_STRING])
    {
        value = element.stringValue;
    }
    else
    {
        JKAssert(NO, @"Invalid value type=%@", type);
    }
    return value;
}

+ (CGPoint) getPointValueFromElement:(GDataXMLElement*)element
{
    CGFloat x = VALUE_UNDEFINED_F;
    CGFloat y = VALUE_UNDEFINED_F;
    
    NSString* type = [element attributeForName:XML_ATTRB_VALUE_TYPE].stringValue;
    if ([type isEqualToString:VALUE_TYPE_POINT])
    {
        x = [JKXMLHelper getFloatValueFromElement:[element elementForName:@"x"]];
        y = [JKXMLHelper getFloatValueFromElement:[element elementForName:@"y"]];
        //x = [JKXMLHelper getFloatNamed:@"x" FromElement:element];
        //y = [JKXMLHelper getFloatNamed:@"y" FromElement:element];
        JKAssert(x != VALUE_UNDEFINED_F && y != VALUE_UNDEFINED_F, @"Invalid XML structure! (%.2f, %.2f)", x, y);
    }
    else
    {
        JKAssert(NO, @"Invalid value type=%@", type);
    }
    return CGPointMake(x, y);
}

+ (CGSize) getSizeValueFromElement:(GDataXMLElement*)element
{
    CGFloat width = VALUE_UNDEFINED_F;
    CGFloat height = VALUE_UNDEFINED_F;
    
    NSString* type = [element attributeForName:XML_ATTRB_VALUE_TYPE].stringValue;
    if ([type isEqualToString:VALUE_TYPE_SIZE])
    {
        width = [JKXMLHelper getFloatValueFromElement:[element elementForName:@"width"]];
        height = [JKXMLHelper getFloatValueFromElement:[element elementForName:@"height"]];
        //width = [JKXMLHelper getFloatNamed:@"width" FromElement:element];
        //height = [JKXMLHelper getFloatNamed:@"height" FromElement:element];
        JKAssert(width != VALUE_UNDEFINED_F && height != VALUE_UNDEFINED_F, @"Invalid XML structure! (width=%.2f; height=%.2f)", width, height);
    }
    else
    {
        JKAssert(NO, @"Invalid value type=%@", type);
    }
    return CGSizeMake(width, height);
}

+ (SKColor*) getColorValueFromElement:(GDataXMLElement*)element
{
    SKColor* color = [SKColor clearColor];
    
    NSString* type = [element attributeForName:XML_ATTRB_VALUE_TYPE].stringValue;
    if ([type isEqualToString:VALUE_TYPE_COLOR_RGBA])
    {
        CGFloat red = [JKXMLHelper getFloatValueFromElement:[element elementForName:@"red"]];
        CGFloat green = [JKXMLHelper getFloatValueFromElement:[element elementForName:@"green"]];
        CGFloat blue = [JKXMLHelper getFloatValueFromElement:[element elementForName:@"blue"]];
        CGFloat alpha = [JKXMLHelper getFloatValueFromElement:[element elementForName:@"alpha"]];
        //CGFloat red = [JKXMLHelper getFloatNamed:@"red" FromElement:element];
        //CGFloat green = [JKXMLHelper getFloatNamed:@"green" FromElement:element];
        //CGFloat blue = [JKXMLHelper getFloatNamed:@"blue" FromElement:element];
        //CGFloat alpha = [JKXMLHelper getFloatNamed:@"alpha" FromElement:element];
        JKAssert(red != VALUE_UNDEFINED_F && green != VALUE_UNDEFINED_F && blue != VALUE_UNDEFINED_F && alpha != VALUE_UNDEFINED_F, @"Invalid xml structure (r=%.2f; g=%.2f; b=%.2f; a=%.2f", red, green, blue, alpha);
        
        color = [SKColor colorWithRed:red green:green blue:blue alpha:alpha];
    }
    else
    {
        JKAssert(NO, @"Invalid value type=%@", type);
    }
    return color;
}

+ (JKObjectXML*) parseObjectFromElement:(GDataXMLElement*)root;
{
    JKObjectXML* obj = [JKObjectXML new];
    
    for (GDataXMLElement* element in root.children)
    {
        if ([element.name isEqualToString:XML_KEY_OBJ_ID])
        {   obj.objID = [JKXMLHelper getIntValueFromElement:element];
        }
        else if ([element.name isEqualToString:XML_KEY_OBJ_TYPE])
        {   obj.objType = [JKXMLHelper getIntValueFromElement:element];
        }
        else if ([element.name isEqualToString:XML_KEY_SIZE])
        {   obj.size = [JKXMLHelper getSizeValueFromElement:element];
        }
        else if ([element.name isEqualToString:XML_KEY_COLOR])
        {   obj.color = [JKXMLHelper getColorValueFromElement:element];
        }
        else if ([element.name isEqualToString:XML_KEY_POSITION])
        {   obj.position = [JKXMLHelper getPointValueFromElement:element];
        }
        else if ([element.name isEqualToString:XML_KEY_ZPOS])
        {   obj.zPosition = [JKXMLHelper getFloatValueFromElement:element];
        }
        else
        {
            NSString* valueType = [element attributeForName:XML_ATTRB_VALUE_TYPE].stringValue;
            if ([valueType isEqualToString:VALUE_TYPE_STRING])
            {   [obj setProperty:[JKXMLHelper getStringValueFromElement:element] ForKey:element.name];
            }
            else if ([valueType isEqualToString:VALUE_TYPE_INTEGER])
            {   [obj setProperty:[NSNumber numberWithInteger:[JKXMLHelper getIntValueFromElement:element]] ForKey:element.name];
            }
            else if ([valueType isEqualToString:VALUE_TYPE_FLOAT])
            {   [obj setProperty:[NSNumber numberWithFloat:[JKXMLHelper getFloatValueFromElement:element]] ForKey:element.name];
            }
            else if ([valueType isEqualToString:VALUE_TYPE_POINT])
            {   [obj setProperty:[NSValue valueWithCGPoint:[JKXMLHelper getPointValueFromElement:element]] ForKey:element.name];
            }
            else if ([valueType isEqualToString:VALUE_TYPE_SIZE])
            {   [obj setProperty:[NSValue valueWithCGSize:[JKXMLHelper getSizeValueFromElement:element]] ForKey:element.name];
            }
            else if ([valueType isEqualToString:VALUE_TYPE_COLOR_RGBA])
            {   [obj setProperty:[JKXMLHelper getColorValueFromElement:element] ForKey:element.name];
            }
            else
            {   JKAssert(NO, @"Unknown type");
            }
        }
    }
    return obj;
}

+ (JKObjectXML*) xmlObjectFromGameNode:(JKGameNode*)gameNode
{
    JKObjectXML* xmlNode = [JKObjectXML new];
    xmlNode.objID = gameNode.objID;
    xmlNode.objType = gameNode.objType;
    xmlNode.position = gameNode.position;
    xmlNode.zPosition = gameNode.zPosition;
    if (gameNode.spriteNode != nil)
    {
        xmlNode.rotation = gameNode.spriteNode.zRotation;
        xmlNode.size = gameNode.spriteNode.size;
        xmlNode.color = gameNode.spriteNode.color;
    }
    return xmlNode;
}

+ (GDataXMLElement*) xmlElementFromGameNode:(JKGameNode*)gameNode
{
    GDataXMLElement* xmlNode = [GDataXMLNode elementWithName:XML_KEY_OBJECT];
    [xmlNode addChild:[JKXMLHelper createIntegerElement:gameNode.objID Named:XML_KEY_OBJ_ID]];
    [xmlNode addChild:[JKXMLHelper createIntegerElement:gameNode.objType Named:XML_KEY_OBJ_TYPE]];
    [xmlNode addChild:[JKXMLHelper createPointElement:gameNode.position Named:XML_KEY_POSITION]];
    [xmlNode addChild:[JKXMLHelper createFloatElement:gameNode.zPosition Precision:2 Named:XML_KEY_ZPOS]];
    [xmlNode addChild:[JKXMLHelper createFloatElement:gameNode.zRotation Precision:2 Named:XML_KEY_ROTATION]];
    
    if (gameNode.spriteNode)
    {
        [xmlNode addChild: [JKXMLHelper createSizeElement:gameNode.spriteNode.size Named:XML_KEY_SIZE]];
        
        if ([gameNode.spriteNode colorBlendFactor] > 0.0f)
        {
            [xmlNode addChild:[JKXMLHelper createColorElement:gameNode.spriteNode.color Named:XML_KEY_COLOR]];
        }
    }
    return xmlNode;
}

@end
