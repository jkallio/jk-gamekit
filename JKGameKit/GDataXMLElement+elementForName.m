//
//  GDataXMLElement+elementForName.m
//  Puppy Commander
//
//  Created by Jussi Kallio on 11.6.2014.
//  Copyright (c) 2014 Jussi Kallio. All rights reserved.
//

#import "JKDefines.h"
#import "GDataXMLElement+elementForName.h"

@implementation GDataXMLElement (elementForName)

- (GDataXMLElement*) elementForName:(NSString *)name
{
    NSArray* elementList = [self elementsForName:name];
    JKAssert(elementList.count == 1, @"Multiple values found for name %@", name);
    return elementList.firstObject;
}

@end
