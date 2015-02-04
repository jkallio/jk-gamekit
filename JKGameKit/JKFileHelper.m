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

#define LEVEL_FOLDER_NAME                       @"levels"
#define LEVEL_FILENAME_IN_BUNDLE(levelName)     [NSString stringWithFormat:@"%@.xml", levelName]
#define LEVEL_FILENAME_IN_DOCS(levelName)       [NSString stringWithFormat:@"%@/%@.xml", LEVEL_FOLDER_NAME, levelName]

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
    return ([JKFileHelper levelExists:levelName InDirectory:DIR_DOCUMENTS]
            || [JKFileHelper levelExists:levelName InDirectory:DIR_BUNDLE]);
}

+ (BOOL) levelExists:(NSString *)levelName InDirectory:(EDirectory)dir
{
    switch (dir)
    {
        case DIR_DOCUMENTS: return [JKFileHelper fileExists:LEVEL_FILENAME_IN_DOCS(levelName) InDirectory:DIR_DOCUMENTS]; break;
        case DIR_BUNDLE: return [JKFileHelper fileExists:LEVEL_FILENAME_IN_BUNDLE(levelName) InDirectory:DIR_BUNDLE]; break;
    }
    return NO;
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
    NSString* fullPath = nil;
    if ([JKFileHelper createFolder:LEVEL_FOLDER_NAME])
    {
        fullPath = [JKFileHelper fullPathForFileNamed:LEVEL_FILENAME_IN_DOCS(levelName) InDirectory:DIR_DOCUMENTS];
    }
    return fullPath;
}

+ (BOOL) copyLevelFromBundleToDocuments:(NSString*)levelName
{
    BOOL bSuccess = NO;
    
    JKLog(@"Copying level %@ from Bundle to Documents fonlder", levelName);
    if ([JKFileHelper levelExists:levelName InDirectory:DIR_BUNDLE])
    {
        NSError* error = nil;
        bSuccess = [[NSFileManager defaultManager] copyItemAtPath:[JKFileHelper fullPathForFileNamed:LEVEL_FILENAME_IN_BUNDLE(levelName) InDirectory:DIR_BUNDLE] toPath:[JKFileHelper fullPathForLevelNamed:levelName] error:&error];
        if (!bSuccess)
        {
            JKAssert(NO, @"Failed to copy level %@ from bundle to documents: %@", levelName, error.description);
        }
    }
    
    return bSuccess;
}

+ (BOOL) createFolder:(NSString *)folderName
{
    BOOL folderExists = [JKFileHelper fileExists:folderName InDirectory:DIR_DOCUMENTS];
    if (!folderExists)
    {
        NSError* error = nil;
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
    BOOL bSuccess = NO;
    
    NSString* filePath = [JKFileHelper fullPathForLevelNamed:levelName];
    if (filePath != nil)
    {
        GDataXMLDocument* xmlDoc = [[GDataXMLDocument alloc] initWithRootElement:rootElement];
        NSData* xmlData = xmlDoc.XMLData;
        
        NSError* error = nil;
        if ([xmlData writeToFile:filePath options:NSDataWritingAtomic error:&error])
        {
            JKDebugLog(@"Level %@ saved as XML file %@", levelName, filePath);
            bSuccess = YES;
        }
        else
        {
            JKAssert(NO, @"Failed to save level %@ saved as XML file %@: %@", levelName, filePath, error.description);
            bSuccess = NO;
        }
    }
 
    return bSuccess;
}

+ (GDataXMLElement*) loadLevelAsXML:(NSString*)levelName
{
    GDataXMLElement* levelRoot = nil;
    if (![JKFileHelper levelExists:levelName InDirectory:DIR_DOCUMENTS] && [JKFileHelper levelExists:levelName InDirectory:DIR_BUNDLE])
    {
        [JKFileHelper copyLevelFromBundleToDocuments:levelName];
    }
    
    if ([JKFileHelper levelExists:levelName InDirectory:DIR_DOCUMENTS])
    {
        JKLog(@"Loading level data %@...", levelName);
        NSString* filePath = [JKFileHelper fullPathForLevelNamed:levelName];
        
        NSError* error = nil;
        GDataXMLDocument* xmlDoc = [[GDataXMLDocument alloc] initWithData:[[NSMutableData alloc] initWithContentsOfFile:filePath] options:0 error:&error];
        if (!xmlDoc)
        {
            JKAssert(NO, @"Level file not found %@ (error=%@)", filePath, error.description);
            return nil;
        }
        levelRoot = [xmlDoc.rootElement copy];
    }
    return levelRoot;
}

@end
