    //
//  FlightOrderHistory.m
//  ElongClient
//
//  Created by WangHaibin on 3/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FlightOrderHistory.h"
#import "FlightOrderCellViewController.h"
#import "ElongClientAppDelegate.h"
#import "FlightOrderInfoModel.h"
#import "AirlineInfoModel.h"
#import "FlightOrderHisCell.h"
#import "FlightDoubleHisCell.h"
#import "NewFlightOrderDetailViewController.h"

#define FLIGHT_ORDER_TIP	@"提示：手机平台只显示当前3月内订单，中转或经停订单请以短信为准。"

@implementation FlightOrderHistory

@synthesize m_dataSource;
@synthesize morebutton;


- (void)morehotel
{
	m_time = 1;
	postType = 1;
	JGetFlightOrderList *jgfol = [OrderHistoryPostManager getFlightOrderList];
	[jgfol nextPage];
	[Utils request:MYELONG_SEARCH req:[jgfol requesString:YES] delegate:self];
}


- (void)addHeadView {
	UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 56)];
	headView.backgroundColor = [UIColor clearColor];
	
	UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 1, 300, headView.frame.size.height - 1)];
    tipLabel.numberOfLines = 0;
	tipLabel.textColor	= [UIColor grayColor];
	tipLabel.text		= FLIGHT_ORDER_TIP;
	tipLabel.font		= FONT_14;
	tipLabel.backgroundColor = [UIColor clearColor];
	[headView addSubview:tipLabel];
	[tipLabel release];
    
	listTableView.tableHeaderView = headView;
	[headView release];
}


#pragma mark -
#pragma mark inital Method

- (id)initWithLocalOrders:(NSArray *)orders
{
	if (self = [super initWithTopImagePath:@"" andTitle:@"机票订单" style:_NavNormalBtnStyle_]) {
		m_dataSource = [[NSMutableArray alloc] initWithArray:orders];
		
		[listTableView reloadData];
	}
	
	return self;
}


- (id)initWithDatas:(NSDictionary *)orderDic
{
    NSLog(@"%@",orderDic);
    
	if (self = [super initWithTopImagePath:@"" andTitle:@"机票订单" style:_NavNormalBtnStyle_])
    {
        orderCount = [[orderDic  objectForKey:@"TotalCount"] intValue];
        
        modelAr  = [[NSMutableArray  alloc]init];
                NSArray *ordersArray = [orderDic safeObjectForKey:ORDERS];
        		if (![ordersArray isEqual:[NSNull null]] && [ordersArray count] > 0)
                {
                   for (NSDictionary  *dic in  ordersArray)
                   {
                       FlightOrderInfoModel  *flightModel = [[FlightOrderInfoModel  alloc]initWithDataDic:dic];
                       [modelAr  addObject:flightModel];
                       [flightModel  release];
                   }
                }
        
         [self  moreButtonCreate];
	}
	
	return self;
}

//- (void) viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    if (self.selectedIndexPath)
//    {
//        [listTableView deselectRowAtIndexPath:self.selectedIndexPath animated:YES];
//    }
//
//}
// Implement loadView to create a view hierarchy programmatically, without using a nib.

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    isShowTopLine = NO;
    currentFirstRow = -1;
	
	orderStatus = 0;
	currentSelectedRow=-1;
	
	listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, MAINCONTENTHEIGHT) style:UITableViewStylePlain];
	listTableView.delegate = self;
	listTableView.dataSource = self;
	listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	listTableView.backgroundColor = [UIColor clearColor];
	[self.view addSubview:listTableView];

	
	[self addHeadView];
    
   
	
	m_allBlogView = [Utils addView:@"您没有机票订单"];
	[self.view addSubview:m_allBlogView];
	m_allBlogView.hidden = YES;
    
}

- (BOOL)moreButtonCreate
{
    NSLog(@"%d",modelAr.count);
    NSLog(@"count:%d",orderCount);
    if (orderCount > modelAr.count)
    {
//        if (!morebutton)
        if (morebutton)
        {
            [morebutton release];
            morebutton = nil;
        }
//        {
            morebutton = [UIButton uniformMoreButtonWithTitle:@"更多机票订单"
                                                       Target:self
                                                       Action:@selector(morehotel)
                                                    Frame:CGRectMake(0, 0, 320, 44)];
            listTableView.tableFooterView = morebutton;
            morebutton = nil;
        
      //  }
        return YES;
    }
    else
    {   
        listTableView.tableFooterView = nil;
        return NO;
    }
    
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
	
    self.morebutton = nil;
	
	m_allBlogView = nil;
	m_usedBlogView = nil;
	m_activeBlogView = nil;
	m_cancelBlogView = nil;
}


- (void)dealloc {
//    [originOrders release];
//    [m_dataSource release];
    [modelAr release];
    [listTableView release];
	m_allBlogView = nil;
	m_usedBlogView = nil;
	m_activeBlogView = nil;
	m_cancelBlogView = nil;
    self.selectedIndexPath = nil;
	
	[super dealloc];
}


