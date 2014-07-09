//
//  TaxiListContrl.m
//  ElongClient
//
//  Created by nieyun on 14-1-26.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "TaxiListContrl.h"
#import "CommonDefine.h"
#import "TaxiListCell.h"
#import "TaxiDetaileCtrl.h"
#import "UIViewExt.h"
#import "TaxiDetaileModel.h"
#import "TaxiOrderManager.h"
#import "CallTaxiVC.h"

#define ItemWidth  320.0/3
#define TopViewHeight  40

@interface TaxiListContrl ()

@end

@implementation TaxiListContrl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)back{

    if (self.fromSuccess) {
        
        NSLog(@"tap and back to CallTaxiVC");
        CallTaxiVC *vc = nil;
        for (UIViewController *v  in self.navigationController.childViewControllers) {
            if ([v isKindOfClass:[CallTaxiVC class]]) {
                vc = (CallTaxiVC *)v;
                break;
            }
        }
        [self.navigationController popToViewController:vc animated:YES];
    }else{
        [super back];
    }
}


- (id)  initWithTopImagePath:(NSString *)imgPath andTitle:(NSString *)titleStr style:(NavBtnStyle)style  andArray :(NSArray  *)  ar
{
   self = [super  initWithTopImagePath:imgPath andTitle:titleStr style:style];
    if (self)
    {
         self.listAr = ar;
        storeAllModelAr = [[NSMutableArray alloc]initWithArray:self.listAr];
        [self  adjudgeList:self.listAr andTag:0];
    
    }
   
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.redTag = 0;
    
   taxiTable = [[UITableView  alloc]initWithFrame: CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-44-BottomHeight-20 )  style:UITableViewStylePlain];
   
    [self.view  addSubview:taxiTable];
    
    taxiTable.delegate  =self;
    
    taxiTable.dataSource  =self;
    
    taxiTable.separatorStyle =  UITableViewCellSeparatorStyleNone;
    
     buttonAr = [[NSMutableArray  alloc]init];
    
     bottomView  =[[UIView  alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - BottomHeight-64, SCREEN_WIDTH, BottomHeight)];
    
    bottomView.backgroundColor = [UIColor colorWithRed:0.132 green:0.107 blue:0.177 alpha:1.000];
    
    [self bottomViewAddObjects];
    
    [self.view  addSubview:bottomView];
    
     UILabel  *topView = [[UILabel  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TopViewHeight)];
    
    topView.text =  @"   提示：手机平台只显示当前6个月内订单";
   
    topView.backgroundColor  =[UIColor colorWithRed:0.925 green:0.926 blue:0.919 alpha:0.5];
    
    topView.font  =[UIFont  systemFontOfSize:15];
    
    topView.textColor = [UIColor  lightGrayColor];
    
    taxiTable.tableHeaderView = topView;
    
    [topView release];
    
    
    [self  adjudgeList: self.listAr andTag:0];

}
#pragma mark-
#pragma mark-处理没有订单时的显示
- (void) adjudgeList:(NSArray *) array  andTag:(BOOL) tag
{
    if (array.count == 0 )
    {
        if (!noListLabel)
        {
            noListLabel = [[UILabel alloc]initWithFrame:CGRectMake(50,(taxiTable.height- BottomHeight)/2, SCREEN_WIDTH- 50*2, 50)];
            noListLabel.textAlignment =  NSTextAlignmentCenter;
            noListLabel.backgroundColor = [UIColor clearColor];
            [taxiTable  addSubview:noListLabel];
            
        }
        [self  noListShow:tag];
        
    }else
    {
        if (noListLabel)
        {
            [noListLabel  removeFromSuperview];
            [noListLabel  release];
            noListLabel = Nil;
        }
    }
}
- (void) noListShow:(int) showTag
{
    switch (showTag) {
        case 0:
        {
            noListLabel.text = @"您没有打车订单";
        }
            break;
          case 1:
        {
            noListLabel.text = @"您没有已成交订单";
        }
            break;
            case 2:
        {
        } noListLabel.text = @"您没有已取消订单";
        default:
            break;
    }}
