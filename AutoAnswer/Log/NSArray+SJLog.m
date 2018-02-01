//
//  NSArray+SJLog.m
//  SJBicycle
//
//  Created by 金峰 on 2017/6/29.
//  Copyright © 2017年 金峰. All rights reserved.
//

#import "NSArray+SJLog.h"

@implementation NSArray (SJLog)
/**
 * 重写控制台打印方法
 */
- (NSString *)descriptionWithLocale:(id)locale {
    NSMutableString *str = [NSMutableString stringWithFormat:@"%lu (\n", (unsigned long)self.count];
    for (id obj in self) {
        [str appendFormat:@"\t%@, \n", obj];
    }
    [str appendString:@")"];
    return str;
}

@end
