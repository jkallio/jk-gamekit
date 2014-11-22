//
//  SKShadowedLabelNode.m
//  Puppy Commander
//
//  Created by Jussi Kallio on 19.6.2014.
//  Copyright (c) 2014 Jussi Kallio. All rights reserved.
//

#import "JKDefines.h"
#import "JKShadowedLabelNode.h"

@interface JKShadowedLabelNode()
@property (nonatomic, weak) SKLabelNode* shadow;
@end


@implementation JKShadowedLabelNode

+ (instancetype)labelNodeWithFontNamed:(NSString *)fontName
{
    return [[JKShadowedLabelNode alloc] initWithFontNamed:fontName];
}

- (instancetype)initWithFontNamed:(NSString *)fontName
{
    if (self = [super initWithFontNamed:fontName])
    {
        _shadowColor = [UIColor blackColor];
        
        SKLabelNode* shadow = [SKLabelNode labelNodeWithFontNamed:self.fontName];
        shadow.name = @"LabelShadow";
        shadow.text = self.text;
        shadow.fontSize = self.fontSize;
        shadow.position = CGPointMake(self.position.x + PIXELS(2), self.position.y - PIXELS(2));
        shadow.zPosition = self.zPosition - 1;
        shadow.zRotation = self.zRotation;
        shadow.fontColor = _shadowColor;
        
        self.shadow = shadow;
        [self addChild:shadow];
    }
    return self;
}

- (void) setFontName:(NSString *)fontName
{
    [super setFontName:fontName];
    if (self.shadow)
    {
        [self.shadow setFontName:fontName];
    }
}

- (void) setText:(NSString *)text
{
    [super setText:text];
    if (self.shadow)
    {
        [self.shadow setText:text];
    }
}

- (void) setFontSize:(CGFloat)fontSize
{
    [super setFontSize:fontSize];
    if (self.shadow)
    {
        [self.shadow setFontSize:fontSize];
    }
}

- (void) setFontColor:(UIColor *)fontColor
{
    [super setFontColor:fontColor];
    if (self.shadow)
    {
        self.shadow.fontColor = self.shadowColor;
    }
}

- (void) setShadowColor:(UIColor *)shadowColor
{
    _shadowColor = shadowColor;
    [self.shadow setFontColor:_shadowColor];
}

@end
