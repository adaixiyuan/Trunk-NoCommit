//
//  HomePhoneViewController.h
//  ElongClient
//
//  Created by Dawn on 13-12-26.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "DPNav.h"


@protocol HomePhoneViewControllerDelegate;
@interface HomePhoneViewController : UIViewController<UIActionSheetDelegate>{

}
@property (nonatomic,assign) id<HomePhoneViewControllerDelegate> delegate;
@end

@protocol HomePhoneViewControllerDelegate <NSObject>
@optional
- (void) homePhoneVCDismiss:(HomePhoneViewController *)homePhoneVC;

@end