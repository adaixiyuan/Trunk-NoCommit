//
//  CustomSegmented.m
//  ElongClient
//
//  Created by haibo on 11-10-27.
//  Copyright 2011 elong. All rights reserved.
//

#import "CustomSegmented.h"

#define ADDITION_TAG		333			// 防止tag＝0时与其它控件混淆
#define BG_IMAGE_TAG        555         // 有滑动效果的背景图

@implementation CustomSegmented

@synthesize selectedIndex;
@synthesize delegate;

- (void)dealloc
{
    [super dealloc];
}

- (id)initWithNormalImages:(NSArray *)nImages highlightedImages:(NSArray *)hImages Frame:(CGRect)rect
{
	if (self = [super initWithFrame:rect]) {
		float unitWidth = rect.size.width / [nImages count];
		
		for (UIImage *nImage in nImages) {
			int index = [nImages indexOfObject:nImage];
			
			UIImage *hImage			= [hImages objectAtIndex:index];
			CustomSegItem *segItem	= [[CustomSegItem alloc] initWithImage:nImage highlightedImage:hImage];
			segItem.frame			= CGRectMake(index * unitWidth, 0, unitWidth, rect.size.height);
			segItem.contentMode		= UIViewContentModeScaleToFill;
			segItem.tag				= index + ADDITION_TAG;
			segItem.delegate		= self;
			
			[self addSubview:segItem];
			self.autoresizesSubviews = YES;
			[segItem release];
		}
		
		lastSelectedIndex = -1;
	}
	
	return self;
}


- (id)initWithTitles:(NSArray *)titles
          NormalFont:(UIFont *)normalFont
    HightLightedFont:(UIFont *)highLightedFont
    NormalTitleColor:(UIColor *)normalColor
HightLightTitleColor:(UIColor *)hightLightColor
               Frame:(CGRect)rect
{
    if (self = [super initWithFrame:rect])
    {
		int offX = 0;			// 每个item的x坐标
        int width = rect.size.width / [titles count];       // 每个item的宽度
        int height = rect.size.height;              // 每个item的高度
		for (NSString *title in titles) {
			int index = [titles indexOfObject:title];
			
			CustomSegItem *segItem			= [[CustomSegItem alloc] initWithFrame:CGRectMake(offX, 0, width, height)];
			segItem.titleLabel.text			= [titles objectAtIndex:index];
			segItem.titleNormalFont			= normalFont;
			segItem.titleHighlightedFont	= highLightedFont;
			segItem.titleNormalColor		= normalColor;
			segItem.titleHighlightedColor	= hightLightColor;
			segItem.tag						= index + ADDITION_TAG;
			segItem.delegate				= self;
			
			[self addSubview:segItem];
			[segItem release];
			
			offX += width;
		}
		
		lastSelectedIndex = -1;
		adjustTitleHeight = NO;
        
        // 加入有滑动效果的背景图
        UIView *sliderView = [[UIView alloc] initWithFrame:CGRectMake(0, height - 8, width, 1)];
        sliderView.backgroundColor = [UIColor clearColor];
        sliderView.tag = BG_IMAGE_TAG;
        
        UIView *showView = [[UIView alloc] initWithFrame:CGRectMake((width-44) / 2, 0, 44, sliderView.frame.size.height)];
        showView.backgroundColor = [UIColor whiteColor];
        [sliderView addSubview:showView];
        [showView release];
        
        [self addSubview:sliderView];
        [sliderView release];
	}
	
	return self;
}


- (id)initWithNormalImages:(NSArray *)nImages
		 highlightedImages:(NSArray *)hImages
					titles:(NSArray *)titleArray
				 titleFont:(UIFont *)font
		  titleNormalColor:(UIColor *)normalColor
	 titleHighlightedColor:(UIColor *)highlightedColor
				  interval:(NSInteger)pixel
{
	if (self = [super init]) {
		int offX = 0;			// 每个item的x坐标
		for (UIImage *hImage in hImages) {
			int index = [hImages indexOfObject:hImage];
			
			UIImage *nImage					= [nImages objectAtIndex:index];
			CustomSegItem *segItem			= [[CustomSegItem alloc] initWithImage:nImage highlightedImage:hImage];
			segItem.titleLabel.text			= [titleArray objectAtIndex:index];
			segItem.titleNormalFont			= segItem.titleLabel.font = font;
			segItem.titleHighlightedFont	= font;
			segItem.titleNormalColor		= normalColor;
			segItem.titleHighlightedColor	= highlightedColor;
			segItem.frame					= CGRectMake(offX, 0, hImage.size.width, hImage.size.height);
			//NSLog(@"===%@",NSStringFromCGRect(segItem.frame));
			segItem.tag						= index + ADDITION_TAG;
			segItem.delegate				= self;
			
			[self addSubview:segItem];
			[segItem release];
			
			offX += hImage.size.width + pixel;
		}
		
		lastSelectedIndex = -1;
		adjustTitleHeight = NO;
	}
	
	return self;
}

