//
//  NetworkHelper.h
//  SJOnLine
//
//  Created by 金峰 on 2017/5/14.
//  Copyright © 2017年 金峰. All rights reserved.
//

#import <Foundation/Foundation.h> 
#import "NetworkConfig.h"

typedef void(^NetworkFetchComplication)(BOOL succeed,int code, id response, NSError *error);
/// 网络请求基类
@interface NetworkHelper : NSObject

@property (nonatomic, strong, readonly) AFHTTPSessionManager *sessionManager;
@property (nonatomic, assign, readonly) AFNetworkReachabilityStatus reachabilityStatus;

+ (instancetype)shared;

/**
 * 发送一个post请求
 */
- (void)fetchPostWithUrl:(NSString *)url
                  params:(NSDictionary *)params
              modelClass:(Class)cls
       fetchComplication:(NetworkFetchComplication)complication;

/**
 * 发送一个get请求
 */
- (void)fetchGetWithUrl:(NSString *)url
                 params:(NSDictionary *)params
             modelClass:(Class)cls
      fetchComplication:(NetworkFetchComplication)complication;

/**
 * 图片文件夹的名字，默认‘image’
 */
@property (nonatomic, copy) NSString *imageFileName;
- (void)fetchUploadImageWithUrl:(NSString *)url
                    params:(NSDictionary *)params
                    images:(NSArray *)images
         fetchComplication:(NetworkFetchComplication)complication;

/**
 * 判断cookie是否过期
 */
- (BOOL)isSessionValid;
/**
 * 清除固定baseUrl下的所有cookies
 */
- (void)clearCookies;

@end
