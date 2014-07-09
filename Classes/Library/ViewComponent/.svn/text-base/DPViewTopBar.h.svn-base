//
//  DPViewTopBar.h
//  ElongClient
//
//  Created by dengfang on 11-1-27.
//  Copyright 2011 shoujimobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPViewTopBarDelegate.h"

@interface DPViewTopBar : UIViewController {
	id<DPViewTopBarDelegate> delegate;
	UILabel *titleLabel;
	UIButton *leftBtn;
	UIButton *rightBtn;
}

@property (nonatomic, assign) id <DPViewTopBarDelegate> delegate;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIButton *leftBtn;
@property (nonatomic, retain) UIButton *rightBtn;

- (id)init:(NSString *)titleText;

@end
