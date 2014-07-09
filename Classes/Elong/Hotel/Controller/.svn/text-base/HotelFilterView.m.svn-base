//
//  HotelFilterView.m
//  ElongClient
//
//  Created by 赵 海波 on 12-9-11.
//  Copyright 2012 elong. All rights reserved.
//

#import "HotelFilterView.h"
#import "HotelSearch.h"

#define kFirstImgTag    10909
#define kSecondImgTag	10910

@implementation HotelFilterView

- (id)initWithShowDistanceSort:(BOOL)setting fromTonightHotelList:(BOOL) fromTonightHotelList_
{
    showDistanceSort = setting;
    fromTonightHotelList=fromTonightHotelList_;
    if (setting)
    {
        nArray = [NSArray arrayWithObjects:@"", @"", @"", @"", @"",@"", @"", nil];
    }
    else
    {
        nArray = [NSArray arrayWithObjects:@"", @"", @"", @"", @"",@"", nil];
    }
    
    if (self = [super initWithTitle:@"排序" Datas:nArray])
    {
        
    }
    
    return self;
}

#pragma mark -
#pragma mark UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 1)
    {
        return 44;
    }
    else {
        JHotelSearch *hotelsearcher = [HotelPostManager hotelsearcher];
        PositioningManager *positionManager = [PositioningManager shared];
        if (positionManager.myCoordinate.latitude != 0 && [positionManager getPostingBool] && [positionManager.currentCity isEqualToString:hotelsearcher.cityName] && showDistanceSort)
        {
            return 44;
        }
        else
        {
            return 0;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *SelectTableCellKey = @"SelectTableCellKey";
    
	CommonCell *cell = (CommonCell *)[tableView dequeueReusableCellWithIdentifier:SelectTableCellKey];
	if (cell == nil)
    {
		cell = [[[CommonCell alloc] initWithIdentifier:SelectTableCellKey height:44 style:CommonCellStyleChoose] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
		
		UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(61, 15, 46, 16)];
		imgView.tag = kFirstImgTag;
		[cell.contentView addSubview:imgView];
		[imgView release];
		
		UIImageView *exImageView = [[UIImageView alloc] initWithFrame:CGRectMake(136, 15, 54, 16)];
		exImageView.tag = kSecondImgTag;
		[cell.contentView addSubview:exImageView];
		[exImageView release];
	}
    cell.hidden = NO;
	
	if (indexPath.row == 0)
    {
        if (!showDistanceSort)
        {
            cell.textLabel.text = @"由近及远";
        }
        else
        {
            cell.textLabel.text = @"默认排序";
        }
        
        if (fromTonightHotelList)
        {
            cell.textLabel.text = @"默认排序";
        }
        
        cell.textLabel.font=[UIFont boldSystemFontOfSize:15];
	}
	else
    {
		UIImageView *imgView	 = (UIImageView *)[cell.contentView viewWithTag:kFirstImgTag];
		UIImageView *exImageView = (UIImageView *)[cell.contentView viewWithTag:kSecondImgTag];
		
		switch (indexPath.row)
        {
            case 1:
            {
                JHotelSearch *hotelsearcher = [HotelPostManager hotelsearcher];
                PositioningManager *positionManager = [PositioningManager shared];
                if (positionManager.myCoordinate.latitude != 0 && [positionManager getPostingBool] && [positionManager.currentCity isEqualToString:hotelsearcher.cityName] && showDistanceSort)
                {
                    imgView.image = [UIImage imageNamed:@"distance_word.png"];
                    imgView.frame = CGRectMake(imgView.frame.origin.x, imgView.frame.origin.y, 78, 16);
                    exImageView.image = nil;
                    cell.textLabel.text = nil;
                    cell.hidden = NO;
                }
                else
                {
                    imgView.image = nil;
                    exImageView.image = nil;
                    cell.textLabel.text = nil;
                    cell.hidden = YES;
                }
            }
                break;
			case 2:
				imgView.image		= [UIImage imageNamed:@"price_word.png"];
				exImageView.image	= [UIImage imageNamed:@"low_high.png"];
                cell.textLabel.text = nil;
				break;
			case 3:
				imgView.image		= [UIImage imageNamed:@"price_word.png"];
				exImageView.image	= [UIImage imageNamed:@"high_low.png"];
                cell.textLabel.text = nil;
				break;
			case 4:
				imgView.image		= [UIImage imageNamed:@"star_word.png"];
				exImageView.image	= [UIImage imageNamed:@"low_high.png"];
                cell.textLabel.text = nil;
				break;
			case 5:
				imgView.image		= [UIImage imageNamed:@"star_word.png"];
				exImageView.image	= [UIImage imageNamed:@"high_low.png"];
                cell.textLabel.text = nil;
				break;
            case 6:
				imgView.image		= [UIImage imageNamed:@"good_comment.png"];
				exImageView.image	= [UIImage imageNamed:@"high_low.png"];
                cell.textLabel.text = nil;
				break;
			default:
				break;
		}
	}
	
	if (indexPath.row == currentRow)
    {
		cell.cellImage.highlighted = YES;
	}
	else
    {
		cell.cellImage.highlighted = NO;
	}
	
    return cell;
}

@end
