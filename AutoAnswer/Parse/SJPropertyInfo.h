//
//  SJPropertyInfo.h
//  SJOnLine
//
//  Created by 金峰 on 2017/5/14.
//  Copyright © 2017年 金峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

typedef NS_ENUM(int, SJObjectEncodingType) {
    SJObjectEncodingTypeUnknown,
    SJObjectEncodingTypeCustom,
    /**
     * 基本数据类型
     */
    SJObjectEncodingTypeBasicData,
    SJObjectEncodingTypeNSArray,
    SJObjectEncodingTypeNSMutableArray,
    SJObjectEncodingTypeNSString,
    SJObjectEncodingTypeNSMutableString,
    SJObjectEncodingTypeNSDictionary,
    SJObjectEncodingTypeNSMutableDictionary,
    SJObjectEncodingTypeNSSet,
    SJObjectEncodingTypeNSMutableSet,
    SJObjectEncodingTypeNSData,
    SJObjectEncodingTypeNSMutableData,
    SJObjectEncodingTypeNSNumber,
};

typedef NS_ENUM(int, SJPropertyEncodingType) {
    /**
     * 类型不知
     */
    SJPropertyEncodingTypeUnknown,
    /**
     * '@': id/object
     */
    SJPropertyEncodingTypeId,
    /**
     * 'i': int
     */
    SJPropertyEncodingTypeInt,
    /**
     * 'l': long int
     */
    SJPropertyEncodingTypeLInt,
    /**
     * 'q': long long int
     */
    SJPropertyEncodingTypeLLInt,
    /**
     * 'I': uint
     */
    SJPropertyEncodingTypeUInt,
    /**
     * 'L': ulong
     */
    SJPropertyEncodingTypeULInt,
    /**
     * 'Q': ll
     */
    SJPropertyEncodingTypeULLInt,
    /**
     * 'c': char
     */
    SJPropertyEncodingTypeChar,
    /**
     * 'C': uchar
     */
    SJPropertyEncodingTypeUChar,
    /**
     * '#': class
     */
    SJPropertyEncodingTypeClass,
    /**
     * ':': SEL
     */
    SJPropertyEncodingTypeSel,
    /**
     * 's': short
     */
    SJPropertyEncodingTypeShort,
    /**
     * 'S': ushort
     */
    SJPropertyEncodingTypeUShort,
    /**
     * 'f': float
     */
    SJPropertyEncodingTypeFloat,
    /**
     * 'd': double
     */
    SJPropertyEncodingTypeDouble,
    /**
     * 'B': BOOL
     */
    SJPropertyEncodingTypeBool,
    /**
     * '{': struct_b
     */
    SJPropertyEncodingTypeStructB,
    /**
     * '}': struct_e
     */
    SJPropertyEncodingTypeStructE,
    /**
     * '(': union_b
     */
    SJPropertyEncodingTypeUnionB,
    /**
     * ')': union_e
     */
    SJPropertyEncodingTypeUnionE,
};

@interface SJPropertyInfo : NSObject
@property (nonatomic, assign, readonly) objc_property_t property_t;
/**
 * 属性的名字
 */
@property (nonatomic, copy, readonly)   NSString *key;
@property (nonatomic, assign, readonly) SJPropertyEncodingType type;
@property (nonatomic, assign, readonly) SJObjectEncodingType objType;
/**
 * 当这个属性的类型是自定义的时候，这个‘customCls’将有值
 */
@property (nonatomic, assign, readonly) Class customCls;

- (instancetype)initWithProperty:(objc_property_t)property;
@end
