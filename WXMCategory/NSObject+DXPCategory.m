//
//  NSObject+DXPCategory.m
//  类库
//
//  Created by Mac on 16/8/26.
//  Copyright © 2016年 WQ. All rights reserved.
//
//Library 路径
#define KLibraryboxPath NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject
#define UserData [KLibraryboxPath stringByAppendingPathComponent:@"UserData"]

#import "NSObject+DXPCategory.h"
#import <objc/runtime.h>
static const int block_key;
static char timers;

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
- (dispatch_source_t)startTimingWithInterval:(float)interval backBlock:(BOOL (^)(void))block {
    dispatch_queue_t queue = dispatch_get_main_queue();
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(self.timer, dispatch_walltime(NULL, 0), interval * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(self.timer, ^{
        
        BOOL isStop = block();
        if (block == nil | isStop == NO) {
            dispatch_cancel(self.timer); // 取消定时器
            self.timer = nil;
        }
    });
    dispatch_resume(self.timer);
    return self.timer;
}
/** -方法 */
+ (BOOL)swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel {
    Method originalMethod = class_getInstanceMethod(self, originalSel);
    Method newMethod = class_getInstanceMethod(self, newSel);
    if (!originalMethod || !newMethod) return NO;
    
    class_addMethod(self, originalSel, class_getMethodImplementation(self, originalSel), method_getTypeEncoding(originalMethod));
    class_addMethod(self, newSel, class_getMethodImplementation(self, newSel), method_getTypeEncoding(newMethod));
    method_exchangeImplementations(class_getInstanceMethod(self, originalSel), class_getInstanceMethod(self, newSel));
    return YES;
}

/** +方法 */
+ (BOOL)swizzleClassMethod:(SEL)originalSel with:(SEL)newSel {
    Class class = object_getClass(self);
    Method originalMethod = class_getInstanceMethod(class, originalSel);
    Method newMethod = class_getInstanceMethod(class, newSel);
    if (!originalMethod || !newMethod) return NO;
    method_exchangeImplementations(originalMethod, newMethod);
    return YES;
}

/** 绑定 */
- (void)setAssociateValue:(id)value withKey:(void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setAssociateWeakValue:(id)value withKey:(void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_ASSIGN);
}

- (id)getAssociatedValueForKey:(void *)key {
    return objc_getAssociatedObject(self, key);
}

/**获取所有属性 */
+ (NSArray *)getFropertys {
    unsigned int count = 0;
    NSMutableArray *_arrayM = @[].mutableCopy;
    objc_property_t *propertys = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = propertys[i]; //获得每一个属性
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        [_arrayM addObject:propertyName];
    }
    return _arrayM;
}
- (void)setNilValueForKey:(NSString *)key {}

#pragma mark _____________________________________________________________________KVO

//监听 有block的
- (void)addObserverBlockForKeyPath:(NSString *)keyPath block:(void (^)(__weak id obj, id oldVal, id newVal))block {
    if (!keyPath || !block) return;
    NSObjectKVOBlockTarget *target = [[NSObjectKVOBlockTarget alloc] initWithBlock:block];
    NSMutableDictionary *dic = [self allNSObjectObserverBlocks];
    NSMutableArray *arr = dic[keyPath];
    if (!arr) {
        arr = [NSMutableArray new];
        dic[keyPath] = arr;
    }
    [arr addObject:target];
    [self addObserver:target forKeyPath:keyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
}
//监听的key字典
- (NSMutableDictionary *)allNSObjectObserverBlocks {
    NSMutableDictionary *targets = objc_getAssociatedObject(self, &block_key);
    if (!targets) {
        targets = [NSMutableDictionary new];
        objc_setAssociatedObject(self, &block_key, targets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return targets;
}
//删掉监听的key
- (void)removeObserverBlocksForKeyPath:(NSString *)keyPath {
    if (!keyPath) return;
    NSMutableDictionary *dic = [self allNSObjectObserverBlocks];
    NSMutableArray *arr = dic[keyPath];
    [arr enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        [self removeObserver:obj forKeyPath:keyPath];
    }];
    [dic removeObjectForKey:keyPath];
}
//删掉监听的block
- (void)removeObserverBlocks {
    NSMutableDictionary *dic = [self allNSObjectObserverBlocks];
    [dic enumerateKeysAndObjectsUsingBlock: ^(NSString *key, NSArray *arr, BOOL *stop) {
        [arr enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
            [self removeObserver:obj forKeyPath:key];
        }];
    }];
    [dic removeAllObjects];
}
#pragma mark____________________________________________________________geting
- (void)setTimer:(dispatch_source_t)timer {
    objc_setAssociatedObject(self, &timers, timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (dispatch_source_t)timer {
    return objc_getAssociatedObject(self, &timers);
}


#pragma mark____________________________________________________________解归档 需实现归档协议
#pragma mark____________________________________________________________解归档 需实现归档协议
#pragma mark____________________________________________________________解归档 需实现归档协议


//归档
- (BOOL)archiverWithPath:(NSString *)path {
    BOOL success = NO;
    @try {
        success = [NSKeyedArchiver archiveRootObject:self toFile:[UserData stringByAppendingPathComponent:path]];
    } @catch (NSException *exception) {} @finally {}
    return success;
}

/** 解归档 */
+ (instancetype)unArchiverWithPath:(NSString *)path {
    @try {
        id newFolder = [NSKeyedUnarchiver unarchiveObjectWithFile:[UserData stringByAppendingPathComponent:path]];
        return newFolder;
    } @catch (NSException *exception) {} @finally {}
}

+ (UINib *)nib {
    return [UINib nibWithNibName:NSStringFromClass(self) bundle:nil];
}

@end
