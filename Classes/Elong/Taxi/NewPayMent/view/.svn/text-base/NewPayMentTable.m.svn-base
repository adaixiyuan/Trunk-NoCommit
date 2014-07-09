//
//  NewPayMentTable.m
//  ElongClient
//
//  Created by nieyun on 14-4-3.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "NewPayMentTable.h"
#import "NewPayMentCell.h"
#import "PayMentModel.h"

@implementation NewPayMentTable

- (void)dealloc
{
    [super dealloc];
    [_modelAr  release];
}

- (id)initWithFrame:(CGRect)frame withProductAr:(NSArray *)ar
{
    self = [super  initWithFrame:frame];
    if (self)
    {
        self.delegate = self;
        self.dataSource = self;
        self.modelAr = ar;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundView = nil;
        self.backgroundColor = [UIColor  clearColor];
        self.scrollEnabled = NO;
       
        self.selectedPayType = [NewPayMethodCtrl  checkAllModel:[NSIndexPath  indexPathForRow:0 inSection:0] andModelAr:self.modelAr];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.modelAr.count;
}

- (UITableViewCell  *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString *str = @"cell";
    NewPayMentCell  *cell = [tableView dequeueReusableCellWithIdentifier:str];
    
    if (!cell)
    {
        cell = [[[NSBundle  mainBundle] loadNibNamed:@"NewPayMentCell" owner:self options:nil]lastObject];
    }
    
    if (indexPath.row == 0) {
         UIImageView  *topLineView = [[UIImageView  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_SCALE)];
        
        topLineView.image = [UIImage  noCacheImageNamed:@"dashed.png"];
        [cell.contentView addSubview:topLineView];
        [topLineView release];
    }
    newCellType =[NewPayMethodCtrl checkAllModel:indexPath andModelAr:self.modelAr];
    NSString  *name =  [NSString  stringWithFormat:@"%@支付",[self  nameGet:indexPath]];
    [self  getCellFromType:newCellType andIndentify:str andName:name andCell:cell andDetaile:@""];


     NSString *checkIcon = [NewPayMethodCtrl  checkAllModel:indexPath andModelAr:self.modelAr]== _selectedPayType ? @"btn_checkbox_checked.png" : @"btn_checkbox.png";
    cell.checkBox.image = [UIImage imageNamed:checkIcon];
   
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cell_height;
}

- (void)getCellFromType:(int ) type  andIndentify:(NSString  *)indentify  andName :(NSString  *) name  andCell:(NewPayMentCell *)cell andDetaile :(NSString  *)detaile
{
    
        switch (type)
        {
            case NewUniformPaymentTypeCreditCard:
            {
                cell.payTypeIcon.image = [UIImage imageNamed:@"uniform_creditCard_icon.png"];
                cell.payTypeNameLabel.text = name;
                cell.payTypeDetailLabel.text = detaile;
                cell.clipsToBounds = YES;
            }
                break;
            case NewUniformPaymentTypeDepositCard:
            {
                cell.payTypeIcon.image = [UIImage imageNamed:@"uniform_depositCard_icon.png"];
                cell.payTypeNameLabel.text = name;
               cell.payTypeDetailLabel.text = detaile;//@"推荐有国内银行储蓄卡的用户使用";
            
                cell.clipsToBounds = YES;
            }
                break;
            case NewUniformPaymentTypeWeixin:
            {
                cell.payTypeIcon.image = [UIImage imageNamed:@"uniform_weixin_icon.png"];
                cell.payTypeNameLabel.text = name;
                cell.payTypeDetailLabel.text = @"(5.0及以上版本)";//@"推荐安装微信5.0及以上版本的用户使用";
               
                cell.clipsToBounds = YES;
            }
                break;
            case NewUniformPaymentTypeAlipay:
            {
                cell.payTypeIcon.image = [UIImage imageNamed:@"uniform_alipay_icon.png"];
                cell.payTypeNameLabel.text =name;
                 cell.payTypeDetailLabel.text = detaile;//@"推荐安装支付宝客户端的用户使用";
                cell.clipsToBounds = YES;
            }
                break;
            case NewUniformPaymentTypeAlipayWap:
            {
                cell.payTypeIcon.image = [UIImage imageNamed:@"uniform_alipay_wap_icon.png"];
                cell.payTypeNameLabel.text = name;
                cell.payTypeDetailLabel.text = detaile;//@"推荐有支付宝账户的用户使用";
                cell.clipsToBounds = YES;
            }
                break;
            default:
                break;
        }
   
}

- (NSString  *)nameGet :(NSIndexPath  *)indexPath
{
PaymentTag  *model   = [self.modelAr  safeObjectAtIndex:indexPath.row];

for  (PaymentType  *typeModel in model.paymentTypes)
{
    if ([typeModel.tagId  intValue] ==  CrediCardType)
    {
        return typeModel.typeNameCN;
    }
    else if ([typeModel.tagId   intValue]== 3)
    {
        for (PaymentProduct  *product in  typeModel.paymentProducts)
        {
            if ([product.typeId  intValue]==  WeiXinType )
            {
                return product.productNameCN;
            }else if  ([product.productCode  intValue]== AliPayApp)
            {
                return product.productNameCN;
            }else  if  ([product.productCode  intValue]== AliPayWeb)
            {
                return product.productNameCN;
            }
        }
    }
   }
    return @"";
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    iconSelect = indexPath.row;
     _selectedPayType = [NewPayMethodCtrl  checkAllModel:indexPath andModelAr:self.modelAr];
    if ([self.selectDelegate  respondsToSelector:@selector(selectPayType:)])
    {
        [self.selectDelegate  selectPayType:_selectedPayType];
    }
    [self  reloadData];
    
}




- (BOOL) checkAllArray:(NSInteger) cellType
{
    for (int i = 0;i < productAr.count; i++)
    {
        if (cellType == [[productAr  safeObjectAtIndex:i] intValue])
        {
            return YES;
        }
    }
    return NO;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
