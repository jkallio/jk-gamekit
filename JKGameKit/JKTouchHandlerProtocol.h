//
//  MyTouchHandlerProtocol.h
//  GigaMan
//
//  Created by Jussi Kallio on 6.10.2014.
//  Copyright (c) 2014 Jussi Kallio. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@protocol JKTouchHandlerProtocol <NSObject>

@required
- (void)handleTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)handleTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)handleTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)handleTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
- (BOOL) respondsToTouches;
@end
