//
//  NSDictionary+SJLog.m
//  SJBicycle
//
//  Created by 金峰 on 2017/6/29.
//  Copyright © 2017年 金峰. All rights reserved.
//

#import "NSDictionary+SJLog.h"

@implementation NSDictionary (SJLog)
/**
 * 重写控制台打印方法
 */
- (NSString *)descriptionWithLocale:(id)locale {
     NSArray *allKeys = [self allKeys];
     NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"{\t\n "];
     for (NSString *key in allKeys) {
         id value= self[key];
         [str appendFormat:@"\t \"%@\" = %@,\n",key, value];
    }
    [str appendString:@"}"];
    return str;
}

@end
