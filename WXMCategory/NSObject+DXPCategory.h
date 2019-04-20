//
//  NSObject+DXPCategory.h
//  类库
//
//  Created by Mac on 16/8/26.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface NSObject (DXPCategory)

/** GCD定时器 */
- (dispatch_source_t)startTimingWithInterval:(float)interval backBlock:(BOOL (^)(void))block;


/** runtime替换方法 */
+ (BOOL)swizzleClassMethod:(SEL)originalSel with:(SEL)newSel;    //类方法
+ (BOOL)swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel; //对象方法


/** runtime获取所有属性 */
+ (NSArray *)getFropertys;


/** 绑定 */
- (void)setAssociateValue:(nullable id)value withKey:(void *)key;
- (void)setAssociateWeakValue:(nullable id)value withKey:(void *)key;


/** 获取 */
- (nullable id)getAssociatedValueForKey:(void *)key;


/** kvo block*/
- (void)addObserverBlockForKeyPath:(NSString *)keyPath block:(void (^)(id _Nonnull obj, id _Nonnull oldVal, id _Nonnull newVal))block;
- (void)removeObserverBlocksForKeyPath:(NSString *)keyPath;
- (void)removeObserverBlocks;


/** 解归档 需实现归档协议 */
- (BOOL)archiverWithPath:(NSString *)path;
+ (instancetype)unArchiverWithPath:(NSString *)path;

+ (UINib *)nib;

@end
NS_ASSUME_NONNULL_END
