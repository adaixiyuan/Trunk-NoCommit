//
//  NewPayMentCtrl.m
//  ElongClient
//
//  Created by nieyun on 14-4-3.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "NewPayMentCtrl.h"
#import "NewPayMentTable.h"
#import "NewOderCell.h"
#import "CredtCardPayCtrl.h"
#import "AttributedLabel.h"
#import "UIViewExt.h"

@interface NewPayMentCtrl ()

@end

@implementation NewPayMentCtrl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
    [_modelAr  release];
    [mainTable  release];
    [credtCardCtrl  release];
    [_topDic release];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT - 60) style:UITableViewStylePlain];
    mainTable.dataSource  =self;
    mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainTable.delegate =self;
    mainTable.backgroundColor = [UIColor  clearColor];
    mainTable.backgroundView = nil;
    mainTable.scrollEnabled = NO;
    
    [self.view  addSubview:mainTable];
   
//    NewPayMentTable  *table = [[NewPayMentTable  alloc]initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, MAINCONTENTHEIGHT - 100) withProductAr:self.modelAr];
//    [self.view addSubview:table];
//    [table  release];
    
    [self  setBottomView];
    
    
    // Do any additional setup after loading the view from its nib.
}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case CashSection:
            return 2;
            
        default:
            return 1;
            break;
    }
}

- (UITableViewCell  *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString  *str1 = @"cell1";
    static  NSString   *str2 = @"cell2";
    static  NSString  *str3 = @"cell3";
    switch (indexPath.section) {
        case CashSection:
        {
            if (indexPath.row == 0)
            {
                NewOderCell *cell = [tableView  dequeueReusableCellWithIdentifier:str1];
                if (!cell)
                {
                    cell  = [[[NSBundle  mainBundle]loadNibNamed:@"NewOderCell" owner:self options:nil]lastObject];
                    
                    UIImageView  *topLineView = [[UIImageView  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_SCALE)];
                    topLineView.image = [UIImage  noCacheImageNamed:@"dashed.png"];
                    [cell.contentView  addSubview:topLineView];
                    [topLineView release];
                }
                cell.price =  [self.topDic  safeObjectForKey:@"totalPrice"];
                
                 return cell;
            }
             else
             {   //预留的现金单元格
                 UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:str2];
                 if (!cell) {
                   cell   = [[[UITableViewCell  alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str2]autorelease];
                 }
                 return cell;
             }
           
        }
            
       case PaytypeSection:
        {
            UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:str3];
            if (!cell)
            {
                cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str3]autorelease];
                cell.backgroundColor = [UIColor  whiteColor];
                NewPayMentTable  *newTable = [[NewPayMentTable  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [self  countHeight:self.modelAr] - SCREEN_SCALE) withProductAr:self.modelAr];
                newTable.backgroundColor = [UIColor  clearColor];
                newTable.backgroundView =nil;
              
                payMethod = newTable.selectedPayType;
                
                newTable.selectDelegate = self;
                
                [cell.contentView addSubview:newTable];
                
                [newTable release];
                
                
                UIImageView  *bottomLineView  =[[UIImageView  alloc]initWithFrame:CGRectMake(0, [self  countHeight:self.modelAr]- SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)];
                bottomLineView.image = [UIImage  noCacheImageNamed:@"dashed.png"];
                [cell.contentView addSubview:bottomLineView];
                [bottomLineView  release];
            }
            return cell;
        }
    }
    return nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case CashSection:
            if (indexPath.row == 0)
            {
                  return 44;
            }else
                return 0;
          
            
        default:
            return [self  countHeight:self.modelAr];
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
            
        case CashSection:
        {
            
            NSArray  *showMessage = [self.topDic  objectForKey:@"detaile"];
            if (ARRAYHASVALUE(showMessage)) {
                if ([showMessage count] == 2) {
                    return 80;
                }else{
                    return 100;
                }
            }

            
        }
    }
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    switch (section) {
        case PaytypeSection:
            return 20;
            break;
        default:
            break;
    }
    return 0;
}

- (void)setBottomView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, MAINCONTENTHEIGHT - 50, SCREEN_WIDTH, 50)];
    bottomView.backgroundColor = RGBCOLOR(62, 62, 62, 1);
    
    // 添加确认支付按钮
    UIButton *confirmBtn = [UIButton uniformButtonWithTitle:@"下一步"
                                                  ImagePath:nil
                                                     Target:self
                                                     Action:@selector(clickConfirmBtn)
                                                      Frame:CGRectMake(20, 0, SCREEN_WIDTH - 40, 50)];
    [confirmBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default2_normal.png"] forState:UIControlStateNormal];
    [confirmBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default2_press.png"] forState:UIControlStateHighlighted];
    
    [bottomView addSubview:confirmBtn];
    [self.view addSubview:bottomView];
    [bottomView  release];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == mainTable)
    {
        CGFloat sectionHeaderHeight;
        sectionHeaderHeight = [self tableView:mainTable  heightForHeaderInSection:1];
        
        
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0)
        {
            
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y,0, 0, 0);
        }
        else if (scrollView.contentOffset.y>=sectionHeaderHeight){
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    if (section == PaytypeSection) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 10)];
        label.text = @"请在30分钟内完成支付，如未及时支付，将取消本次订单";
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = RGBACOLOR(52, 52, 52, 1);
        label.font = FONT_12;
        return [label autorelease];
    }
    return nil;
}


