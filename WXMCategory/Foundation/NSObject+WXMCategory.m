//
//  NSObject+DXPCategory.m
//  类库
//
//  Created by Mac on 16/8/26.
//  Copyright © 2016年 WQ. All rights reserved.
//
//Library 路径
#define KLibraryboxPath \
NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject
#define kUserData [KLibraryboxPath stringByAppendingPathComponent:@"UserData"]
#import "NSObject+WXMCategory.h"
#import <objc/runtime.h>

static const int block_key;
static char holdTimerKey;

@interface NSObjectKVOBlockTarget : NSObject
@property (nonatomic, copy) void (^block)(__weak id obj, id oldVal, id newVal);
@end

@implementation NSObjectKVOBlockTarget

- (id)initWithBlock:(void (^)(__weak id obj, id oldVal, id newVal))block {
    self = [super init];
    if (self) self.block = block;
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (!self.block) return;
    BOOL isPrior = [[change objectForKey:NSKeyValueChangeNotificationIsPriorKey] boolValue];
    if (isPrior) return;
    
    NSKeyValueChange changeKind = [[change objectForKey:NSKeyValueChangeKindKey] integerValue];
    if (changeKind != NSKeyValueChangeSetting) return;
    
    id oldVal = [change objectForKey:NSKeyValueChangeOldKey];
    if (oldVal == [NSNull null]) oldVal = nil;
    
    id newVal = [change objectForKey:NSKeyValueChangeNewKey];
    if (newVal == [NSNull null]) newVal = nil;
    self.block(object, oldVal, newVal);
}
@end

@implementation NSObject (DXPCategory)

/** GCD定时器 */
- (dispatch_source_t)wc_startTimingInterval:(float)interval countdown:(BOOL(^)(void))countdown {
    if (countdown == nil) return nil;
    __weak typeof(self) weakSelf = self;
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_time_t start = dispatch_walltime(NULL, 0);
    
    self.holdTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(self.holdTimer, start, interval * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(self.holdTimer, ^{
        if (countdown() == NO) [weakSelf wc_stopTiming];
    });
    dispatch_resume(self.holdTimer);
    return self.holdTimer;
}

- (dispatch_source_t)wc_startTimingInterval:(float)interval
                                  addTarget:(id)target
                                     action:(SEL)action {
    if (target == nil || action == nil) return nil;
    __weak typeof(self) weakTarget = target;
    dispatch_queue_t queue = dispatch_get_main_queue();
    self.holdTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(self.holdTimer, dispatch_walltime(NULL, 0), interval * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(self.holdTimer, ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
#pragma clang diagnostic ignored "-Wundeclared-selector"
        [weakTarget performSelector:action];
#pragma clang diagnostic pop
    });
    dispatch_resume(self.holdTimer);
    return self.holdTimer;
}

- (void)wc_stopTiming {
    @try {
        
        if (self.holdTimer) {
            dispatch_cancel(self.holdTimer);
            self.holdTimer = nil;
        }
        
    } @catch (NSException *exception) { } @finally { }
}

/** -方法 */
+ (BOOL)wc_swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel {
    Method original = class_getInstanceMethod(self, originalSel);
    Method newMethod = class_getInstanceMethod(self, newSel);
    if (!original || !newMethod) return NO;
    
    IMP originalImp = class_getMethodImplementation(self, originalSel);
    IMP newMethodImp = class_getMethodImplementation(self, newSel);
    class_addMethod(self, originalSel, originalImp, method_getTypeEncoding(original));
    class_addMethod(self, newSel, newMethodImp, method_getTypeEncoding(newMethod));
    method_exchangeImplementations(class_getInstanceMethod(self, originalSel),
                                   class_getInstanceMethod(self, newSel));
    return YES;
}

/** +方法 */
+ (BOOL)wc_swizzleClassMethod:(SEL)originalSel with:(SEL)newSel {
    Class class = object_getClass(self);
    Method originalMethod = class_getInstanceMethod(class, originalSel);
    Method newMethod = class_getInstanceMethod(class, newSel);
    if (!originalMethod || !newMethod) return NO;
    method_exchangeImplementations(originalMethod, newMethod);
    return YES;
}

/** 绑定 */
- (void)wc_setAssociateValue:(id)value withKey:(void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)wc_setAssociateWeakValue:(id)value withKey:(void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_ASSIGN);
}

/** 获取 */
- (id)wc_getAssociatedValueForKey:(void *)key {
    return objc_getAssociatedObject(self, key);
}