- (id)initWithFrame:(CGRect)rect
		NormalImage:(UIImage *)nImage
   highlightedImage:(UIImage *)hImage
			 titles:(NSArray *)titleArray
		  titleFont:(UIFont *)font
   titleNormalColor:(UIColor *)normalColor
titleHighlightedColor:(UIColor *)highlightedColor
		   interval:(NSInteger)pixel
{
	if (self = [super initWithFrame:rect]) {
		int avgWidth = rect.size.width / [titleArray count];		// 每个item平均宽度
		for (NSString *title in titleArray) {
			int index = [titleArray indexOfObject:title];
			
			CustomSegItem *segItem			= [[CustomSegItem alloc] initWithImage:[nImage stretchableImageWithLeftCapWidth:nImage.size.width/2 topCapHeight:hImage.size.height/2]
                                                           highlightedImage:[hImage stretchableImageWithLeftCapWidth:hImage.size.width/2 topCapHeight:hImage.size.width/2]];
			segItem.titleNormalColor		= normalColor;
			segItem.titleHighlightedColor	= highlightedColor;
			segItem.frame					= CGRectMake(index * avgWidth, 0, avgWidth - pixel, rect.size.height);
			segItem.titleLabel.frame		= CGRectMake(0, 0, segItem.frame.size.width, segItem.frame.size.height);
			segItem.titleLabel.text			= title;
			segItem.titleNormalFont			= segItem.titleLabel.font = font;
			segItem.titleHighlightedFont	= font;
			//NSLog(@"===%@",NSStringFromCGRect(segItem.titleLabel.frame));
			segItem.tag						= index + ADDITION_TAG;
			segItem.delegate				= self;
			
			[self addSubview:segItem];
			[segItem release];
			
			if (index > 0 && index < [titleArray count]) {
				// 低调的分隔线
				UIImageView *separator = [UIImageView bottomSeparatorWithFrame:CGRectMake(index * avgWidth, 0, 1, segItem.frame.size.height)];
				separator.tag = index + kSeparatorTag;
				[self addSubview:separator];
			}
		}
		
		lastSelectedIndex = -1;
		adjustTitleHeight = NO;
	}
	
	return self;
}

- (id)initCommanSegmentedWithTitles:(NSArray *)titles normalIcons:(NSArray *)nIcons highlightIcons:(NSArray *)hIcons {
    int totalWidth = 288;		// 控件总宽度
    int totalHeight = [UIImage imageNamed:@"btn_segleft_selected2.png"].size.height;
	
	return [self initSegmentedWithFrame:CGRectMake(16, 20 * COEFFICIENT_Y, totalWidth, totalHeight)
                                 titles:titles normalIcons:nIcons highlightIcons:hIcons];
}


- (id)initSegmentedWithFrame:(CGRect)rect titles:(NSArray *)titles normalIcons:(NSArray *)nIcons highlightIcons:(NSArray *)hIcons {
    if (self = [super init]) {
		NSArray *images;
		
		int totalWidth = rect.size.width;		// 控件总宽度
		float itemWidth;			// 每个按钮得宽度
		if (2 == [titles count]) {
			images = [NSArray arrayWithObjects:
					  [UIImage stretchableImageWithPath:@"btn_segleft_selected2.png"],
					  [UIImage stretchableImageWithPath:@"btn_segright_selected2.png"],nil];
			itemWidth = totalWidth / 2;
		}
		else {
			images = [NSArray arrayWithObjects:
					  [UIImage imageNamed:@"btn_segleft_selected2.png"],
					  [UIImage imageNamed:@"btn_defaultmid_selected2.png"],
					  [UIImage imageNamed:@"btn_segright_selected2.png"],nil];
			itemWidth = totalWidth / 3;
		}
		
		self.frame = rect;
		
		// 背景
		UIImageView *backView = [[UIImageView alloc] initWithFrame:self.bounds];
		backView.image = [UIImage stretchableImageWithPath:@"segment_bg.png"];
		[self insertSubview:backView atIndex:0];
		[backView release];
		
		// 按钮
		int offX = 0;			// 每个item的x坐标
		for (NSString *title in titles) {
			int index = [titles indexOfObject:title];
			
			UIImage *hImage					= [images objectAtIndex:index];
			UIImage *nIco					= [nIcons objectAtIndex:index];
			UIImage *hIco					= [hIcons objectAtIndex:index];
			
			CustomSegItem *segItem			= [[CustomSegItem alloc] initWithImage:nil highlightedImage:hImage];
			segItem.titleLabel.text			= title;
			segItem.titleNormalFont			= segItem.titleLabel.font = FONT_16;
			segItem.titleHighlightedFont	= FONT_16;
			segItem.titleNormalColor		= [UIColor colorWithRed:35.0f / 255 green:119.0f / 255 blue:232.0f / 255 alpha:1.0f];
			segItem.titleHighlightedColor	= [UIColor whiteColor];
			segItem.frame					= CGRectMake(offX, 0, itemWidth, rect.size.height);
			[segItem setNormalIcon:nIco hightedIcon:hIco];
			
			//NSLog(@"===%@",NSStringFromCGRect(segItem.frame));
			segItem.tag						= index + ADDITION_TAG;
			segItem.delegate				= self;
			
			[self addSubview:segItem];
			[segItem release];
			
			if (index > 0) {
				// 低调的分隔线
				UIImageView *separator = [UIImageView verticalSeparatorWithFrame:CGRectMake(offX, 0, 1, segItem.frame.size.height)];
				separator.tag = index + kSeparatorTag;
				[self addSubview:separator];
			}
			
			offX += itemWidth;
		}
		
		lastSelectedIndex = -1;
		adjustTitleHeight = NO;
	}
	
	return self;
}


