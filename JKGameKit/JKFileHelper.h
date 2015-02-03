//
//  FileHelper.h
//  BadPuppies
//
//  Created by Jussi Kallio on 10.11.2013.
//  Copyright (c) 2013 Jussi Kallio. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GDataXMLNode.h"

typedef enum _EDirectory
{
    DIR_BUNDLE,
    DIR_DOCUMENTS
} EDirectory;

@interface JKFileHelper : NSObject

+ (BOOL) fileExists:(NSString *)fileName InDirectory:(EDirectory)dir;
+ (BOOL) fileExists:(NSString *)fileName;
+ (BOOL) levelExists:(NSString *)levelName;

+ (NSString*) fullPathForFileNamed:(NSString *)fileName InDirectory:(EDirectory)dir;
+ (NSString*) fullPathForLevelNamed:(NSString *)levelName;

+ (BOOL) createFolder:(NSString *)folderName;
+ (BOOL) saveLevelAsXML:(GDataXMLElement*)rootElement levelName:(NSString*)levelName;
+ (GDataXMLElement*) loadLevelAsXML:(NSString*)levelName;

@end
