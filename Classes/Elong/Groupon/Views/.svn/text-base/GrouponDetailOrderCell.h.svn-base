//
//  GrouponDetailOrderCell.h
//  ElongClient
//
//  Created by Dawn on 13-7-18.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GrouponDetailCellDelegate.h"

@interface GrouponDetailOrderCell : UITableViewCell<UIWebViewDelegate>
{
@private
    UIView *bgImageView;
    UIImageView *downSplitView;
    
    NSString *shortString;  //缩略文字
    NSString *allString; //全部文字
    BOOL isShowAllState;         //是否显示全部
    UIButton *moreButton;    //更多
    
    UIWebView *webView;
}

@property (nonatomic,assign) id<GrouponDetailCellDelegate> delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier detail:(NSString *) detail curDelegate:(id)curDelegate;

-(float) getDetailLabelHeight;

@end
