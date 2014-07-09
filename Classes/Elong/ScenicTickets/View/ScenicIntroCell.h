//
//  ScenicIntroCell.h
//  ElongClient
//
//  Created by jian.zhao on 14-5-15.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  ImageTapDelegate <NSObject>

-(void)tapTheImageBtn;

@end

@interface ScenicIntroCell : UITableViewCell<UIGestureRecognizerDelegate>
@property (nonatomic,assign) id<ImageTapDelegate>delegate;
@property (retain, nonatomic) IBOutlet UIImageView *mainImage;
@property (retain, nonatomic) IBOutlet UILabel *imageNums;
@property (retain, nonatomic) IBOutlet UILabel *scenicIntro;

@end
