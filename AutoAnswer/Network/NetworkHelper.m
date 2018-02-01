//
//  NetworkHelper.m
//  SJOnLine
//
//  Created by 金峰 on 2017/5/14.
//  Copyright © 2017年 金峰. All rights reserved.
//

#import "NetworkHelper.h"
#import "NSObject+SJParse.h"

@interface NetworkHelper ()
@property (nonatomic, strong, readwrite) AFHTTPSessionManager *sessionManager;
@property (nonatomic, assign, readwrite) AFNetworkReachabilityStatus reachabilityStatus;
@end

@implementation NetworkHelper

+ (instancetype)shared {
    static NetworkHelper *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initWithSession];
    });
    return instance;
}

- (instancetype)initWithSession {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    NSString *baseUrl;
    if (Request_Port.length) {
        baseUrl = [NSString stringWithFormat:@"http://%@:%@",Request_Host, Request_Port];
    } else {
        baseUrl = [NSString stringWithFormat:@"http://%@",Request_Host];
    }
    
    _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseUrl]];
    _sessionManager.requestSerializer.timeoutInterval = 10.f;
    _sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [self absoluteReachabilityStatus];
    
    _imageFileName = @"image";
    
    return self;
}

- (void)fetchPostWithUrl:(NSString *)url
                  params:(NSDictionary *)params
              modelClass:(Class)cls
       fetchComplication:(NetworkFetchComplication)complication {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [self.sessionManager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
            NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            int code = [responseDic[@"code"] intValue];
            DELog(@"请求接口：%@,\n参数：%@,\nResponse：%@",url,params,responseDic);
            if (complication) {
                if (!cls) {
                    complication(YES, code, responseDic, nil);
                } else {
                    if (code == 0) {
                        id data = responseDic[@"result"];
                        if ([data isKindOfClass:[NSDictionary class]]) {
                            id obj = [[cls alloc] init];
                            [obj setModelWithJson:(NSDictionary *)data];
                            complication(YES, code, obj, nil);
                        } else if ([data isKindOfClass:[NSArray class]]) {
                            NSArray *items = (NSArray *)data;
                            NSMutableArray *mutItems = [NSMutableArray arrayWithCapacity:items.count];
                            for (NSDictionary *dic in items) {
                                id obj = [[cls alloc] init];
                                [obj setModelWithJson:dic];
                                [mutItems addObject:obj];
                            }
                            complication(YES, code, [mutItems copy], nil);
                        }
                    } else {
                        complication(YES, code, responseDic, nil);
                    }
                }
            }
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
            NSString *requestUrl = task.currentRequest.URL.absoluteString;
            NSString *errMessage = [NSString stringWithFormat:@"Http请求发生未知错误===> url:%@\n parmas:%@\n response:%@\n",requestUrl,params,task.response];
            DELog(@"%@",errMessage);
            complication(NO, -1, nil, error);
        });
    }];
}

- (void)fetchGetWithUrl:(NSString *)url
                 params:(NSDictionary *)params
             modelClass:(Class)cls
      fetchComplication:(NetworkFetchComplication)complication {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    // 伪装请求头
    [self.sessionManager.requestSerializer setValue:kHTTP_HEADER_User_Agent forHTTPHeaderField:@"User-Agent"];
    [self.sessionManager.requestSerializer setValue:kHTTP_HEADER_Referer forHTTPHeaderField:@"Referer"];
    
    [self.sessionManager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
            NSString *dataString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSString *headerBack = params[@"wdcallback"];
            NSString *cutHeader = [dataString substringFromIndex:headerBack.length + 1];
            NSString *cutFooter = [cutHeader substringToIndex:cutHeader.length - 1];
            
            NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:[cutFooter dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
            int code = [responseDic[@"code"] intValue];
            
            DELog(@"请求接口：%@,\n参数：%@,\nResponse：%@",task.currentRequest.URL.absoluteString,params,responseDic);
            
            if (complication) {
                if (!cls) {
                    complication(YES, code, responseDic, nil);
                } else {
                    if (code == 0) {
                        id data = responseDic[@"result"];
                        if ([data isKindOfClass:[NSDictionary class]]) {
                            id obj = [[cls alloc] init];
                            [obj setModelWithJson:(NSDictionary *)data];
                            complication(YES, code, obj, nil);
                        } else if ([data isKindOfClass:[NSArray class]]) {
                            NSArray *items = (NSArray *)data;
                            NSMutableArray *mutItems = [NSMutableArray arrayWithCapacity:items.count];
                            for (id res in items) {
                                if ([res isKindOfClass:[NSDictionary class]]) {
                                    id obj = [[cls alloc] init];
                                    [obj setModelWithJson:(NSDictionary *)res];
                                    [mutItems addObject:obj];
                                } else if ([res isKindOfClass:[NSString class]]) {
                                    NSString *str = (NSString *)res;
                                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
                                    id obj = [[cls alloc] init];
                                    [obj setModelWithJson:dic];
                                    [mutItems addObject:obj];
                                } else {
                                    complication(YES, code, responseDic, nil);
                                }
                            }
                            complication(YES, code, [mutItems copy], nil);
                        }
                    } else {
                        complication(YES, code, responseDic, nil);
                    }
                }
            }
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
            NSString *requestUrl = task.currentRequest.URL.absoluteString;
            NSString *errMessage = [NSString stringWithFormat:@"Http请求发生未知错误===> url:%@\n parmas:%@\n response:%@\n",requestUrl,params,task.response];
            DELog(@"%@",errMessage);
            complication(NO, -1, nil, error);
        });
    }];
}

