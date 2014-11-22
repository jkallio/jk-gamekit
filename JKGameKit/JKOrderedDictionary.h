//
//  OrderedDictionary.h
//  BadPuppies
//
//  Created by Jussi Kallio on 14.11.2013.
//  Copyright (c) 2013 Jussi Kallio. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface JKOrderedDictionary : NSMutableDictionary
{
}
@property (nonatomic) NSMutableDictionary* dictionary;
@property (nonatomic) NSMutableArray* keyArray;

- (void) insertObject:(id)obj forKey:(id)key atIndex:(NSUInteger)index;
- (id) keyAtIndex:(NSUInteger)index;
- (id) objectAtIndex:(NSUInteger)index;
- (NSEnumerator*) reverseKeyEnumerator;

@end
