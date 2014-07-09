//
//  BaseBottomBar.m
//  TestIOS7
//
//  Created by 赵 海波 on 13-12-9.
//  Copyright (c) 2013年 赵 海波. All rights reserved.
//

#import "BaseBottomBar.h"
#import "CommonDefine.h"



@interface BaseBottomBar()

@property (nonatomic) NSInteger itemWidth;                       // 每个按钮得宽度
@property (nonatomic, strong) NSMutableSet *cantAccessIndexSet;  // 不能点击items的index集合

@end

@implementation BaseBottomBar

@synthesize itemWidth;

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = BACKGROUND_COLOR;
        self.mutipleSelected = NO;
        self.cantAccessIndexSet = [NSMutableSet setWithCapacity:2];
    }
    
    return self;
}
- (void)setBaseBottomBarItems:(NSArray *)items
{
    if (ARRAYHASVALUE(items))
    {
        _baseBottomBarItems = [[NSArray alloc] initWithArray:items];
        if ([self.subviews count] > 0)
        {
            // 如果已有item，清空之前的item
            for (UIView *subview in self.subviews)
            {
                [subview removeFromSuperview];
            }
        }
        
        itemWidth = SCREEN_WIDTH / [items count];
        for (int i = 0; i < [items count]; i ++)
        {
            // 填充item
            BaseBottomBarItem *item = [items objectAtIndex:i];
            if ([item isKindOfClass:[BaseBottomBarItem class]])
            {
                item.frame = CGRectMake( i * itemWidth, 0, itemWidth, self.bounds.size.height);
                [self addSubview:item];
            }
        }
    }
}


- (void)setItemEnable:(BOOL)enable AtIndexes:(NSArray *)indexes
{
    if (enable)
    {
        if ([_cantAccessIndexSet count] > 0)
        {
            for (NSNumber *num in indexes)
            {
                if ([num isKindOfClass:[NSNumber class]])
                {
                    [_cantAccessIndexSet removeObject:num];
                }
            }
        }
    }
    else
    {
        [_cantAccessIndexSet addObjectsFromArray:indexes];
    }
}

#pragma mark - Touch Event
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	
	if (touch)
    {
        CGPoint point = [touch locationInView:self];
        _selectedIndex = floor(point.x / itemWidth * 1.0);
        
        if (![_cantAccessIndexSet containsObject:[NSNumber numberWithInt:_selectedIndex]])
        {
            if ([_baseBottomBarItems count] > _selectedIndex)
            {
                // 只有在可点击情况下才执行
                BaseBottomBarItem *item = [_baseBottomBarItems objectAtIndex:_selectedIndex];
                
                if (_selectedItem)
                {
                    // 已经有过点击对象时的处理方式
                    if (_selectedItem == item)
                    {
                        // 点击同一个item时的处理方式
                        if (item.allowRepeat)
                        {
                            [item changeStateToPressed:!item.highlighted];
                        }
                        else
                        {
                            return;
                        }
                    }
                    else
                    {
                        if (!_mutipleSelected)
                        {
                            // 如果不支持多选得情况，取消前一个item的选中效果
                            [_selectedItem changeStateToPressed:NO];
                        }
                        
                        [item changeStateToPressed:YES];
                    }
                }
                else
                {
                    [item changeStateToPressed:YES];
                }
                
                self.selectedItem = item;
            }
        }
	}
}


- (void)delegateSelectedIndex:(NSNumber *)index
{
    [_delegate selectedBottomBar:self ItemAtIndex:[index intValue]];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([_delegate respondsToSelector:@selector(selectedBottomBar:ItemAtIndex:)])
    {
        // 延迟执行，防止动画被卡住
        [_delegate selectedBottomBar:self ItemAtIndex:_selectedIndex];
    }
    
    if (_selectedItem.autoReverse)
    {
        [_selectedItem changeStateToPressed:NO];
        self.selectedItem = nil;
    }
}


- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_selectedItem.autoReverse)
    {
        [_selectedItem changeStateToPressed:NO];
        self.selectedItem = nil;
    }
}

@end


@interface BaseBottomBarItem()

@property (nonatomic, strong) UIImage *originIcon;

@end


@implementation BaseBottomBarItem

@synthesize originIcon;

// 只有标题的初始化方法
- (id)initWithTitle:(NSString *)title titleFont:(UIFont *)font
{
    if (self = [self initWithTitle:title titleFont:(UIFont *)font image:nil highligtedImage:nil])
    {
        
    }
    
    return self;
}