#pragma mark ---
#pragma mark tableView


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FlightOrderInfoModel  *model = [modelAr  objectAtIndex:indexPath.row];
    if ([model.TravalType  intValue] == SINGLETRIP )
    {
        return 80;
    }else  if ([model.TravalType  intValue] == DOUBLETROIP)
    {
        return 160;
    }else
        return 0;
    
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{	
	return [modelAr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    
    int cellTotalHeight = 1;
    static  NSString  *str1= @"cell1";
    static  NSString  *str2 = @"cell2";
    static  NSString   *str3 = @"cell3";
    
    UITableViewCell  *cell;
    
    FlightOrderInfoModel   *fModel =[ modelAr  objectAtIndex:indexPath.row];
    if ([fModel.TravalType  intValue] == SINGLETRIP)
    {
        
       
           cell = [tableView  dequeueReusableCellWithIdentifier:str1];
        if (!cell)
        {
              cell = [[[NSBundle  mainBundle]loadNibNamed:@"FlightOrderHisCell" owner:self options:nil]lastObject];
          
            
        }
        ((FlightOrderHisCell  *)cell).tacketModel = fModel;
     
  
        
    }else  if  ([fModel.TravalType  intValue] == DOUBLETROIP)
    {
        cellTotalHeight ++;
        
       
        cell = [tableView  dequeueReusableCellWithIdentifier:str2];
        if (!cell)
        {
           cell = [[[NSBundle  mainBundle]loadNibNamed:@"FlightDoubleHisCell" owner:self options:nil]lastObject];
          
           
        }
        ((FlightDoubleHisCell  *)cell).tacketModel = fModel;
      
       
    }else
    {
        cell = [tableView  dequeueReusableCellWithIdentifier:str3];
        if (!cell)
        {
            cell = [[[UITableViewCell  alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str3]autorelease];
        }
    }


    if(indexPath.row==0 )
    {
        UIImageView *topLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREEN_SCALE)];
        topLine.image = [UIImage imageNamed:@"dashed.png"];
        [cell addSubview:topLine];
        [topLine release];        
    }

    
    //add Line
    UIImageView *bottomLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, cellTotalHeight*80-SCREEN_SCALE, 320, SCREEN_SCALE)];
    bottomLine.image = [UIImage imageNamed:@"dashed.png"];
    [cell addSubview:bottomLine];
    [bottomLine release];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    self.selectedIndexPath = indexPath;
    
    
    FlightOrderInfoModel  *model = [modelAr  objectAtIndex:indexPath.row];
	postType = 2;
    flyType = [model.TravalType intValue];
    
// JGetFlightOrder *jgfol=[OrderHistoryPostManager getFlightOrder];
//	[jgfol clearBuildData];
//	[jgfol setOrderNo:model.OrderNo];
//	[Utils request:MYELONG_SEARCH req:[jgfol requesString:YES] delegate:self];
    
    //调用新接口
    NSDictionary *content = [NSDictionary dictionaryWithObjectsAndKeys:[PublicMethods  getUserElongCardNO],@"CardNo",
                            [PostHeader header],@"Header",
                             model.OrderNo,@"OrderNo",nil];
    NSString *req =  [NSString stringWithFormat:@"action=GetFlightOrderDetail&compress=true&req=%@",[content JSONRepresentationWithURLEncoding]];
    [Utils request:MYELONG_SEARCH req:req delegate:self];
}


#pragma mark -
#pragma mark UIScroll Delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	if (scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height &&
		listTableView.tableFooterView)
    {
       if ([self  moreButtonCreate])
        {
            [self morehotel];
        }
		// 滚到底向上拉，并且有更多按钮时，申请更多数据
		
	}
  
}


#pragma mark -
#pragma mark NET Delegate

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData {
    
    
    LzssUncompress *uncompress = [[LzssUncompress alloc] init];
    NSString *newString = [uncompress uncompress:responseData];
    NSLog(@"newdata===%@",newString);
    
    
	NSDictionary *root = [PublicMethods unCompressData:responseData];
    
    [uncompress release];
    
	if ([Utils checkJsonIsError:root]) {
		return ;
	}

	NSArray *ordersArray = [root safeObjectForKey:ORDERS];
	switch (postType) {
		case 1:
			if (![ordersArray isEqual:[NSNull null]] && [ordersArray count] > 0)
            {
                NSLog(@"HHHHHH%@",ordersArray);
                for (NSDictionary  *dic  in ordersArray)
                {
                    FlightOrderInfoModel   *fModel = [[FlightOrderInfoModel  alloc]initWithDataDic:dic];
                    [modelAr  addObject:fModel];
                    [fModel release];
                }
				
				[listTableView reloadData];
               
                [self  moreButtonCreate];
			}
            
			break;
		case 2:
			if (![ordersArray isEqual:[NSNull null]])
            {
                
//				FlightOrderHistoryDetail *controller = [[FlightOrderHistoryDetail alloc] initWithData:[root safeObjectForKey:@"Order"]];
//				controller.delegate = self;
//				[self.navigationController pushViewController:controller animated:YES];
//				[controller release];
			
                FlightOrderDetail *model = [[FlightOrderDetail alloc] init];
                [model convertObjectFromGievnDictionary:root relySelf:YES];
                //做了一下改动
				if(!model.PaymentInfo.IsAllowContinuePay)
                {
					if(currentSelectedRow!=-1)
                    {
						UITableViewCell *cell = [listTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:currentSelectedRow inSection:0]];
						UILabel *payLabel = (UILabel *)[cell viewWithTag:1001];
						if(!payLabel.hidden)
                        {
							UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该订单过期或已支付，不能再支付！" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
							[alertView show];
							[alertView release];
							payLabel.hidden = YES;
						}
						
					}
				}
                NewFlightOrderDetailViewController *detail = [[NewFlightOrderDetailViewController alloc] initWithTitle:@"订单详情" style:NavBarBtnStyleNormalBtn];
                detail.orderDetail = model;
                detail.flyType = flyType;
                [model release];
                [self.navigationController pushViewController:detail animated:YES];
                [detail release];
			}
			break;
		default:
			break;
	}
	
	postType = -1;
}

#pragma mark FlightOrderHistoryDetail delegate
-(void) paySuccess{
	if(currentSelectedRow!=-1)
    {
		UITableViewCell *cell = [listTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:currentSelectedRow inSection:0]];
		UILabel *payLabel = (UILabel *)[cell viewWithTag:1001];
		payLabel.hidden = YES;
	}
}


@end
