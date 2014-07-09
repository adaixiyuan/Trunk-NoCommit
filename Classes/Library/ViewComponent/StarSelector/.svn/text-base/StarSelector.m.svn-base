//
//  StarSelector.m
//  ElongClient
//
//  Created by Dawn on 14-4-24.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "StarSelector.h"


@implementation StarSelectorItem
- (void) dealloc{
    self.innerTitle = nil;
    self.title = nil;
    self.image = nil;
    self.hightImage = nil;
    self.delegate = nil;
    self.starCode =  nil;
    [super dealloc];
}

- (id) initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _itemBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [self addSubview:_itemBtn];
        _itemBtn.adjustsImageWhenDisabled = NO;
        _itemBtn.adjustsImageWhenHighlighted = NO;
        _itemBtn.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [_itemBtn addTarget:self action:@selector(itemBtnClick:) forControlEvents:UIControlEventTouchDown];
        
        _innerLbl = [[UILabel alloc] initWithFrame:_itemBtn.bounds];
        _innerLbl.font = [UIFont systemFontOfSize:10.0f];
        _innerLbl.textAlignment = UITextAlignmentCenter;
        [_itemBtn addSubview:_innerLbl];
        [_innerLbl release];
        _innerLbl.backgroundColor = [UIColor clearColor];
        
        _itemLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.width, frame.size.width, frame.size.height - frame.size.width)];
        _itemLbl.font = [UIFont systemFontOfSize:12.0];
        _itemLbl.textAlignment = UITextAlignmentCenter;
        _itemLbl.textColor = RGBACOLOR(102, 102, 102, 1);
        _itemLbl.backgroundColor = [UIColor clearColor];
        [self addSubview:_itemLbl];
        [_itemLbl release];
    }
    return self;
}

- (void) itemBtnClick:(id)sender{
    if ([self.delegate respondsToSelector:@selector(starSelectorItemAction:)]) {
        [self.delegate starSelectorItemAction:self];
    }
}

- (void) setTitle:(NSString *)title{
    [_title release];
    _title = title;
    [_title retain];
    [_itemLbl setText:title];
}

- (void) setInnerTitle:(NSString *)innerTitle{
    [_innerTitle release];
    _innerTitle = innerTitle;
    [_innerTitle retain];
    [_innerLbl setText:innerTitle];

}

- (void) setSelected:(BOOL)selected{
    _selected = selected;
    if (_selected) {
        [_itemBtn setImage:self.hightImage forState:UIControlStateNormal];
        _innerLbl.textColor = [UIColor whiteColor];
    }else{
        [_itemBtn setImage:self.image forState:UIControlStateNormal];
        _innerLbl.textColor = RGBACOLOR(102, 102, 102, 1);
    }
}

@end

@interface StarSelector()
@property (nonatomic,retain) NSArray *stars;
@end

@implementation StarSelector
- (void) dealloc{
    self.stars = nil;
    self.delegate = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat itemWidth = frame.size.width / 5;
        CGFloat itemHeight = frame.size.height;
        
        // 构造数据 [不限 客栈 舒适 高档 豪华][不限 经济 三星 四星 五星]
        NSArray *starInnterTitles = [NSArray arrayWithObjects:@"",@"客栈",@"舒适",@"高档",@"豪华", nil];
        NSArray *starTitles = [NSArray arrayWithObjects:@"全部",@"经济",@"三星",@"四星",@"五星", nil];
        NSArray *starCodes = [NSArray arrayWithObjects:STAR_LIMITED_NONE,STAR_LIMITED_OTHER,STAR_LIMITED_THREE,STAR_LIMITED_FOUR,STAR_LIMITED_FIVE,nil];
        NSMutableArray *starArray = [NSMutableArray array];
        for (int i = 0; i < 5; i++) {
            StarSelectorItem *item = [[StarSelectorItem alloc] initWithFrame:CGRectMake(itemWidth * i, 0, itemWidth, itemHeight)];
            item.innerTitle = [starInnterTitles objectAtIndex:i];
            item.title = [starTitles objectAtIndex:i];
            item.delegate = self;
            item.image = [UIImage noCacheImageNamed:@"selector_star.png"];
            item.hightImage = [UIImage noCacheImageNamed:@"selector_star_h.png"];
            item.starCode = [starCodes objectAtIndex:i];
            [starArray addObject:item];
            [item release];
            [self addSubview:item];
            item.selected = NO;
        }
        self.stars = starArray;
    }
    return self;
}

- (void) setStarCodes:(NSString *)starCodes{
    [_starCodes release];
    _starCodes = starCodes;
    [_starCodes retain];
    
    for (StarSelectorItem *item in self.stars) {
        item.selected = NO;
    }
    NSArray *starCodeIDs = [starCodes componentsSeparatedByString:@","];
    for (NSString *starCode in starCodeIDs) {
        for (StarSelectorItem *item in self.stars) {
            if ([item.starCode isEqualToString:starCode]) {
                item.selected = YES;
            }
        }
    }
}


#pragma mark -
#pragma mark StarSelectorItemDelegate
- (void) starSelectorItemAction:(StarSelectorItem *)item{
    if ([item.starCode isEqualToString:STAR_LIMITED_NONE]) {
        for (StarSelectorItem *item in self.stars) {
            item.selected = NO;
        }
        item.selected = YES;
    }else{
        item.selected = !item.selected;
        BOOL selectedAll = YES;
        BOOL deselectedAll = YES;
        StarSelectorItem *firstItem = nil;
        for (StarSelectorItem *subitem in self.stars) {
            if (![subitem.starCode isEqualToString:STAR_LIMITED_NONE]) {
                selectedAll = selectedAll & subitem.selected;
                deselectedAll = deselectedAll & (!subitem.selected);
            }else{
                firstItem = subitem;
            }
        }
        if (selectedAll || deselectedAll) {
            for (StarSelectorItem *subitem in self.stars) {
                if (![subitem.starCode isEqualToString:STAR_LIMITED_NONE]) {
                    subitem.selected = NO;
                }else{
                    subitem.selected = YES;
                }
            }
        }else{
            firstItem.selected = NO;
        }
    }
    
    
    NSMutableArray *starCodeArray = [NSMutableArray array];
    for (StarSelectorItem *item in self.stars) {
        if (item.selected) {
            [starCodeArray addObject:item.starCode];
        }
    }
    
    [_starCodes release];
    _starCodes = [starCodeArray componentsJoinedByString:@","];
    [_starCodes retain];
    
    if ([self.delegate respondsToSelector:@selector(starSelector:didSelectStarCodes:)]) {
        [self.delegate starSelector:self didSelectStarCodes:self.starCodes];
    }
}

@end
