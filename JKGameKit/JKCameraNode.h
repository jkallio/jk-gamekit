//
//  JKCameraNode.h
//  JKGameKit
//
//  Created by Jussi Kallio on 3.11.2014.
//  Copyright (c) 2014 Kallio. All rights reserved.
//

#import "JKNode.h"

@interface JKCameraNode : JKNode
@property (nonatomic) CGPoint targetPosition;
@property (nonatomic) CGFloat cameraSpeed;
@property (nonatomic) CGFloat distanceThreshold;
@end
