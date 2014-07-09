//
//  GrouponBuyTipsCell.h
//  ElongClient
//  购买须知cell(web实现)
//  Created by garin on 14-6-3.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GrouponDetailCellDelegate.h"

@interface GrouponBuyTipsCell : UITableViewCell<UIWebViewDelegate>
{
    UIView *bgImageView;
    UIImageView *downSplitView;
    UIWebView *webView;
    UIActivityIndicatorView *activeView;
}

@property (nonatomic,assign) id<GrouponDetailCellDelegate> delegate;

//-(void) addPurchView:(NSArray *) tipsArr;

-(void) setBuyTipsArray:(NSArray *) tipsArr;

@end
