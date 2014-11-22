//
//  OrderedDictionary.m
//  BadPuppies
//
//  Created by Jussi Kallio on 14.11.2013.
//  Copyright (c) 2013 Jussi Kallio. All rights reserved.
//

#import "JKOrderedDictionary.h"

NSString* DescriptionForObject(NSObject *object, id locale, NSUInteger indent)
{
	NSString *objectString;
	if ([object isKindOfClass:[NSString class]])
	{
		objectString = (NSString *)object;
	}
	else if ([object respondsToSelector:@selector(descriptionWithLocale:indent:)])
	{
		objectString = [(NSDictionary *)object descriptionWithLocale:locale indent:indent];
	}
	else if ([object respondsToSelector:@selector(descriptionWithLocale:)])
	{
		objectString = [(NSSet *)object descriptionWithLocale:locale];
	}
	else
	{
		objectString = [object description];
	}
	return objectString;
}

@implementation JKOrderedDictionary

- (id)init
{
    if (self = [super init])
    {
        _dictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
        _keyArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (id)initWithCapacity:(NSUInteger)capacity
{
	if (self = [super init])
	{
		_dictionary = [[NSMutableDictionary alloc] initWithCapacity:capacity];
		_keyArray = [[NSMutableArray alloc] initWithCapacity:capacity];
	}
	return self;
}

- (id)copy
{
	return [self mutableCopy];
}

- (void)setObject:(id)obj forKey:(id)key
{
	if (![_dictionary objectForKey:key])
	{
		[_keyArray addObject:key];
	}
	[_dictionary setObject:obj forKey:key];
}

- (void)removeObjectForKey:(id)key
{
	[_dictionary removeObjectForKey:key];
	[_keyArray removeObject:key];
}

- (NSUInteger)count
{
	return [_dictionary count];
}

- (id)objectForKey:(id)key
{
	return [_dictionary objectForKey:key];
}

- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
	NSMutableString *indentString = [NSMutableString string];
	NSUInteger i, count = level;
	for (i = 0; i < count; i++)
	{
		[indentString appendFormat:@"    "];
	}
	
	NSMutableString *description = [NSMutableString string];
	[description appendFormat:@"%@{\n", indentString];
	for (NSObject *key in self)
	{
		[description appendFormat:@"%@    %@ = %@;\n",
			indentString,
			DescriptionForObject(key, locale, level),
			DescriptionForObject([self objectForKey:key], locale, level)];
	}
	[description appendFormat:@"%@}\n", indentString];
	return description;
}

- (void) insertObject:(id)obj forKey:(id)key atIndex:(NSUInteger)index
{
    if ([_dictionary objectForKey:key])
	{
		[self removeObjectForKey:key];
	}
	[_keyArray insertObject:key atIndex:index];
	[_dictionary setObject:obj forKey:key];
}

- (id) keyAtIndex:(NSUInteger)index
{
    return [_keyArray objectAtIndex:index];
}

- (id) objectAtIndex:(NSUInteger)index
{
    return [_dictionary objectForKey:[self keyAtIndex:index]];
}

- (NSEnumerator *)keyEnumerator
{
	return [_keyArray objectEnumerator];
}

- (NSEnumerator*) reverseKeyEnumerator
{
    return [_keyArray reverseObjectEnumerator];
}

@end
