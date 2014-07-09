//
//  SwizzMethod.m
//  ElongClient
//
//  Created by chenggong on 13-9-27.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "SwizzMethod.h"
#import <objc/objc.h>
#import <objc/runtime.h>
#import <MapKit/MapKit.h>
#import "ButtonClickTracer.h"
#import "CrashCollectionLog.h"
#import "HomeItemView.h"

static void SwizzleSelf(Class c, SEL orig, SEL repl )
{
    Method origMethod = class_getInstanceMethod(c, orig );
    Method newMethod  = class_getInstanceMethod(c, repl );
    
    if(class_addMethod( c, orig, method_getImplementation(newMethod),
                       method_getTypeEncoding(newMethod)) )
        
        class_replaceMethod( c, repl, method_getImplementation(origMethod),
                            method_getTypeEncoding(origMethod) );
    else
        method_exchangeImplementations( origMethod, newMethod );
}

static void Swizzle(Class origClass, Class newClass, SEL orig, SEL repl, SEL add)
{
    Method origMethod = class_getInstanceMethod(origClass, orig);
    Method newMethod  = class_getInstanceMethod(newClass, repl);
    
    if(class_addMethod(origClass, add, method_getImplementation(origMethod), method_getTypeEncoding(origMethod))) {
        class_replaceMethod(origClass, orig, method_getImplementation(newMethod), method_getTypeEncoding(origMethod));
    }
}

@interface UIView (GetItsUIViewController)
- (UIViewController *)viewController;
@end

@implementation UIView (GetItsUIViewController)

- (UIViewController*)viewController {
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}
@end

@interface UIView (touchesEndedDetector)
@end

@implementation  UIView (touchesEndedDetector)
- (void)touchesEndedDetector:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    UIView *clickView = [touch view];
    UIView *logView = [[clickView superview] superview];
    
    NSString *viewClassName = NSStringFromClass([logView class]);
    
    if ([viewClassName isEqualToString:@"UITableViewCellContentView"]) {
        logView = [logView superview];
    }
//    NSLog(@"Touch Ended Class: %@  Superview: %@", NSStringFromClass([logView class]), [logView superview]);
    [[CrashCollectionLog sharedInstance] logTarget:NSStringFromClass([[logView viewController] class]) action:NSStringFromClass([logView class])];
    
    //    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //    NSArray *subViews = [window subviews];
    //    while ([subViews count] != 0) {
    //        NSLog(@"Subviews: %@", subViews);
    //        subViews = [[subViews objectAtIndex:0] subviews];
    //    }
    
    IMP iosEndedTouch = [self methodForSelector:@selector(touchesEndedDetector:withEvent:)];
    iosEndedTouch(self, @selector(touchesEnded:withEvent:), touches, event);
    
}
@end

@interface UIImageView (touchesEndedImageViewDetector)
@end

@implementation  UIImageView (touchesEndedImageViewDetector)
- (void)touchesEndedImageViewDetector:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    UIView *logView = [touch view];
    
    NSString *viewClassName = NSStringFromClass([logView class]);

//    NSLog(@"Touch Ended Class: %@  Superview: %@", viewClassName, [logView superview]);
    [[CrashCollectionLog sharedInstance] logTarget:NSStringFromClass([[logView viewController] class]) action:viewClassName];
    
    IMP iosEndedTouch = [self methodForSelector:@selector(touchesEndedImageViewDetector:withEvent:)];
    iosEndedTouch(self, @selector(touchesEnded:withEvent:), touches, event);
    
}
@end

@interface MKMapView (touchesEndedMKMapViewDetector)
@end

@implementation  MKMapView (touchesEndedMKMapViewDetector)
- (void)touchesEndedMKMapViewDetector:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    UIView *logView = [touch view];
    
    NSString *viewClassName = NSStringFromClass([logView class]);
    
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    NSArray *subViews = [window subviews];
//    while ([subViews count] != 0) {
//        NSLog(@"Subviews: %@", subViews);
//        subViews = [[subViews objectAtIndex:0] subviews];
//    }
    
    //    NSLog(@"Touch Ended Class: %@  Superview: %@", viewClassName, [logView superview]);
    [[CrashCollectionLog sharedInstance] logTarget:NSStringFromClass([[logView viewController] class]) action:viewClassName];
    
    IMP iosEndedTouch = [self methodForSelector:@selector(touchesEndedMKMapViewDetector:withEvent:)];
    iosEndedTouch(self, @selector(touchesEnded:withEvent:), touches, event);
    
}
@end

//- (void) singleTap:(UITapGestureRecognizer *)gesture
@interface HomeItemView (singleTapDetector)
@end