/** 获取所有属性 */
+ (NSArray *)wc_getFropertys {
    unsigned int count = 0;
    NSMutableArray *_arrayM = @[].mutableCopy;
    objc_property_t *propertys = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = propertys[i]; /** 获得每一个属性 */
        NSString *pro = [NSString stringWithCString:property_getName(property)
                                           encoding:NSUTF8StringEncoding];
        [_arrayM addObject:pro];
    }
    return _arrayM;
}

#pragma mark _____________________________________________________________________KVO

/** 监听 有block的 */
- (void)wc_addObserverBlockForKeyPath:(NSString *)keyPath
                                block:(void(^)(id obj,id oldVal,id newVal))block {
    if (!keyPath || !block) return;
    NSObjectKVOBlockTarget *target = [[NSObjectKVOBlockTarget alloc] initWithBlock:block];
    NSMutableDictionary *dic = [self allNSObjectObserverBlocks];
    NSMutableArray *arr = dic[keyPath];
    if (!arr) {
        arr = [NSMutableArray new];
        dic[keyPath] = arr;
    }
    [arr addObject:target];
    [self addObserver:target
           forKeyPath:keyPath
              options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
              context:NULL];
}

/** 监听的key字典 */
- (NSMutableDictionary *)allNSObjectObserverBlocks {
    NSMutableDictionary *targets = objc_getAssociatedObject(self, &block_key);
    if (!targets) {
        targets = [NSMutableDictionary new];
        objc_setAssociatedObject(self, &block_key, targets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return targets;
}

/** 删掉监听的key */
- (void)wc_removeObserverBlocksForKeyPath:(NSString *)keyPath {
    if (!keyPath) return;
    NSMutableDictionary *dic = [self allNSObjectObserverBlocks];
    NSMutableArray *arr = dic[keyPath];
    [arr enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        [self removeObserver:obj forKeyPath:keyPath];
    }];
    [dic removeObjectForKey:keyPath];
}

/** 删掉监听的block */
- (void)wc_removeObserverBlocks {
    NSMutableDictionary *dic = [self allNSObjectObserverBlocks];
    [dic enumerateKeysAndObjectsUsingBlock: ^(NSString *key, NSArray *arr, BOOL *stop) {
        [arr enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
            [self removeObserver:obj forKeyPath:key];
        }];
    }];
    [dic removeAllObjects];
}

#pragma mark____________________________________________________________geting

- (void)setHoldTimer:(dispatch_source_t)holdTimer {
    objc_setAssociatedObject(self, &holdTimerKey, holdTimer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (dispatch_source_t)holdTimer {
    return objc_getAssociatedObject(self, &holdTimerKey);
}

#pragma mark____________________________________ 解归档 需实现归档协议

/** 归档 */
- (BOOL)wc_archiverWithPath:(NSString *)path {
    BOOL success = NO;
    @try {
        path = [kUserData stringByAppendingPathComponent:path];
        success = [NSKeyedArchiver archiveRootObject:self toFile:path];
    } @catch (NSException *exception) {} @finally {}
    return success;
}

/** 解归档 */
+ (instancetype)wc_unArchiverWithPath:(NSString *)path {
    @try {
        path = [kUserData stringByAppendingPathComponent:path];
        id newFolder = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        return newFolder;
    } @catch (NSException *exception) {} @finally {}
}

+ (UINib *)wc_nib {
    return [UINib nibWithNibName:NSStringFromClass(self) bundle:nil];
}

- (void)setNilValueForKey:(NSString *)key {}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}
- (instancetype)deepsCopy {
    NSObject *object = [[self class] new];
    [[[self class] wc_getFropertys] enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        if (key) {
            @try {
                id value = [self valueForKey:key];
                if (key && value) [object setValue:value forKey:key];
            } @catch (NSException *exception) {} @finally {}
        }
    }];
    return object;
}

/** 打印model的值 */
- (NSString *)debugDescription {
    if ([self isKindOfClass:[NSArray class]] || [self isKindOfClass:[NSDictionary class]] || [self isKindOfClass:[NSString class]] || [self isKindOfClass:[NSNumber class]]) {
        return [self debugDescription];
    }
   
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    uint count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i<count; i++) {
        objc_property_t property = properties[i];
        NSString *name = @(property_getName(property));
        id value = [self valueForKey:name]?:@"nil";
        [dictionary setObject:value forKey:name];
    }
    
    free(properties);
    return [NSString stringWithFormat:@"<%@: %p> -- %@",[self class],self, dictionary];
}

- (NSDictionary *)debugAllKeyValue {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    uint count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i<count; i++) {
        objc_property_t property = properties[i];
        NSString *name = @(property_getName(property));
        id value = [self valueForKey:name]?:@"nil";
        [dictionary setObject:value forKey:name];
    }
    free(properties);
    return dictionary;
}
@end
