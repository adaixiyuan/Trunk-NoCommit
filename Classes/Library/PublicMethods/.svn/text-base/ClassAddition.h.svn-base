//
//  ClassAddition.h
//  ElongClient
//
//  Created by bruce on 13-9-4.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ClassAddition : NSObject

@end


// =====================================================
// NSDictionary category
// =====================================================
@interface NSDictionary (Utility)

- (id)safeObjectForKey:(id)aKey;

@end


// =====================================================
// NSMutableDictionary category
// =====================================================
@interface NSMutableDictionary (Utility)

// 设置Key/Value
- (void)safeSetObject:(id)anObject forKey:(id < NSCopying >)aKey;

// 为了去除酒店详情重复图片专门定制的方法
- (void)removeRepeatingImage;

@end




// =====================================================
// NSArray category
// =====================================================
@interface NSArray (Utility)

-(id) safeObjectAtIndex:(NSUInteger)index;

@end




// =====================================================
// UIview 扩展
// =====================================================
@interface UIView (Addition)

// 设置UIView的X
- (void)setViewX:(CGFloat)newX;

// 设置UIView的Y
- (void)setViewY:(CGFloat)newY;

// 设置UIView的Origin
- (void)setViewOrigin:(CGPoint)newOrigin;

// 设置UIView的width
- (void)setViewWidth:(CGFloat)newWidth;

// 设置UIView的height
- (void)setViewHeight:(CGFloat)newHeight;

// 设置UIView的Size
- (void)setViewSize:(CGSize)newSize;

@end



// =====================================================
// UIColor 扩展
// =====================================================
@interface UIColor (Utility)

+ (UIColor *)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alpha;

@end


// =====================================================
// 数据解析扩展
// =====================================================
@interface NSObject (Utility)

// 将简单对象转换成Object
- (void)serializeSimpleObject:(NSMutableDictionary *)dictionary;


@end


// =====================================================
// NSString 扩展 数据校验
// =====================================================
@interface NSString (DataCheck)

- (BOOL)checkCityNameValid;


@end


// =====================================================
// UITableView 扩展 
// =====================================================
@interface UITableView (Utility)

- (void)reloadData:(BOOL)animated;


@end


// =====================================================
// UITextField 扩展
// =====================================================
@interface UITextField (Utility)

// 是否可以继续输入
- (BOOL)shouldChangeInRange:(NSRange)range withString:(NSString *)string andLength:(NSInteger)maxLength;

@end