- (id)initWithTitle:(NSString *)title
          titleFont:(UIFont *)font
        originImage:(NSString *)iconPath
{
    if (self = [self initWithTitle:title titleFont:(UIFont *)font originImage:iconPath image:nil highligtedImage:nil])
    {
        
    }
    
    return self;
}


// 使用标题和图片初始化
- (id)initWithTitle:(NSString *)title titleFont:(UIFont *)font image:(NSString *)iconPath highligtedImage:(NSString *)hIconPath
{
    if (self = [self initWithTitle:title titleFont:(UIFont *)font originImage:nil image:iconPath highligtedImage:hIconPath])
    {
        
    }
    
    return self;
}


// 使用标题、初始图片和一组切换图片初始化（一般只用于价格、时间之类的排序）
- (id)initWithTitle:(NSString *)title titleFont:(UIFont *)font originImage:(NSString *)oIconPath image:(NSString *)iconPath highligtedImage:(NSString *)hIconPath
{
    if (self = [self init])
    {
        self.originIcon = [UIImage imageNamed:oIconPath];
        self.normalIcon = [UIImage imageNamed:iconPath];
        self.highlightedIcon = [UIImage imageNamed:hIconPath];
        
        self.userInteractionEnabled = YES;
        self.allowRepeat = NO;
        self.autoReverse = NO;
        
        // 创建label
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.text = title;
        _titleLabel.font = font;
		_titleLabel.textAlignment = UITextAlignmentCenter;
		_titleLabel.textColor = [UIColor whiteColor];
		[self addSubview:_titleLabel];
        
        if ((_normalIcon && [_normalIcon isKindOfClass:[UIImage class]]) ||
            (originIcon && [originIcon isKindOfClass:[UIImage class]]))
        {
            // 有icon时创建图片
            _iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
            _iconImageView.image = originIcon ? originIcon : _normalIcon;
            _iconImageView.contentMode = UIViewContentModeCenter;
            [self addSubview:_iconImageView];
        }
    }
    
    return self;
}


- (void)changeStateToPressed:(BOOL)isPressed
{
	if (isPressed)
    {
		self.highlighted			= YES;
        
        if (originIcon && !_normalIcon && !_highlightedIcon)
        {
            // 此种情况不自动改变titleLabel的文字颜色和图片
            return;
        }
        
        if (!_customerTitleColor)
        {
            // 一般情况下能重复点击图片的item，文字颜色都是不变的
            _titleLabel.textColor   = BASEBOTTOMBAR_TITLE_COLOR_HIGHLIGHTED;
        }
        
        if (_highlightedIcon && !_customerIcon)
        {
            _iconImageView.image    = _highlightedIcon;
        }
	}
	else
    {
		self.highlighted			= NO;
        if (!_customerTitleColor)
        {
            _titleLabel.textColor	= BASEBOTTOMBAR_TITLE_COLOR_NORMAL;
        }
		
        if (_normalIcon && !_customerIcon)
        {
            _iconImageView.image    = _normalIcon;
        }
	}
}


#pragma mark- Set Methods

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    // 有图标时调整图文字得位置
    if (_iconImageView)
    {
        _iconImageView.frame = CGRectMake(0,
                                          3,
                                          frame.size.width,
                                          frame.size.height/2);
        
        _titleLabel.frame = CGRectMake(0,
                                       frame.size.height/2 + 3,
                                       frame.size.width,
                                       frame.size.height/2 - 4);
    }
    else
    {
        // 没有图标时调整文字位置
        _titleLabel.frame = self.bounds;
    }
}


- (void)setCustomerTitleColor:(UIColor *)customerTitleColor
{
    if (customerTitleColor == nil)
    {
        _customerTitleColor = nil;
        _titleLabel.textColor = BASEBOTTOMBAR_TITLE_COLOR_NORMAL;
        return;
    }
    
    if (_customerTitleColor != customerTitleColor)
    {
        _customerTitleColor = customerTitleColor;
    }
    
    _titleLabel.textColor = customerTitleColor;
}


- (void)setCustomerIcon:(UIImage *)customerIcon
{
    if (customerIcon == nil)
    {
        _customerIcon = nil;
        _iconImageView.image = _normalIcon;
        return;
    }
    
    if (_customerIcon != customerIcon)
    {
        _customerIcon = customerIcon;
    }
    
    _iconImageView.image = customerIcon;
}


@end
