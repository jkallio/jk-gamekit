//
//  Utils.h
//  GigaMan
//
//  Created by Jussi Kallio on 7.10.2014.
//  Copyright (c) 2014 Jussi Kallio. All rights reserved.
//

#import <GLKit/GLKit.h>
#import <SpriteKit/SpriteKit.h>
#import <stdlib.h>

// CGVector utils
static inline GLKVector2 GLKVector2FromVector(CGVector v) {
    return GLKVector2Make(v.dx, v.dy);
}

static inline CGVector CGVectorFromGLKVector2(GLKVector2 v) {
    return CGVectorMake(v.x, v.y);
}

static inline CGVector CGVectorScalarMultiply(CGVector vector, CGFloat x) {
    return CGVectorFromGLKVector2(GLKVector2MultiplyScalar(GLKVector2FromVector(vector), x));
}

static inline CGVector CGVectorAdd(CGVector v1, CGVector v2) {
    return CGVectorMake(v1.dx + v2.dx, v1.dy + v2.dy);
}

// CGPoint utils
static inline CGPoint CGPointFromCGVector(CGVector v) {
    return CGPointMake(v.dx, v.dy);
}

static inline CGPoint CGPointAdd(CGPoint a, CGPoint b) {
    return CGPointMake(a.x + b.x, a.y + b.y);
}

static inline CGPoint MidPoint(CGRect frame) {
    return CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
}

static inline CGFloat DistanceBetweenPoints(CGPoint p1, CGPoint p2) {
    return ABS(sqrtf(powf(p2.x-p1.x, 2) + powf(p2.y-p1.y, 2)));
}

// CGSize utils
static inline CGSize CGSizeMultiply(CGSize size, CGFloat x){
    return CGSizeMake(size.width * x, size.height * x);
}

// NSString utils
static inline NSString* NSStringFromInteger(NSInteger d) {
    return [NSString stringWithFormat:@"%ld", (long)d];
}

static inline NSString* NSStringFromInt(int d) {
    return [NSString stringWithFormat:@"%d", d];
}

static inline NSString* NSStringFormFloat(CGFloat f) {
    return [NSString stringWithFormat:@"%.2f", f];
}

static inline NSString* NSStringFromFloat(CGFloat f, NSInteger precision) {
    NSString* format =[@"%." stringByAppendingFormat:@"%df", (int)precision]; return [NSString stringWithFormat:format, f];
}

static inline NSString* NSStringFromBool(BOOL b) {
    return [NSString stringWithFormat:@"%@", (b ? @"YES" : @"NO")];
}

static inline NSInteger randomInteger(NSInteger min, NSInteger max)
{
    NSInteger rand = INT_MIN;
    if (max > min)
    {
        rand = min + arc4random_uniform((int)(max - min));
    }
    else if (min == max)
    {
        rand = min;
    }
    else
    {
        assert(false);
    }
    return rand;
}

static inline BOOL randomBool()
{
    return (randomInteger(0, 100) >= 50);
}

static inline NSInteger moduloPositive(NSInteger value, NSInteger modulo)
{
    value = value % modulo;
    value += (value < 0) ? modulo : 0;
    return value;
}

/*
static void vomitFontNames()
{
    for (NSString* family in [UIFont familyNames])
    {
        NSLog(@"%@", family);
        
        for (NSString* name in [UIFont fontNamesForFamilyName: family])
        {
            NSLog(@"  %@", name);
        }
    }
}
*/