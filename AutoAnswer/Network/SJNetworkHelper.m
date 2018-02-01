//
//  SJNetworkHelper.m
//  SJOnLine
//
//  Created by 金峰 on 2017/5/27.
//  Copyright © 2017年 金峰. All rights reserved.
//

#import "SJNetworkHelper.h"

@interface SJNetworkHelper ()
@property (nonatomic, copy, readwrite) NSString *lastUrl;
@property (nonatomic, copy, readwrite) NSDictionary *lastParams;
@end

@implementation SJNetworkHelper

- (void)postWithUrl:(NSString *)url params:(NSDictionary *)params modelClass:(Class)cls fetchComplication:(NetworkFetchComplication)complication {
    self.lastUrl = url;
    
    NSMutableDictionary *_params = [NSMutableDictionary dictionaryWithDictionary:params];
    self.lastParams = _params;
    [self fetchPostWithUrl:url params:[_params copy] modelClass:cls fetchComplication:^(BOOL succeed, int code, id response, NSError *error) {
        if (!succeed) {
            DELog(@"网络连接异常，请检查您的网络");
        }
        if ([response isKindOfClass:[NSDictionary class]]) response = response[@"result"];
        !complication ?: complication(succeed, code, response, error);
    }];
}

- (void)getWithUrl:(NSString *)url params:(NSDictionary *)params modelClass:(Class)cls fetchComplication:(NetworkFetchComplication)complication {
    
    NSMutableDictionary *_params = [NSMutableDictionary dictionaryWithDictionary:params];
    
    long t = (long)([NSDate date].timeIntervalSince1970 * 1000);
    [_params setValue:[NSString stringWithFormat:@"jQuery321040853586281720167_%@",@(t)] forKey:@"wdcallback"];
    [_params setValue:@(t) forKey:@"_"];
    self.lastParams = _params;
    [self fetchGetWithUrl:url params:_params modelClass:cls fetchComplication:^(BOOL succeed, int code, id response, NSError *error) {
        if (!succeed) {
            DELog(@"网络连接异常，请检查您的网络");
        }
        if ([response isKindOfClass:[NSDictionary class]]) response = response[@"result"];
        !complication ?: complication(succeed, code, response, error);
    }];
}

@end
