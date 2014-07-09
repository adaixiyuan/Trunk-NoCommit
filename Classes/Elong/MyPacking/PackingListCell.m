//
//  PackingListCell.m
//  ElongClient
//
//  Created by Jian.Zhao on 13-12-30.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "PackingListCell.h"
#import "PackingModel.h"
#import "PackingDefine.h"
#import "Utils.h"

#define Title_Frame                 CGRectMake(16, 20, 200, 26)
#define ProgressNum_Frame    CGRectMake(220,18, 60,30)
#define Smile_Frmae                CGRectMake(235,20,25,25)

#define SMIlE_TAG 1000

//Height 81  BackView 66
@implementation PackingListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        backView = [[UIView alloc] initWithFrame:CGRectMake(5, 7.5, 310, 66)];//10->5
        [self addSubview:backView];
        
        _title = [[UILabel alloc] initWithFrame:Title_Frame];
        _title.textColor = [UIColor whiteColor];
        _title.font = [UIFont boldSystemFontOfSize:17.0f];
        _title.textAlignment = NSTextAlignmentLeft;
        _title.backgroundColor = [UIColor clearColor];
        [backView addSubview:_title];
        
        _progressNum = [[UILabel alloc] initWithFrame:ProgressNum_Frame];
        _progressNum.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0f alpha:0.50];
        _progressNum.font = [UIFont boldSystemFontOfSize:26.0f];
        _progressNum.textAlignment = NSTextAlignmentLeft;
        _progressNum.backgroundColor = [UIColor clearColor];
        [backView addSubview:_progressNum];
        
        //右上角是否是范例的标志
        tipIcon = [UIButton buttonWithType:UIButtonTypeCustom];
        [tipIcon setFrame:CGRectMake(self.frame.size.width-38, backView.frame.origin.y-0.5, 38, 66)];//43->38
        [tipIcon setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 33, 5)];//10->5
        [tipIcon setAdjustsImageWhenHighlighted:NO];
        [tipIcon addTarget:self action:@selector(handleTheAlwaysUsedBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:tipIcon];
        
    }
    return self;
}

-(void)handleTheAlwaysUsedBtn:(UIButton *)sender{
    
    if (!self.editing) {
        if ([_packing.isFix isEqualToString:@"1"]) {
            [Utils alert:@"官方示例不可取消"];
            return;
        }
        NSString *msg = nil;
        _packing.isAlwaysUsed = ([_packing.isAlwaysUsed isEqualToString:@"1"])?@"0":@"1";
        if ([_packing.isAlwaysUsed isEqualToString:@"1"]) {
            msg = @"该行程已被设为常用示例";
            [tipIcon setImage:[UIImage imageNamed:@"corner.png"] forState:UIControlStateNormal];
        }else{
            msg = @"该行程的常用示例已被取消";
            [tipIcon setImage:nil forState:UIControlStateNormal];
        }
        if (_delegate && [_delegate respondsToSelector:@selector(refreshTheUserAlwaysUsedTemplateData:)]) {
            [_delegate refreshTheUserAlwaysUsedTemplateData:_packing];
        }
        [Utils alert:msg];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)bingThePackingModel:(PackingModel *)model{

    self.title.text = model.name;
    switch ([model.color intValue]) {
        case 0:
            backView.backgroundColor = PACKING_RED;
            break;
         case 1:
            backView.backgroundColor = PACKING_ORANGE;
            break;
         case 2:
            backView.backgroundColor = PACKING_GREEN;
            break;
          case 3:
            backView.backgroundColor = PACKING_BLUE;
            break;
          case 4:
            backView.backgroundColor = PACKING_GRAY;
            break;
        default:
            break;
    }
    if ([model.isAlwaysUsed isEqualToString:@"1"]) {
        [tipIcon setImage:[UIImage imageNamed:@"corner.png"] forState:UIControlStateNormal];
    }else{
        [tipIcon setImage:nil forState:UIControlStateNormal];
    }

    if ([model.categoryList count]>0) {
        
        if (model.progress >= 0 && model.progress < 1) {
            //
            self.progressNum.text = [[NSString stringWithFormat:@"%d",(int)(model.progress*100)] stringByAppendingString:@"%"];
        }
        [self setTheCompleteProgressWithValue:model.progress];
        
    }else{
        UIView *smile = [backView viewWithTag:SMIlE_TAG];
        if (smile) {
            [smile removeFromSuperview];
        }
        if (cover) {
            [cover removeFromSuperview];
            cover = nil;
        }
        _progressNum.hidden = NO;
        self.progressNum.text = @"--%";
    }
        _packing = model;
}



-(void)setTheCompleteProgressWithValue:(float)value{
    
    if (value >= 0.0f && value < 1) {
        
        UIView *smile = [backView viewWithTag:SMIlE_TAG];
        if (smile) {
            [smile removeFromSuperview];
        }
        
        if (!cover) {
            cover = [[UIView alloc] initWithFrame:CGRectZero];
            cover.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0f alpha:0.15];
            [backView insertSubview:cover belowSubview:_title];

        }
        [cover setFrame:CGRectMake(0, 0, value*300, 66)];
        _progressNum.hidden = NO;
        
    }else if (value >= 1){
        if (cover) {
            [cover removeFromSuperview];
            cover = nil;
        }
        _progressNum.hidden = YES;
        
        UIView *smile = [backView viewWithTag:SMIlE_TAG];
        if (!smile) {
            
            UIImageView *smile = [[UIImageView alloc] initWithFrame:Smile_Frmae];
            smile.image = [UIImage imageNamed:@"smile.png"];
            smile.tag = SMIlE_TAG;
            [backView addSubview:smile];
            [smile release];
            
        }
        

    }
}

-(void)dealloc{
    if (cover) {
        SFRelease(cover);
    }
    SFRelease(backView);
    SFRelease(_title);
    SFRelease(_progressNum);
    [super dealloc];
}

@end
