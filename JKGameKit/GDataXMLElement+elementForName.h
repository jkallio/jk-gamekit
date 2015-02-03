//
//  GDataXMLElement+elementForName.h
//  Puppy Commander
//
//  Created by Jussi Kallio on 11.6.2014.
//  Copyright (c) 2014 Jussi Kallio. All rights reserved.
//

#import "GDataXMLNode.h"

@interface GDataXMLElement (elementForName)

- (GDataXMLElement*) elementForName:(NSString *)name;

@end
