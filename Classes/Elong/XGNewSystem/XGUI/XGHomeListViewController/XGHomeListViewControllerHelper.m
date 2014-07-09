//
//  XGHomeListViewControllerHelper.m
//  ElongClient
//
//  Created by guorendong on 14-4-30.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "XGHomeListViewControllerHelper.h"
#import "XGHomeListViewController.h"
#import "XGHotelInfo.h"
#import "XGHomeTableViewDelegateAndDataSource.h"
#import "UMengEventC2C.h"
@implementation XGHomeListViewControllerHelper

+(void)setTabsSelected:(__unsafe_unretained XGHomeListViewController *)controller
{
    //通过Tag查看排序顺序是升序还是降序
    controller.tab1.tag =controller.orderType==ListOrderByTypeDefault?controller.tab1.tag+1: 0;
    controller.tab2.tag =controller.orderType==ListOrderByTypePrice?controller.tab2.tag+1: 0;
    controller.tab3.tag =controller.orderType==ListOrderByTypeDistance?controller.tab3.tag+1: 0;
    controller.tab4.tag =controller.orderType==ListOrderByTypeStarts?controller.tab4.tag+1: 0;
    
    controller.tab1.isSelected =(controller.orderType==ListOrderByTypeDefault);
    controller.tab2.isSelected =(controller.orderType==ListOrderByTypePrice);
    controller.tab3.isSelected =(controller.orderType==ListOrderByTypeDistance);
    controller.tab4.isSelected =(controller.orderType==ListOrderByTypeStarts);
    
    
    
    //设置图片
    controller.tab2.sortArrowImageView.image=controller.orderType==ListOrderByTypePrice?(controller.tab2.tag%2?[UIImage imageNamed:@"XGRank_down"]:[UIImage imageNamed:@"XGRank_up"]):[UIImage imageNamed:@"XGRank_normal"];
    controller.tab4.sortArrowImageView.image=controller.orderType==ListOrderByTypeStarts?(controller.tab4.tag%2?[UIImage imageNamed:@"XGRank_down"]:[UIImage imageNamed:@"XGRank_up"]):[UIImage imageNamed:@"XGRank_normal"];

    UIColor *selectedColor =XGTabBackColor;
    [controller.tab1 setTabInfoForText:@"推荐" textColor:controller.tab1.isSelected?[UIColor whiteColor]:selectedColor];
    [controller.tab2 setTabInfoForText:@"价格" textColor:controller.tab2.isSelected?[UIColor whiteColor]:selectedColor];
    [controller.tab3 setTabInfoForText:@"距离" textColor:controller.tab3.isSelected?[UIColor whiteColor]:selectedColor];
    [controller.tab4 setTabInfoForText:@"星级" textColor:controller.tab4.isSelected?[UIColor whiteColor]:selectedColor];
    controller.tab1.backgroundColor=controller.tab1.isSelected?selectedColor:[UIColor whiteColor];
    controller.tab2.backgroundColor=controller.tab2.isSelected?selectedColor:[UIColor whiteColor];
    controller.tab3.backgroundColor=controller.tab3.isSelected?selectedColor:[UIColor whiteColor];
    controller.tab4.backgroundColor=controller.tab4.isSelected?selectedColor:[UIColor whiteColor];
}


+(void)setXGSegmentedControl:(__unsafe_unretained XGHomeListViewController *)controller XGSegmentedControl:(XGSegmentedControl *)seg
{
    seg.tabView1.touchTabView =^(XGTabView *tabView){
        if ([controller isInsertingAnimation]) {
            return;
        }
        //默认排序
        controller.orderType=ListOrderByTypeDefault;
        [XGHomeListViewControllerHelper setTabsSelected:controller];
        [controller.tableViewHelper sortForData:YES];
        UMENG_EVENT(UEvent_C2C_Home_List_DefaultRank)
    };
    
    seg.tabView2.touchTabView =^(XGTabView *tabView){
        //
        if ([controller isInsertingAnimation]) {
            return;
        }
        controller.orderType=ListOrderByTypePrice;
        [XGHomeListViewControllerHelper setTabsSelected:controller];
        [controller.tableViewHelper sortForData:YES];
        UMENG_EVENT(UEvent_C2C_Home_List_PriceRank)
    };
    
    seg.tabView3.touchTabView =^(XGTabView *tabView){
        //
        if ([controller isInsertingAnimation]) {
            return;
        }
        controller.orderType=ListOrderByTypeDistance;
        [XGHomeListViewControllerHelper setTabsSelected:controller];
        [controller.tableViewHelper sortForData:YES];
        UMENG_EVENT(UEvent_C2C_Home_List_DistanceRank)
    };
    
    seg.tabView4.touchTabView =^(XGTabView *tabView){
        //
        if ([controller isInsertingAnimation]) {
            return;
        }
        controller.orderType=ListOrderByTypeStarts;
        [XGHomeListViewControllerHelper setTabsSelected:controller];
        [controller.tableViewHelper sortForData:YES];
        UMENG_EVENT(UEvent_C2C_Home_List_StarRank)
    };

}

