//
//  WXMGeneralMacros.h
//
//  Created by edz on 2019/4/30.
//  Copyright © 2019年 wq. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#ifndef WXMGeneralMacros_h
#define WXMGeneralMacros_h

/** iphoneX */
#define kIPhoneX ({  \
BOOL isPhoneX = NO;  \
if (@available(iOS 11.0, *)) {  \
    isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0; \
} (isPhoneX); })

/** 屏幕frame */
#define kSRect ([UIScreen mainScreen].bounds)
#define kEdgeRect CGRectMake(0, kBarHeight, kSWidth, kSHeight - kBarHeight)
#define kEdgeSafeRect CGRectMake(0, kBarHeight, kSWidth, kSHeight - kNBarHeight - kSafeHeight)

/** 导航栏高度 安全高度 */
#define kBarHeight ((kIPhoneX) ? 88.0f : 64.0f)
#define kSafeHeight ((kIPhoneX) ? 35.0f : 0.0f)
#define kTabbarHeight 49

/** 屏幕宽高 */
#define kSWidth  [UIScreen mainScreen].bounds.size.width
#define kSHeight [UIScreen mainScreen].bounds.size.height
#define kSScale  [UIScreen mainScreen].scale

/** 获取系统版本 */
#define kIOS_Version [[[UIDevice currentDevice] systemVersion] floatValue]
#define kCurrentSystemVersion [[UIDevice currentDevice] systemVersion]

/** 获取当前语言 */
#define kCurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

/** Library 路径 */
#define kLibraryboxPath NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject

/** 强弱引用 */
#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) object##_##weak = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) object##_##weak = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = object##_##weak;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = object##_##weak;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif

/** Window AppDelegate 通知中心和UserDefaults */
#define kWindow [[[UIApplication sharedApplication] delegate] window]
#define kAppDelegate ((AppDelegate *)([UIApplication sharedApplication].delegate))
#define kNotificationCenter [NSNotificationCenter defaultCenter]
#define kUserDefaults [NSUserDefaults standardUserDefaults]

/** 颜色(RGB) */
#define kRGBCOLOR(r, g, b) kRGBACOLOR(r, g, b, 1)
#define kRGBACOLOR(r, g, b, a) [UIColor colorWithRed:(r) / 255.0f green:(g) / 255.0f blue:(b) / 255.0f alpha:a]

