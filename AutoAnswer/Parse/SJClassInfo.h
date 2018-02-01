//
//  SJClassInfo.h
//  SJOnLine
//
//  Created by 金峰 on 2017/5/14.
//  Copyright © 2017年 金峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SJPropertyInfo.h"

@interface SJClassInfo : NSObject
@property (nonatomic, assign, readonly) Class cls;
@property (nonatomic, copy, readonly)   NSString *clsName;
@property (nonatomic, strong, readonly) NSArray<SJPropertyInfo *> *propertys;

- (instancetype)initWithClass:(Class)cls;
@end