@implementation  HomeItemView (singleTapDetector)
- (void) singleTapDetector:(UITapGestureRecognizer *)gesture
{
    UIView *logView = [gesture view];
    
    NSString *viewClassName = NSStringFromClass([logView class]);
    
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *fileName = @"HomeLayout";
//    NSString *layoutFilePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",fileName]];
//    NSMutableDictionary *layoutDict;
//    
//    if (![[NSFileManager defaultManager] fileExistsAtPath:layoutFilePath]){
//        NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
//        layoutDict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
//    }else{
//        layoutDict = [NSMutableDictionary dictionaryWithContentsOfFile:layoutFilePath];
//        // 校验数据正确性
//        if (!layoutDict || [[layoutDict allKeys] count] == 0) {
//            // 出现文件损坏情况，读取原始配置文件
//            NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
//            layoutDict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
//        }else{
//            // 校验版本，如果发现新版本就读取原始配置文件
//            NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
//            NSMutableDictionary *localDict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
//            float newVersion = [[localDict objectForKey:@"version"] floatValue];
//            float currentVersion = [[layoutDict objectForKey:@"version"] floatValue];
//            if (newVersion > currentVersion) {
//                layoutDict = localDict;
//            }
//        }
//    }
    
    switch (logView.tag) {
        case 1100:{
            viewClassName = @"广告";
        }
            break;
        case 1200:{
            viewClassName = @"酒店";
        }
            break;
        case 1300:{
            viewClassName = @"团购";
        }
            break;
        case 1410:{
            viewClassName = @"机票";
        }
            break;
        case 1420:{
            viewClassName = @"火车票";
        }
            break;
        case 1431:{
            viewClassName = @"个人中心";
        }
            break;
        case 1432:{
            viewClassName = @"客服电话";
        }
            break;
        case 1433:{
            viewClassName = @"添加模块";
        }
            break;
        case 1440:{
            viewClassName = @"航班动态";
        }
            break;
        case 1450:{
            viewClassName = @"旅行清单";
        }
            break;
        case 1460:{
            viewClassName = @"汇率模块";
        }
            break;
        case 1470:{
            viewClassName = @"打车模块";
        }
            break;
        default:
            break;
    }
    
    //    NSLog(@"Touch Ended Class: %@  Superview: %@", viewClassName, [logView superview]);
    [[CrashCollectionLog sharedInstance] logTarget:NSStringFromClass([[logView viewController] class]) action:viewClassName];
    
    IMP iosEndedTouch = [self methodForSelector:@selector(singleTapDetector:)];
    iosEndedTouch(self, @selector(singleTap:), gesture);
    
}
@end

@interface SwizzMethod()

- (void)sendEventSwizz:(SEL)action to:(id)target forEvent:(UIEvent *)event;

@end

@implementation SwizzMethod

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:[CrashCollectionLog sharedInstance] name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    [super dealloc];
}

+ (void)customizeUIButton {
    Swizzle([UIControl class], [self class], @selector(sendAction:to:forEvent:), @selector(swizz_sendAction:to:forEvent:), @selector(sendEventSwizz:to:forEvent:));
}

+ (void)customizeUIView {
    SEL rep = @selector(touchesEndedDetector:withEvent:);
    SEL orig = @selector( touchesEnded:withEvent: );
    SwizzleSelf([UITableViewCell class], orig, rep);
}

+ (void)customizeUIImageView {
    SEL rep = @selector(touchesEndedImageViewDetector:withEvent:);
    SEL orig = @selector( touchesEnded:withEvent: );
    SwizzleSelf([UIImageView class], orig, rep);
}

+ (void)customizeMKMapView {
    SEL rep = @selector(touchesEndedMKMapViewDetector:withEvent:);
    SEL orig = @selector( touchesEnded:withEvent: );
    SwizzleSelf([MKMapView class], orig, rep);
}

+ (void)customizeHomeItemView {
    SEL rep = @selector(singleTapDetector:);
    SEL orig = @selector(singleTap:);
    SwizzleSelf([HomeItemView class], orig, rep);
}

// this method will just excute once
+ (void)initialize
{
    [self customizeUIButton];
    [self customizeUIView];
    [self customizeUIImageView];
    [self customizeMKMapView];
    [self customizeHomeItemView];
    
    // Register UIApplicationDidReceiveMemoryWarningNotification.
    [[NSNotificationCenter defaultCenter] addObserver:[CrashCollectionLog sharedInstance] selector:@selector(handleMemoryWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
}

- (void)swizz_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    [target retain];
    [event retain];
    
    // TODO: Implement tracing button click.
    [[ButtonClickTracer sharedInstance] buttonClickTarget:target action:action];
    
    [self sendEventSwizz:action to:target forEvent:event];
    
    [target release];
    [event release];
}

- (void)sendEventSwizz:(SEL)action to:(id)target forEvent:(UIEvent *)event {
}

@end
