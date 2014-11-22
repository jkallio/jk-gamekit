//
//  JKCameraNode.m
//  JKGameKit
//
//  Created by Jussi Kallio on 3.11.2014.
//  Copyright (c) 2014 Kallio. All rights reserved.
//

#import "JKCameraNode.h"

@implementation JKCameraNode

- (instancetype) init
{
    if (self = [super init])
    {
        _targetPosition = CGPointZero;
        _cameraSpeed = 0.2f;
        _distanceThreshold = 0.0f;
    }
    return self;
}

- (void) setCameraSpeed:(CGFloat)cameraSpeed
{
    cameraSpeed = MIN(1.0f, MAX(0.1f, cameraSpeed));
    _cameraSpeed = cameraSpeed;
}

- (void) onUpdate:(NSTimeInterval)dt
{
    CGVector direction = CGVectorMake(self.targetPosition.x - self.position.x, self.position.y - self.targetPosition.y);
    CGFloat distance = sqrtf(powf(direction.dx, 2) + powf(direction.dy, 2));
    
    if (ABS(distance) > self.distanceThreshold)
    {
        float dx = direction.dx * self.cameraSpeed;
        float dy = direction.dy * self.cameraSpeed;
        self.position = CGPointMake(dx + self.position.x, self.position.y - dy);
        
    }
}

@end
