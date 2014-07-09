//
//  RateCell.m
//  ElongClient
//
//  Created by Jian.zhao on 13-12-25.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "RateCell.h"
#import "RateModel.h"
#import "CustomTextField.h"
#import "CTField.h"

#define Line_Color [UIColor colorWithRed:188.0f / 255 green:188.0f / 255 blue:188.0f / 255 alpha:1.0f]
#define ICON_BIG_WIDTH 65
#define ICON_BIG_HEIGHT 44

#define ICON_SMALL_WIDTH 26
#define ICON_SMALL_HEIGHT 17.5

#define ADD_TAG 100000

@implementation RateCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        CGFloat cell_Height = 0.0;
        if ([reuseIdentifier isEqualToString:@"Cell_Main"]) {
            
            self.backgroundColor = [UIColor clearColor];
            
            bottomView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 6.0f,320.0f, 64)];
            bottomView.backgroundColor = [UIColor clearColor];
            [self addSubview:bottomView];
            
            
            //首页的
            cell_Height = 76.0f;
            //
            main  =YES;
            
            [self addSubview:[UIImageView dashedHalfLineWithFrame:CGRectMake(0, 6, 320, 1)]];

            CGRect imageFrame = CGRectMake(26, 16, ICON_BIG_WIDTH, ICON_BIG_HEIGHT);
            _icon_Big = [[UIImageView alloc] initWithFrame:imageFrame];
            [self addSubview:_icon_Big];
            
            CGRect simpleFrame = CGRectMake(0,0, 200, 14);
            _SimpleTroduce = [[UILabel alloc] initWithFrame:simpleFrame];
            _SimpleTroduce.backgroundColor = [UIColor clearColor];
            _SimpleTroduce.font = [UIFont boldSystemFontOfSize:15.0f];
            _SimpleTroduce.textColor = RGBACOLOR(187, 187, 187, 1);
            
            CGRect resultFrame = CGRectMake(imageFrame.origin.x+ICON_BIG_WIDTH+10, 0.0f, SCREEN_WIDTH-(imageFrame.origin.x+ICON_BIG_WIDTH+10), cell_Height);
            
            _result = [[CTField alloc] initWithFrame:resultFrame andType:CT_Exchange_Tap];
            _result.returnKeyType = UIReturnKeyDone;
            _result.borderStyle = UITextBorderStyleNone;
            _result.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            _result.backgroundColor =[UIColor clearColor];
            _result.clearsOnBeginEditing  = YES;
            _result.placeholder = @"";
            _result.textColor = RGBACOLOR(52, 52, 52, 1.0);
            _result.delegate = self;
            
            _result.leftView = _SimpleTroduce;
            _result.leftViewMode = UITextFieldViewModeAlways;
            
            _result.font = [UIFont boldSystemFontOfSize:30.0f];
            [self addSubview:_result];
            
            [self addSubview:[UIImageView dashedHalfLineWithFrame:CGRectMake(0, cell_Height-6, 320,1)]];
        
        }else if ([reuseIdentifier isEqualToString:@"Cell_List"]){
            //列表页.
            main = NO;
           // cell_Height = 44.0f;
            
            CGRect imageFrame = CGRectMake(17, 13, ICON_SMALL_WIDTH, ICON_SMALL_HEIGHT);
            _icon_Small = [[UIImageView alloc] initWithFrame:imageFrame];
            [self addSubview:_icon_Small];
            
            CGRect desFrame = CGRectMake(imageFrame.origin.x+ICON_SMALL_WIDTH+10, 15.5, 200, 15);
            _description = [[UILabel alloc] initWithFrame:desFrame];
            _description.backgroundColor = [UIColor clearColor];
            _description.font = [UIFont systemFontOfSize:15.0f];
            _description.textColor = RGBACOLOR(52, 52, 52, 1);
            [self addSubview:_description];
            
        }
        
    }
    return self;
}

