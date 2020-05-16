//
//  WXMClassInfo.h
//  WXMKit <https://github.com/ibireme/WXMKit>
//
//  Created by ibireme on 15/5/9.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

//+ (NSDictionary *)modelCustomPropertyMapper {
//    return @{@"model key" : @"json key" };
//}

//+ (NSDictionary *)modelContainerPropertyGenericClass {
//    return @{@"json key" : [xxModel class]};
//}

#import <objc/runtime.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/** 此类为YYModel 做了一点修改 */
/** 此类为YYModel 做了一点修改 */
/** 此类为YYModel 做了一点修改 */
@interface NSObject (WXMModel)

/** json转模型 */
+ (nullable instancetype)modelWithJSON:(id)json;

#pragma mark 常用
#pragma mark 常用
#pragma mark 常用

/** 字典转模型 */
+ (nullable instancetype)modelWithDictionary:(NSDictionary *)dictionary;

/** json转模型数组 */
+ (NSArray *)modelArrayWithKeyValuesArray:(NSArray<NSDictionary *> *)keyValuesArray;

/** model转字典 */
- (nullable id)modelToJSONObject;

/** 深拷贝 */
- (nullable id)modelCopy;

/** model是否一致 */
- (BOOL)modelIsEqual:(id)model;

/** 是否可以转json */
- (BOOL)modelSetWithJSON:(id)json;
- (BOOL)modelSetWithDictionary:(NSDictionary *)dic;

/** model转data或者json */
- (nullable NSData *)modelToJSONData;
- (nullable NSString *)modelToJSONString;

- (void)modelEncodeWithCoder:(NSCoder *)aCoder;
- (id)modelInitWithCoder:(NSCoder *)aDecoder;

/** model哈希值 */
- (NSUInteger)modelHash;

/** model属性 */
- (NSString *)modelDescription;

@end

@interface NSArray (WXMModel)
+ (nullable NSArray *)modelArrayWithClass:(Class)cls json:(id)json;
@end

@protocol WXMModel <NSObject>
@optional
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper;
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass;
+ (nullable Class)modelCustomClassForDictionary:(NSDictionary *)dictionary;
+ (nullable NSArray<NSString *> *)modelPropertyBlacklist;
+ (nullable NSArray<NSString *> *)modelPropertyWhitelist;
- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic;
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic;
- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic;
@end

typedef NS_OPTIONS(NSUInteger, WXMEncodingType) {
    WXMEncodingTypeMask       = 0xFF,
    WXMEncodingTypeUnknown    = 0,
    WXMEncodingTypeVoid       = 1,
    WXMEncodingTypeBool       = 2,
    WXMEncodingTypeInt8       = 3,
    WXMEncodingTypeUInt8      = 4,
    WXMEncodingTypeInt16      = 5,
    WXMEncodingTypeUInt16     = 6,
    WXMEncodingTypeInt32      = 7,
    WXMEncodingTypeUInt32     = 8,
    WXMEncodingTypeInt64      = 9,
    WXMEncodingTypeUInt64     = 10,
    WXMEncodingTypeFloat      = 11,
    WXMEncodingTypeDouble     = 12,
    WXMEncodingTypeLongDouble = 13,
    WXMEncodingTypeObject     = 14,
    WXMEncodingTypeClass      = 15,
    WXMEncodingTypeSEL        = 16,
    WXMEncodingTypeBlock      = 17,
    WXMEncodingTypePointer    = 18,
    WXMEncodingTypeStruct     = 19,
    WXMEncodingTypeUnion      = 20,
    WXMEncodingTypeCString    = 21,
    WXMEncodingTypeCArray     = 22,
    
    WXMEncodingTypeQualifierMask   = 0xFF00,
    WXMEncodingTypeQualifierConst  = 1 << 8,
    WXMEncodingTypeQualifierIn     = 1 << 9,
    WXMEncodingTypeQualifierInout  = 1 << 10,
    WXMEncodingTypeQualifierOut    = 1 << 11,
    WXMEncodingTypeQualifierBycopy = 1 << 12,
    WXMEncodingTypeQualifierByref  = 1 << 13,
    WXMEncodingTypeQualifierOneway = 1 << 14,
    
    WXMEncodingTypePropertyMask         = 0xFF0000,
    WXMEncodingTypePropertyReadonly     = 1 << 16,
    WXMEncodingTypePropertyCopy         = 1 << 17,
    WXMEncodingTypePropertyRetain       = 1 << 18,
    WXMEncodingTypePropertyNonatomic    = 1 << 19,
    WXMEncodingTypePropertyWeak         = 1 << 20,
    WXMEncodingTypePropertyCustomGetter = 1 << 21,
    WXMEncodingTypePropertyCustomSetter = 1 << 22,
    WXMEncodingTypePropertyDynamic      = 1 << 23,
};

WXMEncodingType WXMEncodingGetType(const char *typeEncoding);
@interface WXMClassIvarInfo : NSObject
@property (nonatomic, assign, readonly) Ivar ivar;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, assign, readonly) ptrdiff_t offset;
@property (nonatomic, strong, readonly) NSString *typeEncoding;
@property (nonatomic, assign, readonly) WXMEncodingType type;
- (instancetype)initWithIvar:(Ivar)ivar;
@end

@interface WXMClassMethodInfo : NSObject
@property (nonatomic, assign, readonly) Method method;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, assign, readonly) SEL sel;
@property (nonatomic, assign, readonly) IMP imp;
@property (nonatomic, strong, readonly) NSString *typeEncoding;
@property (nonatomic, strong, readonly) NSString *returnTypeEncoding;
@property (nullable, nonatomic, strong, readonly) NSArray<NSString *> *argumentTypeEncodings;
- (instancetype)initWithMethod:(Method)method;
@end

@interface WXMClassPropertyInfo : NSObject
@property (nonatomic, assign, readonly) objc_property_t property;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, assign, readonly) WXMEncodingType type;
@property (nonatomic, strong, readonly) NSString *typeEncoding;
@property (nonatomic, strong, readonly) NSString *ivarName;
@property (nullable, nonatomic, assign, readonly) Class cls;
@property (nonatomic, assign, readonly) SEL getter;
@property (nonatomic, assign, readonly) SEL setter;
- (instancetype)initWithProperty:(objc_property_t)property;
@end

@interface WXMClassInfo : NSObject
@property (nonatomic, assign, readonly) Class cls;
@property (nullable, nonatomic, assign, readonly) Class superCls;
@property (nullable, nonatomic, assign, readonly) Class metaCls;
@property (nonatomic, readonly) BOOL isMeta;
@property (nonatomic, strong, readonly) NSString *name;
@property (nullable,nonatomic,strong, readonly) WXMClassInfo *superClassInfo;
@property (nullable,nonatomic,strong) NSDictionary<NSString *,WXMClassIvarInfo *>*ivarInfos;
@property (nullable,nonatomic,strong) NSDictionary<NSString *,WXMClassMethodInfo *>*methodInfos;
@property (nullable,nonatomic,strong) NSDictionary<NSString *,WXMClassPropertyInfo*>*propertyInfos;

- (void)setNeedUpdate;
- (BOOL)needUpdate;
+ (nullable instancetype)classInfoWithClass:(Class)cls;
+ (nullable instancetype)classInfoWithClassName:(NSString *)className;
@end


NS_ASSUME_NONNULL_END
