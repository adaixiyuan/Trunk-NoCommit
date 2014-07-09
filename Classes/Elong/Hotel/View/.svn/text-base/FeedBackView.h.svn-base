//
//  FeedBackView.h
//  ElongClient
//
//  Created by nieyun on 14-6-4.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FullHouseRequest.h"
#define DefaultTextLenth 100
@protocol FeedBackDelegate <NSObject>

- (void) finishiCommit:(UIScrollView *)feedView;

@end
@interface FeedBackView : UIScrollView<UITextViewDelegate,FullHouseDelegate,UIAlertViewDelegate,UIScrollViewDelegate>
{
    UILabel  *placehoder;
    FullHouseRequest  *houseRequest;
    UIView  *bgview;
    float  firstTop;
    UIButton  *cancelBt ;
    NSMutableString  *commitStr;
    int defautLenth;//默认字符长度
}
- (void)show;
- (id)initWithFrame:(CGRect)frame OrderDic:(NSDictionary *)dic  addInView:(UIView *) view;

@property (retain, nonatomic) IBOutlet UITextView *feedBackTextView;
@property (nonatomic,assign) id <FeedBackDelegate> feeddDelegate;
@end