/**  16进制颜色(0xFFFFFF) 不用带 0x 和 @"" */
#define kCOLOR_WITH_HEX(hexValue) \
[UIColor colorWith\
Red:((float)((0x##hexValue & 0xFF0000) >> 16)) / 255.0 \
green:((float)((0x##hexValue & 0xFF00) >> 8)) / 255.0 \
blue:((float)(0x##hexValue & 0xFF)) / 255.0 alpha:1.0f]

/** 随机颜色 */
#define KRandomColor  [UIColor \
colorWithRed:((CGFloat) random() / (CGFloat) RAND_MAX) \
green:((CGFloat) random() / (CGFloat) RAND_MAX) \
blue:((CGFloat) random() / (CGFloat) RAND_MAX) \
alpha:1.0];

/** 获取当前系统时间戳 */
#define kGetCurentTime [NSString stringWithFormat:@"%zd", (long)[[NSDate date] timeIntervalSince1970]]

/*! 复制文字内容 */
#define kCopyContent(aString) [[UIPasteboard generalPasteboard] setString:aString]

/** 空对象 */
#define kEmptyObject(object) (object == nil \
|| [object isKindOfClass:[NSNull class]] \
|| ([object respondsToSelector:@selector(length)] && [(NSData *)object length] == 0) \
|| ([object respondsToSelector:@selector(count)] && [(NSArray *)object count] == 0)) \
|| ([object respondsToSelector:@selector(allKeys)] && \
[[(NSDictionary *)object allKeys] count] == 0))

/** 角度转弧度 */
#define kDegreesToRadian(x) (M_PI * (x) / 180.0)

/** 弧度转角度 */
#define kRadianToDegrees(radian) (radian * 180.0)/(M_PI)

/** 通知 */
#define wd_postNotification(name, object) \
[[NSNotificationCenter defaultCenter] postNotificationName:name object:object];

#define wd_addNotificationObserver(target, sel, name) \
[[NSNotificationCenter defaultCenter] addObserver:target selector:sel name:name object:nil];

/** 打印 */
#ifdef DEBUG
#define kFormatLog(FORMAT, ...)           \
fprintf(stderr, "%s  %d行 ------>:\t%s\n", \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], \
__LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

#define kNSLog(...) kFormatLog(@"%@", kMASBoxValue(__VA_ARGS__));
#else
#define kFormatLog(FORMAT, ...) nil;
#define kNSLog(...) nil;
#endif

#define kMASBoxValue(value) aMASBoxValue(@encode(__typeof__(value)), (value))
#define kiOS9 [[UIDevice currentDevice] systemVersion].floatValue >= 9.0
#define kiOS10 [[UIDevice currentDevice] systemVersion].floatValue >= 10.0
#define kiOS11 [[UIDevice currentDevice] systemVersion].floatValue >= 11.0
#define kIphone5 (CGRectGetHeight([UIScreen mainScreen].bounds) == 568.0)
#define kIPhone6 (CGRectGetHeight([UIScreen mainScreen].bounds) == 667.0)
#define kIPhone6P ([UIScreen mainScreen].bounds.size.width > 400.0)

/** 线程 */
static inline void wd_dispatch_async_on_main_queue(void (^block)(void)) {
    dispatch_async(dispatch_get_main_queue(), block);
}

static inline void wd_dispatch_async_on_global_queue(void (^block)(void)) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}

static inline void wd_dispatch_after_main_queue(CGFloat delay, void (^block)(void)) {
    dispatch_queue_t queue = dispatch_get_main_queue();
    int64_t delay64 = (int64_t)(delay * NSEC_PER_SEC);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay64), queue, block);
}

/** block */
typedef void (^kVoidBlockDefine)(void);
typedef BOOL (^kBoolBlockDefine)(void);
typedef int  (^kIntBlockDefine) (void);
typedef id   (^kIdBlockDefine)  (void);

typedef void (^kVoidBlockDefineInt)(int index);
typedef BOOL (^kBoolBlockDefineInt)(int index);
typedef int  (^kIntBlockDefineInt) (int index);
typedef id   (^kIdBlockDefineInt)  (int index);

typedef void (^kVoidBlockDefineString)(NSString *aString);
typedef BOOL (^kBoolBlockDefineString)(NSString *aString);
typedef int  (^kIntBlockDefineString) (NSString *aString);
typedef id   (^kIdBlockDefineString)  (NSString *aString);

typedef void (^kVoidBlockDefineId)(id obj);
typedef BOOL (^kBoolBlockDefineId)(id obj);
typedef int  (^kIntBlockDefineId) (id obj);
typedef id   (^kIdBlockDefineId)  (id obj);

/**  执行回调 */
#define kBlock_exec(block, ...) if (block) { block(__VA_ARGS__); }

/**  判断string */
#define kEqualString(aString, bString)  [aString isEqualToString:bString]

/** 获取区间 kMin_Max(3, 4, 5) */
#define kMin_Max(Mix, Pa, Max) MAX(Mix, MIN(Pa, Max))

/** 用safari打开URL */
#define kSafariOpen(aString) NSURL *URL = [NSURL URLWithString:aString]; \
if (@available(iOS 10.0, *)) { \
    [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:nil]; \
} else {  \
[[UIApplication sharedApplication] openURL:URL];  \
}
/**  跳转到设置 */
#define kOpenSetting() kSafariOpen(UIApplicationOpenSettingsURLString);

/** 将括号内的类型转化成id类型 */
static inline id aMASBoxValue(const char *type, ...) {
    va_list v;
    va_start(v, type);
    id obj = nil;
    if (strcmp(type, @encode(id)) == 0) {
        id actual = va_arg(v, id);
        obj = actual;
    } else if (strcmp(type, @encode(CGPoint)) == 0) {
        CGPoint actual = (CGPoint)va_arg(v, CGPoint);
        obj = [NSValue value:&actual withObjCType:type];
    } else if (strcmp(type, @encode(CGSize)) == 0) {
        CGSize actual = (CGSize)va_arg(v, CGSize);
        obj = [NSValue value:&actual withObjCType:type];
    } else if (strcmp(type, @encode(double)) == 0) {
        double actual = (double)va_arg(v, double);
        obj = [NSNumber numberWithDouble:actual];
    } else if (strcmp(type, @encode(float)) == 0) {
        float actual = (float)va_arg(v, double);
        obj = [NSNumber numberWithFloat:actual];
    } else if (strcmp(type, @encode(int)) == 0) {
        int actual = (int)va_arg(v, int);
        obj = [NSNumber numberWithInt:actual];
    } else if (strcmp(type, @encode(long)) == 0) {
        long actual = (long)va_arg(v, long);
        obj = [NSNumber numberWithLong:actual];
    } else if (strcmp(type, @encode(long long)) == 0) {
        long long actual = (long long)va_arg(v, long long);
        obj = [NSNumber numberWithLongLong:actual];
    } else if (strcmp(type, @encode(short)) == 0) {
        short actual = (short)va_arg(v, int);
        obj = [NSNumber numberWithShort:actual];
    } else if (strcmp(type, @encode(char)) == 0) {
        char actual = (char)va_arg(v, int);
        obj = [NSNumber numberWithChar:actual];
    } else if (strcmp(type, @encode(bool)) == 0) {
        bool actual = (bool)va_arg(v, int);
        obj = [NSNumber numberWithBool:actual];
    } else if (strcmp(type, @encode(unsigned char)) == 0) {
        unsigned char actual = (unsigned char)va_arg(v, unsigned int);
        obj = [NSNumber numberWithUnsignedChar:actual];
    } else if (strcmp(type, @encode(unsigned int)) == 0) {
        unsigned int actual = (unsigned int)va_arg(v, unsigned int);
        obj = [NSNumber numberWithUnsignedInt:actual];
    } else if (strcmp(type, @encode(unsigned long)) == 0) {
        unsigned long actual = (unsigned long)va_arg(v, unsigned long);
        obj = [NSNumber numberWithUnsignedLong:actual];
    } else if (strcmp(type, @encode(unsigned long long)) == 0) {
        unsigned long long actual = (unsigned long long)va_arg(v, unsigned long long);
        obj = [NSNumber numberWithUnsignedLongLong:actual];
    } else if (strcmp(type, @encode(unsigned short)) == 0) {
        unsigned short actual = (unsigned short)va_arg(v, unsigned int);
        obj = [NSNumber numberWithUnsignedShort:actual];
    }
    va_end(v);
    return obj;
}

/** 归档解归档 */
#define kSERIALIZE_CODER_DECODER()     \
\
- (id)initWithCoder:(NSCoder *)coder    \
{   \
Class cls = [self class];   \
while (cls != [NSObject class]) {   \
BOOL bIsSelfClass = (cls == [self class]);  \
unsigned int iVarCount = 0; \
unsigned int propVarCount = 0;  \
unsigned int sharedVarCount = 0;    \
Ivar *ivarList = bIsSelfClass ? class_copyIvarList([cls class], &iVarCount) : NULL; \
objc_property_t *propList = bIsSelfClass ? NULL : class_copyPropertyList(cls, &propVarCount);  \
sharedVarCount = bIsSelfClass ? iVarCount : propVarCount;   \
\
for (int i = 0; i < sharedVarCount; i++) {  \
const char *varName = bIsSelfClass ? ivar_getName(*(ivarList + i)) : property_getName(*(propList + i)); \
NSString *key = [NSString stringWithUTF8String:varName];   \
id varValue = [coder decodeObjectForKey:key];   \
if (varValue) { \
[self setValue:varValue forKey:key];    \
}   \
}   \
free(ivarList); \
free(propList); \
cls = class_getSuperclass(cls); \
}   \
return self;    \
}   \
\
- (void)encodeWithCoder:(NSCoder *)coder    \
{   \
Class cls = [self class];   \
while (cls != [NSObject class]) {   \
BOOL bIsSelfClass = (cls == [self class]);  \
unsigned int iVarCount = 0; \
unsigned int propVarCount = 0;  \
unsigned int sharedVarCount = 0;    \
Ivar *ivarList = bIsSelfClass ? class_copyIvarList([cls class], &iVarCount) : NULL; \
objc_property_t *propList = bIsSelfClass ? NULL : class_copyPropertyList(cls, &propVarCount);\
sharedVarCount = bIsSelfClass ? iVarCount : propVarCount;   \
\
for (int i = 0; i < sharedVarCount; i++) {  \
const char *varName = bIsSelfClass ? ivar_getName(*(ivarList + i)) : property_getName(*(propList + i)); \
NSString *key = [NSString stringWithUTF8String:varName];    \
id varValue = [self valueForKey:key];   \
if (varValue) { \
[coder encodeObject:varValue forKey:key];   \
}   \
}   \
free(ivarList); \
free(propList); \
cls = class_getSuperclass(cls); \
}   \
}
#endif /* WXMGeneralMacros_h */