- (void)  bottomViewAddObjects
{
    NSArray  *ar = [NSArray arrayWithObjects:@"全部",@"已成交",@"已取消",nil];
    for (int i = 0; i < ar.count; i ++)
    {
        UIButton  *bt = [[UIButton alloc]initWithFrame:CGRectMake(ItemWidth * i,0, ItemWidth, bottomView.height)];
       
        [bt setTitle:[ar objectAtIndex:i] forState:UIControlStateNormal];
        
        
        [bt  addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        bt.titleLabel.font = [UIFont  systemFontOfSize:15];
        
        [bottomView addSubview:bt];
        
        bt.tag = 100 +i;
        
        [bt release];
        
        [buttonAr  addObject:bt];
    }
    
    [self  redChange];
}



- (void) buttonAction:(UIButton  *)button
{
    self.redTag = button.tag - 100;
    
    [self redChange];
    
    [self  filterAction];
}

- (void) redChange
{
    int i ;
    for ( i = 0; i < buttonAr.count; i ++)
    {
        UIButton  *button = [buttonAr  safeObjectAtIndex:i];
        
        if (button.tag - 100 == self.redTag)
        {
            [button  setTitleColor:[UIColor  redColor] forState:UIControlStateNormal];
            
        }else
        {
            [button  setTitleColor:[UIColor  whiteColor] forState:UIControlStateNormal];
        }
    }
}

- (void)  filterAction
{
    NSMutableArray  *storeListAr = [NSMutableArray  array];
    switch (self.redTag) {
        case 0:
        {
            [storeListAr  addObjectsFromArray:storeAllModelAr];
            [self tableviewRoloadData:storeListAr];
            [self  adjudgeList:storeListAr andTag:0];
        
        }
         break;
            case 1:
        {
            for(TaxiListModel  *model  in storeAllModelAr)
            {
                if ([model.orderStatus  intValue] == 2 )
                {
                    [storeListAr addObject:model];
                 
                }
            }
               [self  tableviewRoloadData:storeListAr];
               [self  adjudgeList:storeListAr andTag:1];
        }
            break;
            case 2:
        {
            for (TaxiListModel  *model  in  storeAllModelAr)
            {
                if ([model.orderStatus  intValue] == 5)
                {
                    [storeListAr addObject:model];
                }
            }
               [self  tableviewRoloadData:storeListAr];
            [self adjudgeList:storeListAr andTag:2];
        }
            break;
               default:
            break;
    }
}
- (void) tableviewRoloadData:(NSMutableArray  *) modelAr
{
    self.listAr = modelAr;
    [taxiTable  reloadData];
}



- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listAr.count;
}

- (UITableViewCell  *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString  *str = @"cell";
    
    TaxiListCell  *cell = (TaxiListCell *)[taxiTable dequeueReusableCellWithIdentifier:str];
    
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TaxiListCell" owner:self options:Nil]lastObject];
      
       
    }
    cell.model = [self.listAr safeObjectAtIndex:indexPath.row];

    
    return cell;
}

- (CGFloat)  tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CellHeight;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    listModel = [self.listAr  safeObjectAtIndex:indexPath.row];
    
    [self   requestDetaile:listModel];
    UMENG_EVENT(UEvent_UserCenter_CarOrder_DetailEnter)
}

- (void) requestDetaile:(TaxiListModel *)model
{
    NSLog(@"%@",model.orderId);
    NSDictionary  *dic = [NSDictionary  dictionaryWithObject:model.orderId forKey:@"orderId"];
    NSLog(@"%@",dic);
    
    NSString  *jsonStr = [dic  JSONString];
    NSString  *url = [PublicMethods  composeNetSearchUrl:@"myelong"forService:@"takeTaxi/orderDetail" andParam:jsonStr];
    [HttpUtil  requestURL:url postContent:nil delegate:self];
    
}

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSData *)responseData
{
   // NSString *string = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
    
	NSDictionary *root = [PublicMethods  unCompressData:responseData];
	
	if ([Utils checkJsonIsError:root])
    {
        NSLog(@"%@",[root objectForKey:@"ErrorMessage"]);
		return ;
	}
   
    NSLog(@"%@",root);
    
    TaxiDetaileCtrl  *detaile = [[TaxiDetaileCtrl  alloc]initWithTopImagePath:nil andTitle:@"订单详情" style:_NavOnlyBackBtnStyle_];
    NSDictionary  *dic = [root  objectForKey:@"order"];
    TaxiDetaileModel  *dModel = [[TaxiDetaileModel  alloc]initWithDataDic:dic];
      detaile.listModel  =listModel;
    detaile.detaileModel = dModel;
    [self.navigationController  pushViewController:detaile animated:YES];
    [dModel release];
  
    
    
   // TaxiDetaileModel *model = [root  ]

    
    [detaile  release];
    
}
- (void) dealloc
{
    [taxiTable  release];
    
    [bottomView  release];
    
    [buttonAr  release];
    
    [_listAr  release];
    
    [storeAllModelAr  release];
    
    
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