- (id)initBookMarkWithFrame:(CGRect)rect Titles:(NSArray *)titleArray {
	if (self = [super initWithFrame:rect]) {
		int avgWidth = rect.size.width / [titleArray count];		// 每个item平均宽度
        NSUInteger i = 0;
		for (NSString *title in titleArray) {
			int index = [titleArray indexOfObject:title];
			
            UIImage *hImage;
            if (i == 0) {
                hImage = [UIImage imageNamed:@"btn_segleft_selected2.png"];
            }
			else {
                hImage = [UIImage imageNamed:@"btn_segtright_selected2.png"];
            }
			
			CustomSegItem *segItem			= [[CustomSegItem alloc] initWithImage:nil
														   highlightedImage:[hImage stretchableImageWithLeftCapWidth:hImage.size.width/2 topCapHeight:hImage.size.height/2]];
			segItem.titleNormalColor		= [UIColor blackColor];
			segItem.titleHighlightedColor	= [UIColor whiteColor];
			segItem.frame					= CGRectMake(index * avgWidth, 0, avgWidth, rect.size.height);
			segItem.titleLabel.frame		= CGRectMake(0, 3, segItem.frame.size.width, segItem.frame.size.height - 3);
            segItem.titleLabel.backgroundColor = [UIColor clearColor];
			segItem.titleLabel.text			= title;
			segItem.titleNormalFont			= segItem.titleLabel.font = FONT_14;
			segItem.titleHighlightedFont	= FONT_B16;
			segItem.tag						= index + ADDITION_TAG;
			segItem.delegate				= self;
			
			[self addSubview:segItem];
			[segItem release];
            ++i;
		}
		
		lastSelectedIndex = -1;
		adjustTitleHeight = YES;
	}
	
	return self;
}

- (void)setSelectedIndex:(NSInteger)index {
	selectedIndex = index;
	CustomSegItem *nowItem = (CustomSegItem *)[self viewWithTag:index+ ADDITION_TAG];
	[nowItem changeState:YES];
	if (adjustTitleHeight) {
		nowItem.titleLabel.frame = nowItem.bounds;
		[self bringSubviewToFront:nowItem];
	}
	
	[delegate segmentedView:self ClickIndex:index];
	
	// 处理分隔线
	UIImageView *lastSeparator = (UIImageView *)[self viewWithTag:kSeparatorTag + lastSelectedIndex + 1];
	lastSeparator.hidden = NO;
	
	UIImageView *separator = (UIImageView *)[self viewWithTag:kSeparatorTag + index + 1];
	separator.hidden = YES;
	
	// 切换上一次选中的按钮状态
	CustomSegItem *lastItem = (CustomSegItem *)[self viewWithTag:lastSelectedIndex + ADDITION_TAG];
	if (lastItem) {
		[lastItem changeState:NO];
	}
	if (adjustTitleHeight) {
		lastItem.titleLabel.frame = CGRectMake(0, 3, lastItem.frame.size.width, lastItem.frame.size.height - 3);
		[self sendSubviewToBack:lastItem];
	}
	
	lastSelectedIndex = index;
    
    // 如果有滑动条，让其滚动
    UIView *sliderView = [self viewWithTag:BG_IMAGE_TAG];
    if (sliderView) {
        [UIView animateWithDuration:0.2 animations:^{
            CGRect rect = sliderView.frame;
            rect.origin.x = index * rect.size.width;
            sliderView.frame = rect;
        }];
    }
}

#pragma mark -
#pragma mark SegItemDelegate

- (void)setHighlightedIndex:(NSInteger)index {
	self.selectedIndex = index - ADDITION_TAG;
}

@end
