//
//  PluginTouchDispatcher.h
//  GigaMan
//
//  Created by Jussi Kallio on 6.10.2014.
//  Copyright (c) 2014 Jussi Kallio. All rights reserved.
//

#import "JKPluginBase.h"
@class JKPluginTouchHandlerBase;

@interface JKPluginTouchDispatcher : JKPluginBase

- (void)dispatchTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)dispatchTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)dispatchTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)dispatchTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
@end
