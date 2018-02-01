//
//  Topic.h
//  AutoAnswer
//
//  Created by 金峰 on 2018/1/16.
//  Copyright © 2018年 金峰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Topic : NSObject
/**
 * 11. 以下哪首诗的作者和其他两首不一样？
 */
@property (nonatomic, copy) NSString *title;

/**
 * 三个选项
 
 "《过故人庄》",
 "《宿建德江》",
 "《鹿柴》"
 */
@property (nonatomic, strong) NSArray *answers;
@property (nonatomic, copy) NSString *cd_id;
@property (nonatomic, copy) NSString *channel;
/**
 * "《过故人庄》:-1|《宿建德江》:-1|《鹿柴》:-1"
 */
@property (nonatomic, copy) NSString *choices;
/**
 * off
 */
@property (nonatomic, copy) NSString *debug;
/**
 * "《鹿柴》"
 */
@property (nonatomic, copy) NSString *result;
@property (nonatomic, copy) NSString *uid;
@end
