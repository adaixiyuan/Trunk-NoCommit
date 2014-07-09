//
//  InterHotelOrderView.m
//  ElongClient
//
//  Created by 赵 海波 on 13-6-26.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "InterHotelOrderView.h"

#define kFirstImgTag    10909
#define kSecondImgTag	10910


@implementation InterHotelOrderView

- (void)dealloc {
    [nArray release];
    
    [super dealloc];
}


- (id)init {
    nArray = [NSArray arrayWithObjects:@"", @"", @"", @"", nil];
	
    if (self = [super initWithTitle:@"排序" Datas:nArray]) {
        
    }
	
    return self;
}


#pragma mark -
#pragma mark UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [nArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 45;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *SelectTableCellKey = @"SelectTableCellKey";
    
	CommonCell *cell = (CommonCell *)[tableView dequeueReusableCellWithIdentifier:SelectTableCellKey];
	if (cell == nil) {
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
	
	if (indexPath.row == 0) {
		cell.textLabel.text = @"最受欢迎";
        cell.textLabel.font=[UIFont boldSystemFontOfSize:15];
	}
	else {
		UIImageView *imgView	 = (UIImageView *)[cell.contentView viewWithTag:kFirstImgTag];
		UIImageView *exImageView = (UIImageView *)[cell.contentView viewWithTag:kSecondImgTag];
		
		switch (indexPath.row) {
			case 1:
				imgView.image		= [UIImage imageNamed:@"price_word.png"];
				exImageView.image	= [UIImage imageNamed:@"low_high.png"];
				break;
			
			case 2:
				imgView.image		= [UIImage imageNamed:@"star_word.png"];
				exImageView.image	= [UIImage imageNamed:@"high_low.png"];
				break;
            case 3:
                imgView.image       = [UIImage imageNamed:@"youhuifudu.png"];
                exImageView.image   = [UIImage imageNamed:@"high_low.png"];
			default:
				break;
		}
	}
	
	if (indexPath.row == currentRow) {
		cell.cellImage.highlighted = YES;
	}
	else {
		cell.cellImage.highlighted = NO;
	}
	
    return cell;
}

@end
