//
//  TaxiDetaileCtrlViewController.m
//  ElongClient
//
//  Created by nieyun on 14-2-8.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "TaxiDetaileCtrl.h"
#import "TaxiDetaileSupplyCell.h"
#import "DetaileDriverCell.h"
#import "JourneyCell.h"
#import "TaxiSupply.h"
#import "UIViewExt.h"
@interface TaxiDetaileCtrl ()

@end

@implementation TaxiDetaileCtrl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    journeyAr = [[NSArray alloc]initWithObjects:@"taxi_journeyStart.png",@"taxi_journeyEnd",@"taxi_usetime.png",@"taxi_telephone.png", nil];
    detaileTable = [[UITableView  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT- 64) style:UITableViewStylePlain];
    detaileTable.separatorStyle = UITableViewCellSeparatorStyleNone;

    
    detaileTable.delegate = self;
    
    detaileTable.dataSource  =self;
    [self.view addSubview:detaileTable];

  
    detaileTable.backgroundView = Nil;
    detaileTable.backgroundColor = [UIColor  clearColor];
    
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark -
#pragma mark UIScrollViewDelegate
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    
        if (scrollView == detaileTable)
        {
            CGFloat sectionHeaderHeight = [self tableView:detaileTable heightForHeaderInSection:1];
            if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0){
                
                scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y,0, 0, 0);
            }
            else if (scrollView.contentOffset.y>=sectionHeaderHeight){
                scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
            }
        }

    
   }

- (void) journeyCellRank:(JourneyCell  *)cell andRow :(NSInteger) row
{
    switch (row)
      {
         
        case 0:
        {
            cell.dLabel.text = [NSString  stringWithFormat:@"  %@",self.detaileModel.requestInfo.fromAddress];
        }
            break;
        case 1:
        {
          
            cell.dLabel.text = [NSString  stringWithFormat:@"  %@",self.detaileModel.requestInfo.toAddress];
        }
            break;
        case 2:
        {
           
            cell.dLabel.text = [NSString  stringWithFormat:@"  %@",self.detaileModel.requestInfo.useTime];
        }
            break;
        case 3:
        {
           
            cell.dLabel.text = [NSString  stringWithFormat:@"  %@",self.detaileModel.requestInfo.passengerPhone];
        }
            break;
        default:
            break;
    }
}


#pragma mark  － TableViewDelegate


