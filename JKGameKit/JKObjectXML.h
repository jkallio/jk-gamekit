//
//  JKObjectXML
//  BadPuppies
//
//  Created by Jussi Kallio on 15.11.2013.
//  Copyright (c) 2013 Jussi Kallio. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface JKObjectXML : NSObject
{
    NSMutableDictionary* _propertyList;
}
@property (nonatomic, readonly) NSDictionary* getPropertyList;

#pragma mark -- Object identifiers
@property (nonatomic) NSInteger objID;
@property (nonatomic) NSInteger objType;

#pragma mark -- Node properties
@property (nonatomic) CGPoint position;
@property (nonatomic) CGFloat zPosition;

#pragma mark -- SpriteNode properties
@property (nonatomic) CGFloat rotation;
@property (nonatomic) CGSize size;
@property (nonatomic) SKColor* color;

#pragma mark -- Custom properties
- (void) setIntProperty:(NSInteger)value ForKey:(NSString *)key;
- (void) setFloatProperty:(NSInteger)value ForKey:(NSString *)key;
- (void) setStringProperty:(NSString *)value ForKey:(NSString *)key;
- (void) setProperty:(id)obj ForKey:(NSString *)key;

@end
