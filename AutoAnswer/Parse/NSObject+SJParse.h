//
//       ||        | |          ----------
//      |  |       | |          ----------
//     |    |      | |              | |
//    |------|     | |              | |
//   |        |    | |_______       | |
//  |          |   | |_______       | |
//
//  NSObject+SJParse.h
//  SJOnLine
//
//  Created by 金峰 on 2017/5/14.
//  Copyright © 2017年 金峰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (SJParse)

/**
 * json转model
 */
- (void)setModelWithJson:(id)json;

/**
 返回需要映射的key字典，其中‘key’是映射到model中的，‘value’是服务器传过来的

 @return @{@"ID":@"id"}
 */
- (NSDictionary *)replaceKeysForKeys;


/**
 写出存放自定义类对象的那个数组名字，返回该对象的类型，其中'key'是数组的key，‘value’是自定义model的class

 @return @{@"items":}
 */
- (NSDictionary *)classInModelArrayForKeys;

/**
 model中的'key'对应字典中的key(是个关键字)
 - (NSString *)replaceKeyForKey:(NSString *)key {
 if ([key isEqualToString:@"userId"]) {
 return @"id";
 }
 }
 
 @param key 转换后的用户自己命名的key
 @return 服务器返回的需要替换的key，常见如‘id’
 */
- (NSString *)replaceKeyForKey:(NSString *)key __deprecated_msg("Use -replaceKeysForKeys");

/**
 写出存放自定义类对象的那个数组名字，返回该对象的类型
 - (Class)classInModelArrayForKey:(NSString *)key {
 if ([key isEqualToString:@"items"]) {
 return [MyClass class];
 }
 }
 
 @param key 存放自定义model数据的数组
 @return 自定义model的类型
 */
- (Class)classInModelArrayForKey:(NSString *)key __deprecated_msg("Use -classInModelArrayForKeys");
@end