- (CGFloat)  tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.detaileModel.orderStatus intValue]== TAXI_ORDERSTATE) {
        if (indexPath.section == 1) {
            return 120;
        }else  if  (indexPath.section == 0)
        {
            return 100;
        }
        else
            return 44;
    }else
    {
        if (indexPath.section == 0) {
            return 120;
        }
        else
            return 44;
    }
    
}
- (NSInteger)  numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.detaileModel.orderStatus  intValue] == TAXI_ORDERSTATE)
    {
         return 3;
    }else
        return 2;
    
    
}
-  (NSInteger)  tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.detaileModel.orderStatus  intValue] == TAXI_ORDERSTATE) {
        if (section ==0 )
            return 1;
        else  if  (section  == 1)
            return 1;
        else
            return 4;

    }else
    {
        if (section ==0 )
            return 1;
              else
            return 4;

    }
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString  *str1 = @"cell1";
    NSString  *str2 = @"cell2";
    NSString   *str3 = @"cell3";
    UITableViewCell  *cell;
    //两套UI,订单成功和订单失败
    if ([self.detaileModel.orderStatus  intValue] == TAXI_ORDERSTATE) {
        //订单成功的UI
        if (indexPath.section == 0)
        {
            cell = [tableView  dequeueReusableCellWithIdentifier:str1];
        }
        else  if  (indexPath.section  ==1)
        {
            cell  =[tableView  dequeueReusableCellWithIdentifier:str2];
        }
        else
        {
            cell =  [tableView  dequeueReusableCellWithIdentifier:str3];
        }

    }else
    {
        if (indexPath.section == 0)
        {
            cell = [tableView  dequeueReusableCellWithIdentifier:str1];
        }
        else
        {
            cell =  [tableView  dequeueReusableCellWithIdentifier:str3];
        }

    }
    
    if (cell == nil)
    {
        if ([self.detaileModel.orderStatus  intValue] == TAXI_ORDERSTATE) {
            
            if (indexPath.section == 0)
            {
                
                cell  =  [[[NSBundle  mainBundle] loadNibNamed:@"DetaileDriverCell" owner:self options:Nil]lastObject];
               ((DetaileDriverCell *)cell).cellType = DetaileDriverCellFromOrder;
                
            }else if (indexPath.section == 1)
            {
                cell = [[[NSBundle  mainBundle]loadNibNamed:@"TaxiDetaileSupplyCell" owner:self options:Nil]lastObject];
                
                
            }
            else
                cell = [[[JourneyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str3]autorelease];

        }else
        {
            if (indexPath.section == 0)
            {
                
                cell  =  [[[NSBundle  mainBundle] loadNibNamed:@"TaxiDetaileSupplyCell" owner:self options:Nil]lastObject];
                
            }else
                cell = [[[JourneyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str3]autorelease];
        }
        
        UIImageView  *topLine = [[UIImageView  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_SCALE)];
        topLine.image = [UIImage  noCacheImageNamed:@"dashed.png"];
        [cell.contentView addSubview:topLine];
        [topLine release];
             
    }
    if ([self.detaileModel.orderStatus  intValue] == TAXI_ORDERSTATE)
    {
        if (indexPath.section == 0)
        {
            DetaileDriverCell  *cell1 = (DetaileDriverCell *)cell;
            cell1.driverModel  =self.detaileModel.responseInfo;
           
        }
        else  if (indexPath.section == 1 )
        {
            TaxiDetaileSupplyCell  *cell2 =(TaxiDetaileSupplyCell *) cell;
            cell2.model = self.detaileModel.supplierInfo;
            cell2.dModel = self.detaileModel;
        }
        else  if  (indexPath.section == 2)
        {
            JourneyCell  *cell3 = (JourneyCell  *)cell;
            cell3.imageView.image = [UIImage  imageNamed:journeyAr[indexPath.row]];
            [self  journeyCellRank:cell3 andRow:indexPath.row];
            
        }

    }else
    {
        if (indexPath.section == 0)
        {
            
            TaxiDetaileSupplyCell  *cell1 =(TaxiDetaileSupplyCell *) cell;
            cell1.dModel = self.detaileModel;
            cell1.model = self.detaileModel.supplierInfo;
            
        }
       else  if  (indexPath.section == 1)
        {
            JourneyCell  *cell3 = (JourneyCell  *)cell;
            cell3.imageView.image = [UIImage  imageNamed:journeyAr[indexPath.row]];
            [self  journeyCellRank:cell3 andRow:indexPath.row];
            
        }

    }
       return cell  ;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1  && [self.listModel.orderStatus  intValue ] == TAXI_ORDERSTATE)
    {
    
        return SectionHeight  + TipHeight + 10;
    
    }else
        
        return SectionHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel  *sectionHeadLabel;
    
    if (section == 0) {
        
        sectionHeadLabel = [self  sectionViewGet];
       //如果是
        if ([self.detaileModel.orderStatus  intValue]== TAXI_ORDERSTATE)
        {
             sectionHeadLabel.text = @"   司机信息";
        }else
            sectionHeadLabel.text =@"   订单信息";
       
    }
    else if (section == 1)
    {
         sectionHeadLabel  =  [self  sectionViewGet];
        if ([self.detaileModel.orderStatus  intValue ] == TAXI_ORDERSTATE) {
            
            if ([self.listModel.orderStatus intValue]==2)
            {
                UIView  *journeyHeadV = [[UIView  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SectionHeight  + TipHeight + 10)];
                UILabel  *tipLabel = [[UILabel  alloc]initWithFrame:CGRectMake(9, 0, SCREEN_WIDTH-20, TipHeight)];
                tipLabel.backgroundColor = [UIColor  clearColor];
                tipLabel.numberOfLines = 100;
                tipLabel.text = TIP;
                tipLabel.font = [UIFont  systemFontOfSize:12];
                tipLabel.textColor = RGBACOLOR(20, 157, 52, 1);
                tipLabel.textAlignment = NSTextAlignmentLeft;
                [journeyHeadV  addSubview:tipLabel];
                [tipLabel  release];
                
                sectionHeadLabel = [self  sectionViewGet];
                sectionHeadLabel.top = tipLabel.bottom + 8 ;
                sectionHeadLabel.text   = @"   订单信息";
                
                [journeyHeadV  addSubview:sectionHeadLabel];
                
                return [journeyHeadV  autorelease];
            }
        }else
        {
            sectionHeadLabel.text =@"   行程信息";
        }
       
    }else
    {
    
      sectionHeadLabel = [self  sectionViewGet];
        
        sectionHeadLabel.text   = @"   行程信息";
    }
    
       return sectionHeadLabel  ;
}

- (UILabel  *) sectionViewGet
{
    UILabel  *sectionHeadLabel = [[UILabel  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SectionHeight)];
    
    sectionHeadLabel.backgroundColor = [UIColor  clearColor];
    
    sectionHeadLabel.font  = [UIFont  systemFontOfSize:15];
    
    sectionHeadLabel.textColor = [UIColor colorWithRed:0.467 green:0.500 blue:0.478 alpha:1.000];
    
    return [sectionHeadLabel autorelease];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) dealloc
{
    [detaileTable  release];
    SFRelease(journeyAr);
    SFRelease(_listModel);
    [_detaileModel  release];
    [super dealloc ];
}
@end
