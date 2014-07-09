//
//  HotelUploadImageCell.h
//  ElongClient
//
//  Created by chenggong on 14-3-31.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HotelUploadImageCellDelegate <NSObject>

- (void)imageNameTextFieldBeginEdit:(NSUInteger)cellTag;
- (void)imageNameTextFieldReturn:(NSString *)name tag:(NSUInteger)cellTag;
- (void)imageTypeButtonClicked:(NSUInteger)cellTag;

@end

@interface HotelUploadImageCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic, assign) id<HotelUploadImageCellDelegate> delegate;
@property (nonatomic, retain) UIButton *imageTypeButton;
@property (nonatomic, retain) UITextField *imageName;
@property (nonatomic, retain) UILabel *statusLabel;
@property (nonatomic, retain) UIActivityIndicatorView *loadingView;

@end
