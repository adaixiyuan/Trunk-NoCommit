//
//  ShareBtnView.h
//  ElongClient
//
//  Created by Ivan.xu on 12-9-25.
//  Copyright 2012 elong. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ShareBtnViewDelegate <NSObject>

-(void)clickShareBtn:(int)tag;

@end

@interface ShareBtnView : UIView {
	UIButton *btn;
	UILabel *textLabel;
	id<ShareBtnViewDelegate> delegate;
    UIActivityIndicatorView *activityView;
}

@property(nonatomic,assign) id<ShareBtnViewDelegate> delegate;
@property (nonatomic,readonly) UIActivityIndicatorView *activityView;

-(id) initWithBtnImage:(UIImage *)image withTitle:(NSString *)title andTag:(int)tag delegate:(id)object;

-(void)clickBtn:(id)sender;

@end
