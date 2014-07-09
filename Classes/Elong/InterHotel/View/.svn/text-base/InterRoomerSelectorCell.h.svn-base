//
//  InterRoomerSelectorCell.h
//  ElongClient
//
//  Created by Dawn on 13-6-18.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    HeaderCell,
    MiddleCell,
    FooterCell,
    NormalCell
} InterRoomerSelectorCellType;

typedef enum {
    Roomer,
    Adult,
    Child
} InterRoomerSelectorCellPersonType;

@protocol InterRoomerSelectorCellDelegate;
@interface InterRoomerSelectorCell : UITableViewCell{
@private
    UIImageView *arrowView;
    UILabel *titleLabel;
    UIView *actionView;
    UIButton *minusBtn;
    UIButton *plusBtn;
    UILabel *numLbl;
    UILabel *tipsLbl;
    UIImageView *splitTopView;
    UIImageView *splitBottomView;
    id delegate;
}

@property (nonatomic,assign) InterRoomerSelectorCellType cellType;
@property (nonatomic,readonly) UILabel *titleLabel;
@property (nonatomic,readonly) UIButton *minusBtn;
@property (nonatomic,readonly) UIButton *plusBtn;
@property (nonatomic,readonly) UILabel *numLbl;
@property (nonatomic,assign)   NSMutableDictionary *roomDict;
@property (nonatomic,assign)   BOOL selectabled;
@property (nonatomic,assign)   NSInteger minNum;
@property (nonatomic,assign)   NSInteger maxNum;
@property (nonatomic,assign)   id <InterRoomerSelectorCellDelegate> delegate;
@property (nonatomic,assign)   InterRoomerSelectorCellPersonType personType;
@property (nonatomic,readonly)   UILabel *tipsLbl;
- (void) setArrowHidden:(BOOL)hidden;
- (void) setActionHidden:(BOOL)hidden;
- (void) setTipsHidden:(BOOL)hidden;
- (void) reset;
@end


@protocol InterRoomerSelectorCellDelegate <NSObject>
@optional
- (void) interRoomerSelectorCell:(InterRoomerSelectorCell *)cell minusButtonClick:(id)sender;
- (void) interRoomerSelectorCell:(InterRoomerSelectorCell *)cell plusButtonClick:(id)sender;

@end