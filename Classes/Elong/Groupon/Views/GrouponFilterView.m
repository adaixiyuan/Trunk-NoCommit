//
//  GrouponFilterView.m
//  ElongClient
//
//  Created by Dawn on 13-8-8.
//  Copyright (c) 2013年 elong. All rights reserved.
//
#define kFirstImgTag    10909
#define kSecondImgTag	10910

#import "GrouponFilterView.h"
#import "GListRequest.h"
#import "PositioningManager.h"

@interface GrouponFilterView ()

@end

@implementation GrouponFilterView

#pragma mark -
#pragma mark UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.listDatas.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
     return 45;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *SelectTableCellKey = @"SelectTableCellKey";
    
	CommonCell *cell = (CommonCell *)[tableView dequeueReusableCellWithIdentifier:SelectTableCellKey];
	if (cell == nil)
    {
		cell = [[[CommonCell alloc] initWithIdentifier:SelectTableCellKey height:45 style:CommonCellStyleChoose] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(61, 15, 46, 16)];
		imgView.tag = kFirstImgTag;
		[cell.contentView addSubview:imgView];
		[imgView release];
		
		UIImageView *exImageView = [[UIImageView alloc] initWithFrame:CGRectMake(136, 15, 54, 16)];
		exImageView.tag = kSecondImgTag;
		[cell.contentView addSubview:exImageView];
		[exImageView release];
	}
	
    UIImageView *imgView	 = (UIImageView *)[cell.contentView viewWithTag:kFirstImgTag];
    UIImageView *exImageView = (UIImageView *)[cell.contentView viewWithTag:kSecondImgTag];
    
    
    NSInteger row = [indexPath row];
    NSInteger curRowNumber = 0;
    
    // 默认排序
    if (row == curRowNumber)
    {
        imgView.image		= nil;
        exImageView.image	= nil;
        cell.textLabel.text = @"默认排序";
        cell.textLabel.font=[UIFont boldSystemFontOfSize:15];
    }
    curRowNumber ++;
    
    // 距离最近
    if ([self isHaveJuliZuijin])
    {
        GListRequest *request = [GListRequest shared];
        PositioningManager *positionManager = [PositioningManager shared];
        if (positionManager.myCoordinate.latitude != 0 && [positionManager getPostingBool] && [positionManager.currentCity isEqualToString:request.cityName])
        {
            if (row == curRowNumber)
            {
                imgView.image = [UIImage imageNamed:@"distance_word.png"];
                imgView.frame = CGRectMake(imgView.frame.origin.x, imgView.frame.origin.y, 78, 16);
                exImageView.image = nil;
                cell.textLabel.text = nil;
            }
            curRowNumber ++;
        }
    }
    
    // 价格从低到高
    if (row == curRowNumber)
    {
        imgView.image		= [UIImage imageNamed:@"price_word.png"];
        imgView.frame = CGRectMake(imgView.frame.origin.x, imgView.frame.origin.y, 46, 16);
        exImageView.image	= [UIImage imageNamed:@"low_high.png"];
    }
    curRowNumber ++;
    
    // 价格从高到低
    if (row == curRowNumber)
    {
        imgView.image		= [UIImage imageNamed:@"price_word.png"];
        exImageView.image	= [UIImage imageNamed:@"high_low.png"];
    }
    curRowNumber ++;
    
    // 销量从低到高
    if (row == curRowNumber)
    {
        imgView.image		= [UIImage imageNamed:@"sale_word.png"];
        exImageView.image	= [UIImage imageNamed:@"low_high.png"];
    }
    curRowNumber ++;
    
    // 销量从高到低
    if (row == curRowNumber)
    {
        imgView.image		= [UIImage imageNamed:@"sale_word.png"];
        exImageView.image	= [UIImage imageNamed:@"high_low.png"];
    }
    
	
	if (indexPath.row == currentRow) {
		cell.cellImage.highlighted = YES;
	}
	else {
		cell.cellImage.highlighted = NO;
	}
	
    return cell;
}


//是否包含距离最近
-(BOOL) isHaveJuliZuijin
{
    if (!ARRAYHASVALUE(self.listDatas)) {
        return NO;
    }
    
    for (NSString *str in self.listDatas)
    {
        if (!STRINGHASVALUE(str))
        {
            continue;
        }
        
        if ([str isEqualToString:@"距离最近"]) {
            return YES;
        }
    }
    
    return NO;
}


@end
