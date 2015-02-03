//
//  JKNodeFactory.m
//  JKGameKit
//
//  Created by Jussi Kallio on 2.2.2015.
//  Copyright (c) 2015 Kallio. All rights reserved.
//

#import "JKDefines.h"
#import "JKObjectXML.h"
#import "JKNodeFactory.h"

@implementation JKNodeFactory

- (JKGameNode*) createGameNodeWithXMLObject:(JKObjectXML*)xmlObject
{
    JKAssert(NO, @"Child must implement");
    return nil;
}
@end
