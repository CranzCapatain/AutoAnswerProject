//
//  SJNetworkHelper.h
//  SJOnLine
//
//  Created by 金峰 on 2017/5/27.
//  Copyright © 2017年 金峰. All rights reserved.
//

#import "NetworkHelper.h"

/// 网络管理类：短链接
@interface SJNetworkHelper : NetworkHelper

/**
 * 最近请求的一条url
 */
@property (nonatomic, copy, readonly) NSString *lastUrl;
@property (nonatomic, copy, readonly) NSDictionary *lastParams;

- (void)postWithUrl:(NSString *)url
             params:(NSDictionary *)params
         modelClass:(Class)cls
  fetchComplication:(NetworkFetchComplication)complication;

- (void)getWithUrl:(NSString *)url
            params:(NSDictionary *)params
        modelClass:(Class)cls
 fetchComplication:(NetworkFetchComplication)complication;


@end
