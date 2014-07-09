//
//  UMengUFPViewController.h
//  ElongClient
//
//  Created by Dawn on 13-11-12.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "DPNav.h"

#import "UMUFPTableView.h"
@protocol UMengUFPViewControllerDelegate;

@interface UMengUFPViewController : DPNav <UITableViewDelegate, UITableViewDataSource, UMUFPTableViewDataLoadDelegate> {
    
    UMUFPTableView *_mTableView;
    
    UIView *_mLoadingWaitView;
    UILabel *_mLoadingStatusLabel;
    UIImageView *_mNoNetworkImageView;
    UIActivityIndicatorView *_mLoadingActivityIndicator;
}
@property (nonatomic,assign) id <UMengUFPViewControllerDelegate> delegate;

@end

@protocol UMengUFPViewControllerDelegate <NSObject>
@optional
- (void) umengUFPVC:(UMengUFPViewController *)ufpVC statusEnable:(BOOL)enable;

@end