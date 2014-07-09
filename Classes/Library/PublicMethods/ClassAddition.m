//
//  ClassAddition.m
//  ElongClient
//
//  Created by bruce on 13-9-4.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "ClassAddition.h"
#import <Foundation/NSObjCRuntime.h>
#import <objc/runtime.h>

@implementation ClassAddition

@end



@implementation NSDictionary (Utility)

- (id)safeObjectForKey:(id)aKey
{
    if ([self isKindOfClass:[NSDictionary class]] &&
        ([self objectForKey:aKey] != nil))
    {
		return [self objectForKey:aKey];
    }
    
    return nil;
}

@end




@implementation NSMutableDictionary (Utility)

// 设置Key/Value
- (void)safeSetObject:(id)anObject forKey:(id < NSCopying >)aKey
{
	if(anObject != nil)
	{
		[self setObject:anObject forKey:aKey];
	}
}


- (void)removeRepeatingImage
{
    NSArray *imageItems = [self safeObjectForKey:HOTEL_IMAGE_ITEMS];
    NSMutableArray *images = [NSMutableArray array];
    NSString *imgPath = nil;
    
    for (NSDictionary *dic in imageItems)
    {
        if (![[dic safeObjectForKey:IMAGE_PATH] isEqualToString:imgPath])
        {
            // 重复的url不添加
            [images addObject:dic];
            imgPath = [NSString stringWithFormat:@"%@", [dic safeObjectForKey:IMAGE_PATH]];
        }
    }
    
    [self safeSetObject:images forKey:HOTEL_IMAGE_ITEMS];
}

@end




@implementation NSArray (Utility)

-(id) safeObjectAtIndex:(NSUInteger)index
{
    if (index >= self.count) {
        return nil;
    }
    return [self objectAtIndex:index];
}

@end


// UIView 扩展
@implementation UIView (Utility)

// 设置UIView的X
- (void)setViewX:(CGFloat)newX
{
	CGRect viewFrame = [self frame];
	viewFrame.origin.x = newX;
	[self setFrame:viewFrame];
}

// 设置UIView的Y
- (void)setViewY:(CGFloat)newY
{
	CGRect viewFrame = [self frame];
	viewFrame.origin.y = newY;
	[self setFrame:viewFrame];
}

// 设置UIView的Origin
- (void)setViewOrigin:(CGPoint)newOrigin
{
	CGRect viewFrame = [self frame];
	viewFrame.origin = newOrigin;
	[self setFrame:viewFrame];
}

// 设置UIView的width
- (void)setViewWidth:(CGFloat)newWidth
{
	CGRect viewFrame = [self frame];
	viewFrame.size.width = newWidth;
	[self setFrame:viewFrame];
}

// 设置UIView的height
- (void)setViewHeight:(CGFloat)newHeight
{
	CGRect viewFrame = [self frame];
	viewFrame.size.height = newHeight;
	[self setFrame:viewFrame];
}

// 设置UIView的Size
- (void)setViewSize:(CGSize)newSize
{
	CGRect viewFrame = [self frame];
	viewFrame.size = newSize;
	[self setFrame:viewFrame];
}

@end


// UIColor 扩展
@implementation UIColor (Utility)

// 设置color的16进制值
+ (UIColor *)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alpha
{
	return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16)) / 255.0
						   green:((float)((hexValue & 0xFF00) >> 8)) / 255.0
							blue:((float)(hexValue & 0xFF))/255.0
						   alpha:alpha];
}

@end


// 数据解析扩展
@implementation NSObject (Utility)

// 成员变量转换成字典
- (void)serializeSimpleObject:(NSMutableDictionary *)dictionary
{
    NSString *className = NSStringFromClass([self class]);
    const char *cClassName = [className UTF8String];
    id theClass = objc_getClass(cClassName);
    
    // 获取property
    unsigned int propertyCount;
    objc_property_t *properties = class_copyPropertyList(theClass, &propertyCount);
    for(unsigned int i = 0; i < propertyCount; i++)
    {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        
		// 获取对象
        Ivar iVar = class_getInstanceVariable([self class], [propertyName UTF8String]);
		if(iVar == nil)
		{
			// 采用另外一种方法尝试获取
			iVar = class_getInstanceVariable([self class], [[NSString stringWithFormat:@"_%@", propertyName] UTF8String]);
		}
		
		// 赋值
		if(iVar != nil)
		{
			id propertyValue = object_getIvar(self, iVar);
			
			// 插入Dictionary中
			if(propertyValue != nil)
			{
				[dictionary safeSetObject:propertyValue forKey:propertyName];
			}
		}
        [propertyName release];
    }
	
    free(properties);
}


@end


// =====================================================
// NSString 扩展 数据校验
// =====================================================
@implementation NSString (DataCheck)

// 检验城市名
- (BOOL)checkCityNameValid
{
    BOOL isValid = NO;
    
    if((self == nil) || ([self length] == 0))
	{
		return isValid;
	}
    
    // ============================================================
	// 检验字符
	// ============================================================
	for(NSInteger i = 0; i < [self length]; i++)
	{
        unichar character = [self characterAtIndex:i];
		
		// 中文
		if((character >= 0x4e00) && (character <= 0x9fbb))
		{
			isValid = YES;
		}
		// 英文字符
		else if(((character >= 'A') && (character <= 'Z')) || ((character >= 'a') && (character <= 'z')))
		{
			isValid = YES;
		}
		// 空格
		else if(character == 0x20)
		{
			isValid = YES;
		}else if(character ==  [@"（" characterAtIndex:0] || character ==  [@"）" characterAtIndex:0]){
            isValid = YES;
        }
		// 其他字符
		else
		{
			isValid = NO;
            break;
		}
    }
    
    return isValid;
}


@end


// =====================================================
// UITableView 扩展
// =====================================================
@implementation UITableView (Utility)

- (void)reloadData:(BOOL)animated
{
    if (animated) {
        
        [UIView transitionWithView: self
                          duration: 0.25f
                           options: UIViewAnimationOptionTransitionCrossDissolve
                        animations: ^(void)
         {
             [self reloadData];
         }
                        completion: ^(BOOL isFinished)
         {
             /* 后续操作 */
         }];
    }
    else
    {
        [self reloadData];
    }
}


@end


// =====================================================
// UITextField 扩展
// =====================================================
@implementation UITextField (Utility)

// 是否可以继续输入
- (BOOL)shouldChangeInRange:(NSRange)range withString:(NSString *)string andLength:(NSInteger)maxLength
{
	// 当前内容长度
	NSString *content = [self text];
	NSInteger contentLength = (content != nil) ? [content length] : 0;
	
	// 计算总长度
	NSInteger totalLenght = contentLength + [string length] - range.length;
	if(totalLenght > maxLength)
	{
		return NO;
	}
	
	return YES;
}

@end

