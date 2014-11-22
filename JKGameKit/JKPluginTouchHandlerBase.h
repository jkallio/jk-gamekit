//
//  PluginTouchHandlerBase.h
//  GigaMan
//
//  Created by Jussi Kallio on 6.10.2014.
//  Copyright (c) 2014 Jussi Kallio. All rights reserved.
//

#import "JKPluginBase.h"
#import "JKTouchHandlerProtocol.h"

@interface JKPluginTouchHandlerBase : JKPluginBase <JKTouchHandlerProtocol>

- (void)handleTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)handleTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)handleTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)handleTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
- (BOOL) respondsToTouches;

@end
 