//调用返回多少家酒店的信息
+(void)calSendNum:(XGHomeListViewController *)controller
{
    if (controller.filter.sendNum<10) {
        int rand =arc4random()%5;
        rand =rand==0?1:rand;
        controller.filter.sendNum=controller.filter.sendNum>10?controller.filter.sendNum:rand*10;
        controller.filter.sendNum+=controller.filter.reponseReplayNum;
    }
    if (controller.filter.sendNum>1000) {
        controller.filter.sendNum=999;
    }
    else
    {
        int f =arc4random()%8;
        if (controller.filter.sendNum>800) {
            f =arc4random()%200<2?arc4random()%2:0;
        }
        else if(controller.filter.sendNum>700){
            f =arc4random()%20<3?arc4random()%2:0;
        }
        else if (controller.filter.sendNum>600){
            f =arc4random()%20<3?arc4random()%2:0;
        }
        else if (controller.filter.sendNum>500){
            f =arc4random()%20<3?arc4random()%2:0;
        }
        else  if (controller.filter.sendNum>400){
            f =arc4random()%10<3?arc4random()%2:0;
        }
        else  if (controller.filter.sendNum>300){
            f =arc4random()%8<3?arc4random()%5:0;
        }
        else  if (controller.filter.sendNum>200){
            f =arc4random()%5<3?arc4random()%6:0;
        }
        else if(controller.filter.sendNum>100){
            f =arc4random()%5<3?arc4random()%8:0;
        }
        
        controller.filter.sendNum =controller.filter.sendNum+f;
        if (controller.filter.sendNum<(controller.filter.reponseReplayNum+controller.tableViewHelper.dataArray.count)) {
            controller.filter.sendNum =controller.filter.reponseReplayNum+controller.tableViewHelper.dataArray.count;
        }
    }
    [controller updateSendNum];
}

+(void)cInitDisReplyNumView:(UIButton *)_disReplyNumView
{
    _disReplyNumView.backgroundColor=[UIColor colorWithRed:255.0f/255.0f green:136.0f/255.0f blue:0 alpha:1];
    
    _disReplyNumView.titleLabel.font=[UIFont systemFontOfSize:12];
    
    [_disReplyNumView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UILabel *lable =[[UILabel alloc] initWithFrame:CGRectZero];
    
    lable.tag=100;
    
    lable.textColor=[UIColor whiteColor];
    lable.backgroundColor=[UIColor clearColor];
    lable.font =[UIFont boldSystemFontOfSize:24];
    
    [_disReplyNumView addSubview:lable];
    
    UILabel *textLable =[[UILabel alloc] initWithFrame:CGRectZero];
    
    textLable.backgroundColor=[UIColor clearColor];
    textLable.tag=200;
    
    textLable.textColor=[UIColor whiteColor];
    
    textLable.font =[UIFont boldSystemFontOfSize:15];
    
    UIImageView *arrImage =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"XGArrow_white"]];
    arrImage.tag =300;
    [arrImage sizeToFit];
    arrImage.backgroundColor=[UIColor clearColor];
    arrImage.frame=CGRectMake(_disReplyNumView.width-10-arrImage.width, _disReplyNumView.height/2- arrImage.height/2, arrImage.width, arrImage.height);
    [_disReplyNumView addSubview:arrImage];
    
    [_disReplyNumView addSubview:textLable];

}
@end
