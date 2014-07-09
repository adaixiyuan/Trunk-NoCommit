//
//  WBSendViewController.h
//  Elong_iPad
//
//  Created by Wang Shuguang on 12-8-9.
//  Copyright 2012 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ElongBaseViewController.h"

typedef enum{
	Sina,
	Tencent
}WeiboStyle;

@interface WBSendViewController : ElongBaseViewController<UITextViewDelegate> {
@private
	UIImageView *imageBox;
	UITextView *textBox;
	UILabel *textTips; 
	WeiboStyle weiboStyle;
	UIButton *removeBtn;
	UIActivityIndicatorView *activityView;
	UIButton *rbtn;
}
@property(nonatomic) WeiboStyle weiboStyle;

- (void) setImageBox:(UIImage *)image;
- (void) setContent:(NSString *)txt;
-(void)setImageByNotification;

@end
