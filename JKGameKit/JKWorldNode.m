//
//  JKWorldNode.m
//  JKGameKit
//
//  Created by Jussi Kallio on 3.11.2014.
//  Copyright (c) 2014 Kallio. All rights reserved.
//

#import "JKDefines.h"
#import "JKNodeFactory.h"
#import "JKFileHelper.h"
#import "JKXMLHelper.h"
#import "JKGameScene.h"
#import "JKCameraNode.h"
#import "JKGameNode.h"
#import "JKWorldNode.h"
#import "GDataXMLElement+elementForName.h"

@implementation JKWorldNode

- (instancetype) initWithLevelName:(NSString *)levelName
{
    if (self = [super init])
    {
        _levelName = levelName;
    }
    return self;
}

- (BOOL) loadLevel
{
    BOOL bSuccess = YES;
    self.name = @"WorldNode";
    JKCameraNode* camera = [JKCameraNode node];
    camera.name = @"NodeCamera";
    [self addChild:camera];
    self.camera = camera;
    
    if ([JKFileHelper levelExists:self.levelName])
    {
        JKLog(@"Loading level data %@...", self.levelName);
        
        GDataXMLElement* levelRoot = [JKFileHelper loadLevelAsXML:self.levelName];
        JKDebugLog(@"%@", levelRoot.name);
        if (levelRoot != nil && [levelRoot.name isEqualToString:XML_KEY_LEVEL])
        {
            CGSize worldSize = [JKXMLHelper getSizeValueFromElement:[levelRoot elementForName:XML_KEY_SIZE]];
            self.borders = CGRectMake(-worldSize.width/2, -worldSize.height/2, worldSize.width, worldSize.height);
            JKDebugLog(@"World size =%@", NSStringFromCGSize(worldSize));
            
            GDataXMLElement* objecList = [levelRoot elementForName:XML_KEY_OBJECT_LIST];
            NSArray* objects = [objecList elementsForName:XML_KEY_OBJECT];
            for (GDataXMLElement* element in objects)
            {
                JKDebugLog(@"Loading %@", element.name);
                JKAssert(self.gameScene.nodeFactory != nil, @"NodeFactory not set");
                JKGameNode* gameNode = [self.gameScene.nodeFactory createGameNodeWithXMLObject:[JKXMLHelper parseObjectFromElement:element]];
                JKDebugLog(@"Loading #%d: %@...", (int)gameNode.objID, gameNode.name);
                [self addChild:gameNode];
            }
        }
        else
        {
            bSuccess = NO;
        }
    }
    
    return bSuccess;
}

- (BOOL) saveLevel
{
    BOOL bSuccess = NO;
    if (self.levelName != nil)
    {
        JKLog(@"Saving level data %@...", self.levelName);
        GDataXMLElement* rootElement = [GDataXMLNode elementWithName:XML_KEY_LEVEL];
        [rootElement addChild:[JKXMLHelper createSizeElement:self.borders.size Named:XML_KEY_SIZE]];
        
        GDataXMLElement* objectList = [GDataXMLNode elementWithName:XML_KEY_OBJECT_LIST];
        for (SKNode* node in self.children)
        {
            JKGameNode* gameNode = [JKGameNode cast:node];
            if (gameNode != nil && gameNode.saveToXML)
            {
                JKDebugLog(@"Saving #%d: %@...", (int)gameNode.objID, gameNode.name);
                [objectList addChild:[JKXMLHelper xmlElementFromGameNode:gameNode]];
            }
            else
            {
                JKDebugLog(@"%@ skipped", gameNode.name);
            }
        }
        [rootElement addChild:objectList];
        bSuccess = [JKFileHelper saveLevelAsXML:rootElement levelName:self.levelName];
    }
    
    JKAssert(bSuccess, @"Failed to save level data");
    return bSuccess;
}

- (JKHudNode*) loadHUD
{
    JKAssert(NO, @"Child world must implement");
    return nil;
}

- (JKGameNode*) hero
{
    if (!_hero)
    {
        _hero = [JKGameNode cast:[self childNodeWithName:NODE_NAME_HERO]];
    }
    return _hero;
}
@end
