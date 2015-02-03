//
//  FileHelper.m
//  BadPuppies
//
//  Created by Jussi Kallio on 10.11.2013.
//  Copyright (c) 2013 Jussi Kallio. All rights reserved.
//

#import "JKDefines.h"
#import "JKWorldNode.h"
#import "JKFileHelper.h"

@implementation JKFileHelper

+ (BOOL) fileExists:(NSString*)fileName InDirectory:(EDirectory)dir
{
    NSString* filePath = [JKFileHelper fullPathForFileNamed:fileName InDirectory:dir];
    return (filePath != nil && [[NSFileManager defaultManager] fileExistsAtPath:filePath]);
}

+ (BOOL) fileExists:(NSString*)fileName
{
    return ([JKFileHelper fileExists:fileName InDirectory:DIR_DOCUMENTS]
            || [JKFileHelper fileExists:fileName InDirectory:DIR_BUNDLE]);
}

+ (BOOL) levelExists:(NSString*)levelName
{
    return ([JKFileHelper fileExists:[NSString stringWithFormat:@"%@/%@.xml", LEVEL_FOLDER_NAME, levelName] InDirectory:DIR_DOCUMENTS]
            || [JKFileHelper fileExists:[NSString stringWithFormat:@"%@.xml", levelName] InDirectory:DIR_BUNDLE]);
}

+ (NSString*) fullPathForFileNamed:(NSString*)fileName InDirectory:(EDirectory)dir
{
    NSString* fullPath = nil;
    switch (dir)
    {
        case DIR_BUNDLE:
        {
            NSArray* parts = [fileName componentsSeparatedByString:@"."];
            NSAssert(parts.count == 2, @"Invalid fileName %@", fileName);
            
            if (parts.count == 2)
            {
                fullPath = [[NSBundle mainBundle] pathForResource:[parts objectAtIndex:0] ofType:[parts objectAtIndex:1]];
            }
        } break;
            
        case DIR_DOCUMENTS:
        {
            NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSAssert(paths.count == 1, @"Documents directory not found");
            
            if (paths.count == 1)
            {
                fullPath = [paths.firstObject stringByAppendingPathComponent:fileName];
            }
        } break;
    }
    return fullPath;
}

+ (NSString*) fullPathForLevelNamed:(NSString *)levelName
{
    [JKFileHelper createFolder:LEVEL_FOLDER_NAME];
    return [JKFileHelper fullPathForFileNamed:[NSString stringWithFormat:@"%@/%@.xml", LEVEL_FOLDER_NAME, levelName] InDirectory:DIR_DOCUMENTS];
}

+ (BOOL) createFolder:(NSString *)folderName
{
    BOOL folderExists = [JKFileHelper fileExists:folderName InDirectory:DIR_DOCUMENTS];
    if (!folderExists)
    {
        NSError* error;
        if ([[NSFileManager defaultManager] createDirectoryAtPath:[JKFileHelper fullPathForFileNamed:folderName InDirectory:DIR_DOCUMENTS] withIntermediateDirectories:NO attributes:nil error:&error])
        {
            folderExists = YES;
        }
        else
        {
            NSAssert(NO, @"%@", error.description);
        }
        
    }
    return folderExists;
}

+ (BOOL) saveLevelAsXML:(GDataXMLElement*)rootElement levelName:(NSString*)levelName
{
    NSString* filePath = [JKFileHelper fullPathForLevelNamed:levelName];
    GDataXMLDocument* xmlDoc = [[GDataXMLDocument alloc] initWithRootElement:rootElement];
    NSData* xmlData = xmlDoc.XMLData;
    
    NSError* error;
    if ([xmlData writeToFile:filePath options:NSDataWritingAtomic error:&error])
    {
        JKDebugLog(@"Level %@ saved as XML file %@", levelName, filePath);
        return true;
    }
    else
    {
        JKAssert(NO, @"Failed to save level %@ saved as XML file %@ (error=%@)", levelName, filePath, error.description);
        return false;
    }
}

+ (GDataXMLElement*) loadLevelAsXML:(NSString*)levelName
{
    NSString* filePath = [JKFileHelper fullPathForLevelNamed:levelName];

    NSError* error;
    GDataXMLDocument* xmlDoc = [[GDataXMLDocument alloc] initWithData:[[NSMutableData alloc] initWithContentsOfFile:filePath] options:0 error:&error];
    if (!xmlDoc)
    {
        JKAssert(NO, @"File not found %@ (error=%@)", filePath, error.description);
        return nil;
    }
    return [xmlDoc.rootElement copy];
}

@end