-(void)displayTheAddTip{

    if (main) {
        //
        self.icon_Big.image = [UIImage imageNamed:@"rate_add.png"];//图片
        //_SimpleTroduce.hidden = YES;
        _result.hidden = YES;
        
        UIView *v  = [self viewWithTag:ADD_TAG];
        if (!v) {
            UILabel *tip = [[UILabel alloc] initWithFrame:CGRectMake(_icon_Big.frame.origin.x+_icon_Big.frame.size.width+15, _icon_Big.frame.origin.y+5, 200, 34)];
            tip.text = @"点击添加国家";
            tip.backgroundColor = [UIColor clearColor];
            tip.font = [UIFont systemFontOfSize:24.0f];
            tip.textColor = RGBACOLOR(213, 213, 213, 1.0);
            tip.tag = ADD_TAG;
            [self addSubview:tip];
            [tip release];
        }
    }
}


-(void)bindingTheModel:(RateModel *)model{
    
    self.cellModel = model;
    
    if (main) {
        //首页
        
        UIView *v = [self viewWithTag:ADD_TAG];
        if (v) {
            [v removeFromSuperview];
            v = nil;
        }
        
        //_SimpleTroduce.hidden = NO;
        _result.hidden = NO;
        
        self.icon_Big.image = [UIImage imageNamed:[NSString stringWithFormat:@"b_%@.png",model.simplyName]];
        self.SimpleTroduce.text = [model.simplyName stringByAppendingString:[self getMoneyNameFromString:model.name]];
        self.result.text = [NSString stringWithFormat:@"%.2f",model.rate];

        
    }else{
        
        self.icon_Small.image =  [UIImage imageNamed:[NSString stringWithFormat:@"s_%@.png",model.simplyName]];
        self.description.text = [[model.simplyName stringByAppendingString:@" "] stringByAppendingString:model.name];
        
    }
}

-(NSString *)getMoneyNameFromString:(NSString *)aString{

    if (nil != [aString componentsSeparatedByString:@"("] && [[aString componentsSeparatedByString:@"("] count] != 0) {
        return  [[aString componentsSeparatedByString:@"("] objectAtIndex:0];
    }
    return @"";
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if (main) {
        [_result resignFirstResponder];
    }
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted) {
        if (main) {
            
            bottomView.backgroundColor = [UIColor clearColor];//可以设置高亮颜色
        }
    }
    else {
        if (main) {
            bottomView.backgroundColor = [UIColor whiteColor];
        }
    }
}

#pragma mark
#pragma mark UITextFieldDelegate


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    textField.text = @"";
    if (_delegate && [_delegate respondsToSelector:@selector(shouldBeginTheInputInModel:)]) {
        [_delegate shouldBeginTheInputInModel:self.cellModel];
    }
    
    bottomView.backgroundColor = RGBACOLOR(237, 237, 237, 1.0);
    
    return YES;

}

-(void)textFieldDidEndEditing:(UITextField *)textField{

    //NSLog(@"textField.text is %@",textField.text);
    
    bottomView.backgroundColor = [UIColor clearColor];
    
    if (!STRINGHASVALUE(textField.text)) {
        self.result.text = [NSString stringWithFormat:@"%.2f",self.cellModel.rate];
        if (_delegate && [_delegate respondsToSelector:@selector(adjustTheTableFrame)]) {
            [_delegate adjustTheTableFrame];
        }
        [textField resignFirstResponder];
        return;
    }
    
    BOOL yes  = [[NSPredicate predicateWithFormat:@"SELF MATCHES '^([0-9.]+)'"] evaluateWithObject:textField.text];
    
    if (yes) {
        if (_delegate && [_delegate respondsToSelector:@selector(getUserPrintNumsWithString:andModel:)]) {
            [_delegate getUserPrintNumsWithString:textField.text andModel:self.cellModel];
        }
    }else{
    
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"只能输入数字" delegate:nil cancelButtonTitle:_string(@"s_ok") otherButtonTitles:nil];
		[alert show];
		[alert release];
    }
    [textField resignFirstResponder];

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    return YES;
}

- (void)dealloc
{
    if (_icon_Big) {
        SFRelease(_icon_Big);
    }
    if (_icon_Small) {
        SFRelease(_icon_Small);
    }
    
    if (_SimpleTroduce) {
        SFRelease(_SimpleTroduce);
    }
    
    if (_result) {
        SFRelease(_result);
    }
    
    if (_description) {
        SFRelease(_description);
    }
    self.cellModel = nil;
    
    [super dealloc];
}

@end
