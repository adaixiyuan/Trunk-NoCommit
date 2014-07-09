//
//  GrouponPriceCell.h
//  ElongClient
//
//  Created by garin on 14-4-23.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GrouponPriceCell : UITableViewCell
{
    UIView *bgImageView;
    
    UILabel *firstLabel;
    UILabel *secondLabel;
    UILabel *thirdLable;
    UILabel *fourthLable;
}

//设置文字名称
-(void) setLabelTxt:(NSString *) txt1 txt2:(NSString *) txt2 txt3:(NSString *) txt3 txt4:(NSString *) txt4;

//设置颜色
-(void) setLabelTxtColor:(UIColor *) color1 txt2:(UIColor *) color2 txt3:(UIColor *) color3 txt4:(UIColor *) color4;

@end
