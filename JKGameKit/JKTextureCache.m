//
//  JKTextureCache.m
//  JKGameKit
//
//  Created by Jussi Kallio on 4.11.2014.
//  Copyright (c) 2014 Kallio. All rights reserved.
//

#import "JKOrderedDictionary.h"
#import "JKTextureCache.h"

static JKTextureCache* _textureCache;
static BOOL _isInitialized = NO;

@implementation JKTextureCache

+ (instancetype) sharedTextureCache
{
    NSAssert(_textureCache, @"Invalid singleton instance");
    return _textureCache;
}

+ (void) initialize
{
    if (!_isInitialized)
    {
        _textureCache = [JKTextureCache new];
        _isInitialized = YES;
    }
}

- (instancetype) init
{
    if (self = [super init])
    {
        _textureCache = [JKOrderedDictionary dictionary];
    }
    return self;
}

- (void) purgeTextureCache
{
    [self.textureCache removeAllObjects];
}

- (SKTexture*) getTextureNamed:(NSString*)name
{
    SKTexture* texture = [self.textureCache objectForKey:name];
    if (!texture)
    {
        texture = [SKTexture textureWithImageNamed:name];
        if (texture)
        {
            [self.textureCache setObject:texture forKey:name];
            
            // Dirty fix for inproperly scaled sprites at first load
            //[SKSpriteNode spriteNodeWithTexture:texture];
        }
    }
    
    NSAssert(texture, @"Texture not found (%@)", name);
    return texture;
}

- (NSArray*) getTexturesWithNameBase:(NSString*)nameBase Count:(NSInteger)count
{
    NSMutableArray* frameList = [NSMutableArray new];
    for (int i=0; i < count; ++i)
    {
        NSString* name = [NSString stringWithFormat:@"%@%d", nameBase, i];
        [frameList addObject:[self getTextureNamed:name]];
    }
    
    NSAssert(frameList.count > 0, @"No frames found! (%@##)", nameBase);
    return frameList;
}

@end
