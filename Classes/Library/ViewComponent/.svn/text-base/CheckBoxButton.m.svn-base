//
//  CheckBoxButton.m
//  ElongClient
//
//  Created by Zhao Haibo on 13-11-10.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "CheckBoxButton.h"

@implementation CheckBoxButton


- (void)dealloc
{
    actionTarget = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:nil];
    
    [super dealloc];
}


- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
		self.userInteractionEnabled = YES;
		
		_isSelected			= NO;
        _canCancelSelected	= YES;
		_buttonIndex		= -1;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiCheckBoxClick:) name:NOTI_CHECKBOX_CLICK object:nil];
    }
	
    return self;
}


- (id)initSingleCheckBoxWithTitle:(NSString *)title Frame:(CGRect)frame
{
    if (self = [self initWithFrame:frame])
    {
        icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, (frame.size.height-24) / 2, 27, 24)];
        icon.image = [UIImage noCacheImageNamed:@"btn_checkbox.png"];
        icon.highlightedImage = [UIImage noCacheImageNamed:@"btn_checkbox_checked.png"];
        [self addSubview:icon];
        [icon release];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(icon.frame.size.width + 5, icon.frame.origin.y, frame.size.width - icon.frame.size.width - 5, icon.frame.size.height)];
        titleLabel.font = FONT_14;
        titleLabel.text = title;
        titleLabel.textColor = [UIColor blackColor];
        [self addSubview:titleLabel];
        [titleLabel release];
        
        isSingle = YES;
    }
    
    return self;
}


- (id)initMutipleCheckBoxWithTitle:(NSString *)title Frame:(CGRect)frame
{
    if (self = [self initWithFrame:frame])
    {
        icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, (frame.size.height-19) / 2, 19, 19)];
        icon.image = [UIImage noCacheImageNamed:@"btn_choice.png"];
        icon.highlightedImage = [UIImage noCacheImageNamed:@"btn_choice_checked.png"];
        [self addSubview:icon];
        [icon release];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(icon.frame.size.width + 5, icon.frame.origin.y, frame.size.width - icon.frame.size.width - 5, icon.frame.size.height)];
        titleLabel.font = FONT_14;
        titleLabel.text = title;
        titleLabel.textColor = [UIColor blackColor];
        [self addSubview:titleLabel];
        [titleLabel release];
        
        isSingle = NO;
    }
    
    return self;
}


- (void)setIsSelected:(BOOL)selected
{
	if (selected)
    {
		_isSelected = selected;
        if ([actionTarget respondsToSelector:normalAction])
        {
            [actionTarget performSelector:normalAction];
        }
	}
	else if (!selected && _canCancelSelected)
    {
		_isSelected = selected;
        if ([actionTarget respondsToSelector:cancelAction])
        {
            [actionTarget performSelector:cancelAction];
        }
	}
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	self.isSelected = !self.isSelected;
    icon.highlighted = !icon.highlighted;
    
    if (isSingle)
    {
        // 如果是单选框，需要在选中时，取消其它单选框的选中状态
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_CHECKBOX_CLICK object:self];
    }
}


- (void)addTarget:(id)target action:(SEL)action cancelAction:(SEL)otherAction
{
    actionTarget = target;
    normalAction = action;
    cancelAction = otherAction;
}


- (void)notiCheckBoxClick:(NSNotification *)noti
{
    if ([noti object] != self)
    {
        // 取消单选框的选中状态
        self.isSelected = NO;
        icon.highlighted = NO;
    }
}

@end