- (UIView  *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView  *secView = [[UIView  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    CGFloat height = 0.0f;
    secView.backgroundColor = [UIColor clearColor];
    switch (section) {
            
        case CashSection:
        {
            height = 100;
            /*
             UILabel *showLabel = [[UILabel  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
             showLabel.numberOfLines = 0;
             NSArray  *showMessage = [self.topDic  objectForKey:@"detaile"];
             NSMutableString  *appedStr= [NSMutableString  string];
             for (int i = 0; i< showMessage.count; i++)
             {
             [appedStr  appendString:[NSString  stringWithFormat:@"   %@\n",[showMessage  safeObjectAtIndex:i]]];
             
             }
             showLabel.text = appedStr;
             showLabel.textColor = RGBCOLOR(153, 153, 153, 1);
             showLabel.font = FONT_13;
             showLabel.backgroundColor = [UIColor clearColor];
             showLabel.height =20*showMessage.count;
             [secView  addSubview:showLabel];
             secView.height = showLabel.height;
             [showLabel  release];
             */
            //简单处理 贴Label
            NSArray  *showMessage = [self.topDic  objectForKey:@"detaile"];
            if (ARRAYHASVALUE(showMessage)) {
                
                if ([showMessage count] ==2) {
                    UILabel *info = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 20)];
                    info.text = [showMessage objectAtIndex:0];
                    info.backgroundColor = [UIColor clearColor];
                    info.textColor = RGBACOLOR(52, 52, 52, 1);
                    info.font = FONT_15;
                    [secView addSubview:info];
                    [info release];
                    
                    UILabel *intro = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 300,50)];
                    intro.numberOfLines = 0;
                    intro.lineBreakMode = NSLineBreakByWordWrapping;
                    intro.text = [showMessage objectAtIndex:1];
                    intro.backgroundColor = [UIColor clearColor];
                    intro.textColor = RGBACOLOR(52, 52, 52, 1);
                    
                    intro.font = FONT_13;
                    [secView addSubview:intro];
                    [intro release];
                }else{
                    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 200, 20)];
                    title.text = [showMessage objectAtIndex:0];
                    title.backgroundColor = [UIColor clearColor];
                    title.textColor = RGBACOLOR(252, 152, 44, 1);
                    [secView addSubview:title];
                    [title release];
                    
                    UILabel *info = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 300, 20)];
                    info.text = [showMessage objectAtIndex:1];
                    info.backgroundColor = [UIColor clearColor];
                    info.textColor = RGBACOLOR(52, 52, 52, 1);
                    info.font = FONT_15;
                    [secView addSubview:info];
                    [info release];
                    
                    UILabel *intro = [[UILabel alloc] initWithFrame:CGRectMake(10, 45, 300,50)];
                    intro.numberOfLines = 0;
                    intro.lineBreakMode = NSLineBreakByWordWrapping;
                    intro.text = [showMessage objectAtIndex:2];
                    intro.backgroundColor = [UIColor clearColor];
                    intro.textColor = RGBACOLOR(52, 52, 52, 1);
                    
                    intro.font = FONT_13;
                    [secView addSubview:intro];
                    [intro release];
                    
                    
                }
            }
        }
            break;
            
        case PaytypeSection:
        {
            height = 44;
          UILabel  *headerTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,22, SCREEN_WIDTH, 20)];
             headerTitleLabel.text = @"   选择支付方式";

            headerTitleLabel.backgroundColor = [UIColor clearColor];
            headerTitleLabel.textColor = RGBCOLOR(153, 153, 153, 1);
            headerTitleLabel.font = FONT_13;
            [secView  addSubview:headerTitleLabel];
            [headerTitleLabel  release];
        }
            break;
            
        default:
            break;
    }
    [secView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
    return [secView autorelease];
}
- (CGFloat)countHeight:(NSArray *)modelAr
{
    return modelAr.count*44;
}

- (void)clickConfirmBtn
{
    [self payAction:payMethod];
}



- (void)selectPayType:(NSInteger)selecType

{
    payMethod = selecType;
   
}

- (void)payAction:(NewUniformPaymentType) type
{
    switch (type)
    {
        case NewUniformPaymentTypeCreditCard:
        {
            credtCardCtrl = [[CredtCardPayCtrl  alloc]init];
            [credtCardCtrl  creditPayAction];
            
        }
            break;
        case NewUniformPaymentTypeDepositCard:
        {
            
        }
            break;
        case NewUniformPaymentTypeWeixin:
        {
            
        }
            break;
        case NewUniformPaymentTypeAlipay:
        {
            NSLog(@"hehe");
        }
            break;
        case NewUniformPaymentTypeAlipayWap:
        {
            NSLog(@"baba");
        }
            break;
        default:
            break;
            
    }

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
