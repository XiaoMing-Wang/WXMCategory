//
//  NSArray+Log.m
//  MyLoveApp
//
//  Created by wq on 2019/4/9.
//  Copyright © 2019年 wq. All rights reserved.
//

#import "NSArray+Log.h"

@implementation NSArray (Log)

- (NSString *)description {
    @try {
        if (self.count == 0) return @"[ ]";
        NSMutableString *string = [NSMutableString string];
        [string appendString:@"[\n"];
        [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [string appendFormat:@"\t%@,\n", obj ?: @""];
        }];
        [string appendString:@"]"];
        NSRange range = [string rangeOfString:@"," options:NSBackwardsSearch];
        if (range.location != NSNotFound) [string deleteCharactersInRange:range];
        return string;
        
    } @catch (NSException *exception) {
        NSLog(@"%@", [NSString stringWithFormat:@"%@ description崩溃", self.class]);
    } @finally { }
}
@end

@implementation NSDictionary (Log)
- (NSString *)description {
    @try {
        if (self.allKeys.count == 0) return @"{ }";
        NSMutableString *string = [NSMutableString string];
        [string appendString:@"{\n"];
        [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [string appendFormat:@"\t%@", key ?: @""];
            [string appendString:@" : "];
            [string appendFormat:@"%@,\n", obj ?: @""];
        }];
        [string appendString:@"}"];
        NSRange range = [string rangeOfString:@"," options:NSBackwardsSearch];
        if (range.location != NSNotFound) [string deleteCharactersInRange:range];
        return string;
        
    } @catch (NSException *exception) {
        NSLog(@"%@", [NSString stringWithFormat:@"%@ description崩溃", self.class]);
    } @finally { }
}
@end

