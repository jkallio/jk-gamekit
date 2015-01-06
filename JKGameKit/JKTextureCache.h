//
//  JKTextureCache.h
//  JKGameKit
//
//  Created by Jussi Kallio on 4.11.2014.
//  Copyright (c) 2014 Kallio. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@class JKOrderedDictionary;

#define __sharedTextureCache [JKTextureCache sharedTextureCache]

@interface JKTextureCache : NSObject
@property (nonatomic) JKOrderedDictionary* textureCache;

+ (instancetype) sharedTextureCache;

- (void) purgeTextureCache;
- (SKTexture*) getTextureNamed:(NSString*)name;
- (NSArray*) getTexturesWithNameBase:(NSString*)nameBase Count:(NSInteger)count;
- (SKTexture*) getTexturePatternNamed:(NSString*)name Size:(CGSize) size;
@end
