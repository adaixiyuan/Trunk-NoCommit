//
//  SelectCardCell.h
//  ElongClient
//
//  Created by dengfang on 11-1-31.
//  Copyright 2011 shoujimobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectCardCellDelegate <NSObject>

- (void)textFieldDidActive:(id)sender;
- (void)textFieldDidEnd:(id)sender;

@end

@class SelectCard, CustomTextField;
@interface SelectCardCell : UITableViewCell <UITextFieldDelegate> {
	BOOL isSelected;
	IBOutlet UIImageView *selectImgView;
	IBOutlet UILabel *nameLabel;
	IBOutlet UILabel *cardNameLabel;
	IBOutlet UILabel *cardNumLabel;
	IBOutlet UILabel *codeLabel;
}

@property (nonatomic, assign) id<SelectCardCellDelegate> selectCard;
@property (nonatomic) BOOL isSelected;
@property (nonatomic) BOOL isOverDue;
@property (nonatomic, retain) IBOutlet UIView *backView;
@property (nonatomic, retain) UIImageView *selectImgView;
@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *cardNameLabel;
@property (nonatomic, retain) UILabel *cardNumLabel;
@property (nonatomic, retain) UILabel *codeLabel;
@property (nonatomic, assign) IBOutlet UILabel *caTipLabel;
@property (nonatomic, retain) CustomTextField *cardTF;
@property (nonatomic, retain) CustomTextField *codeTF;
@property (nonatomic, retain) IBOutlet UIImageView *bottomShadow;
@property (nonatomic, retain) IBOutlet UIImageView *rightArrow;

@property (nonatomic,retain) IBOutlet UIImageView *headerView;
@property (nonatomic,retain) IBOutlet UIImageView *footerView;
@property (nonatomic,retain) IBOutlet UIImageView *topSplitView;
@property (nonatomic,retain) IBOutlet UIImageView *bottomSplitView;
@property (nonatomic,retain) IBOutlet UIImageView *innerSplitView0;
@property (nonatomic,retain) IBOutlet UIImageView *innerSPlitView1;
- (IBAction)uptextView:(id)sender;
- (IBAction)textDown:(id)sender;
- (void)setCATipHidden:(BOOL)hidden;        // 设置CA提示框是否展示

@end