- (void)fetchUploadImageWithUrl:(NSString *)url params:(NSDictionary *)params images:(NSArray *)images fetchComplication:(NetworkFetchComplication)complication {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    __weak typeof(self) weakSelf = self;
    [self.sessionManager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *dateString = [formatter stringFromDate:date];
        for (int i = 0;i < images.count;i++) {
            id imgObj = images[i];
            NSData *imageData;
            NSString *fileName;
            if ([imgObj isKindOfClass:[NSData class]]) {
                imageData = (NSData *)imgObj;
            } else if ([imgObj isKindOfClass:[NSString class]]) {
                imageData = [[NSData alloc] initWithContentsOfFile:imgObj];
            } else {
                imageData = UIImageJPEGRepresentation((UIImage *)imgObj, 1.0);
                fileName = [NSString stringWithFormat:@"%@_%d.jpg",dateString, i];
            }
            
            if (!imageData) {
                DELog(@"第%d张图片上传失败！可能的原因：不存在或在转换成data的时候出现问题！",i);
                continue;
            }
            [formData appendPartWithFileData:imageData name:weakSelf.imageFileName fileName:fileName mimeType:@"image/jpg"];
        }
        weakSelf.imageFileName = @"image";
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
            NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            int code = [responseDic[@"code"] intValue];
            DELog(@"图片上传成功!\n请求接口：%@,\n参数：%@,\nResponse：%@",url,params,responseDic);
            if (complication) {
                complication(YES, code, responseDic, nil);
            }
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
            NSString *requestUrl = task.currentRequest.URL.absoluteString;
            NSString *errMessage = [NSString stringWithFormat:@"Http请求发生未知错误===> url:%@\n parmas:%@\n response:%@\n",requestUrl,params,task.response];
            DELog(@"%@",errMessage);
            complication(NO, -1, nil, error);
        });
    }];
}

- (void)absoluteReachabilityStatus {
    __weak typeof(self) weakSelf = self;
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {

        weakSelf.reachabilityStatus = status;
        
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:            // 未知网络
                DELog(@"## 未知网络 ##");
                break;
                
            case AFNetworkReachabilityStatusNotReachable:       // 没有网络(断网)
                DELog(@"## 没有网络 ##");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:   // 手机自带网络
                DELog(@"## 蜂窝网络 ##");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:   // WIFI
                DELog(@"## WIFI ##");
                break;
        }
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (BOOL)isSessionValid {
    NSURL *url = self.sessionManager.baseURL;
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:url];
    
    for (NSHTTPCookie *cookie in cookies) {
        if ([cookie.name isEqualToString:@"ci_session"/* 此处填写与服务器约定的session名字*/] && (cookie.expiresDate.timeIntervalSinceNow > 0)) {
            return YES;
        }
    }
    return NO;
}
// 清除cookie
- (void)clearCookies {
    NSURL *url = self.sessionManager.baseURL;
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:url];
    
    for (NSHTTPCookie *cookie in cookies) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
}

@end
