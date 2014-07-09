    //
//  CommentHotelListViewController.m
//  ElongClient
//
//  Created by 赵 海波 on 12-4-12.
//  Copyright 2012 elong. All rights reserved.
//

#import "CommentHotelListViewController.h"
#import "CommentHotelRequest.h"
#import "ElongURL.h"
#import "Utils.h"


@implementation CommentHotelListViewController

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[dataSource release];
	[tableFootView release];
	[hotelsTable release];
	
    [super dealloc];
}


#pragma mark -
#pragma mark Initialization

- (id)initWithHotelInfos:(NSDictionary *)infos  commentType:(CommentType)type{
    NSString *titleName = @"酒店点评";
    if(type==GROUPON){
        titleName = @"团购点评";
    }
	if (self = [super initWithTopImagePath:@"" andTitle:titleName style:_NavNormalBtnStyle_]) {
		NSArray *hotelInfos = [infos safeObjectForKey:ORDERS];
		if (![hotelInfos isEqual:[NSNull null]]) {
			dataSource = [[NSMutableArray alloc] initWithArray:hotelInfos];
		}
		total = [[infos safeObjectForKey:TOTALCOUNT] intValue];
		
		if ([dataSource count] > 0) {
			[self performSelector:@selector(makeHotelsTable)];
		}
		else {
			// 返回null或者空数组时提示
            if(type==HOTEL){
                [self.view showTipMessage:@"您还没有可评价酒店"];
            }else{
                [self.view showTipMessage:@"您还没有可评价团购"];
            }
		}
        whichrow= -1;
        _currentCommentType = type; //当前点评的类型
	}
	
	return self;
}


- (void)makeHotelsTable {
	hotelsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT) style:UITableViewStylePlain];
	hotelsTable.dataSource		= self;
	hotelsTable.delegate		= self;
	hotelsTable.backgroundColor = [UIColor clearColor];
    hotelsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self.view insertSubview:hotelsTable atIndex:0];
	
    if(_currentCommentType==HOTEL){
        if ([dataSource count] < total) {
            tableFootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 47)];
            
            UIButton *morebutton = [UIButton uniformMoreButtonWithTitle:_string(@"s_morehotel")
                                                                 Target:self
                                                                 Action:@selector(morehotel)
                                                                  Frame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
            [tableFootView addSubview:morebutton];
            hotelsTable.tableFooterView = tableFootView;
        }
    }
}


- (void)morehotel {
	CommentHotelRequest *commentReq = [CommentHotelRequest shared];
	[commentReq nextPage];
	[Utils request:HOTELSEARCH req:[commentReq getCanCommentHotel] delegate:self];
}


#pragma mark -
#pragma mark Net Delegate

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData {
	NSDictionary *root = [PublicMethods unCompressData:responseData];
		
	if ([Utils checkJsonIsError:root]) {
		return;
	}
	
	[dataSource addObjectsFromArray:[root safeObjectForKey:ORDERS]];
	[hotelsTable reloadData];
	
	if ([dataSource count] < total) {
		hotelsTable.tableFooterView = tableFootView;
	}
	else {
		hotelsTable.tableFooterView = nil;
	}
}

#pragma mark -
#pragma mark TableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellIdentifier = @"HotelListModeCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        
        UIImageView *rightArrow = [[UIImageView alloc] initWithFrame:CGRectMake(300, 18, 5, 9)];
        rightArrow.image = [UIImage imageNamed:@"ico_rightarrow.png"];
        cell.accessoryView =rightArrow;
        [rightArrow release];
        
        UIView *bgView = [[UIView alloc] initWithFrame:cell.bounds];
        bgView.backgroundColor = [UIColor whiteColor];
        cell.backgroundView = bgView;
        [bgView release];
        
        UIImageView *selectedBgView = [[UIImageView alloc] initWithFrame:cell.bounds];
        selectedBgView.image = COMMON_BUTTON_PRESSED_IMG;
        cell.selectedBackgroundView  = selectedBgView;
        [selectedBgView release];
        
        //第一行
        UIImageView *topLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREEN_SCALE)];
        topLine.tag = 4998;
        topLine.image = [UIImage imageNamed:@"dashed.png"];
        [cell addSubview:topLine];
        [topLine release];
        
        UIImageView *bottomLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44-SCREEN_SCALE, 320, SCREEN_SCALE)];
        bottomLine.tag = 4999;
        bottomLine.image = [UIImage imageNamed:@"dashed.png"];
        [cell addSubview:bottomLine];
        [bottomLine release];
        
        cell.textLabel.font = FONT_15;
        cell.textLabel.highlightedTextColor = cell.textLabel.textColor;
    }
    UIImageView *topLine = (UIImageView *)[cell viewWithTag:4998];
    topLine.hidden = YES;
    if(indexPath.row==0){
        topLine.hidden = NO;
    }
    
    if(_currentCommentType==HOTEL){
        NSDictionary *hotel = [dataSource safeObjectAtIndex:indexPath.row];
        cell.textLabel.text = [hotel safeObjectForKey:HOTELNAME_GROUPON];
    }else{
        //团购点评
        NSDictionary *hotel = [dataSource safeObjectAtIndex:indexPath.row];
        cell.textLabel.text = [hotel safeObjectForKey:@"ProductName"];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {	
    return [dataSource count];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    whichrow = indexPath.row;
    
	CommentHotelViewController *controller = [[CommentHotelViewController alloc] initWithDatas:[dataSource safeObjectAtIndex:indexPath.row] commentType:_currentCommentType];
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}


- (int)deleterowofdatasource
{
    if (whichrow >= 0) {
        [dataSource removeObjectAtIndex:whichrow];
        return [dataSource count];
    }
    return 0;
}


-(void)reloadtableview
{
    [hotelsTable reloadData];
}

#pragma mark -
#pragma mark UIScroll Delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if(_currentCommentType==HOTEL){
        if (scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height &&
            hotelsTable.tableFooterView) {
            // 滚到底向上拉，并且有更多按钮时，申请更多数据
            [self morehotel];
        }
    }
}


@end
