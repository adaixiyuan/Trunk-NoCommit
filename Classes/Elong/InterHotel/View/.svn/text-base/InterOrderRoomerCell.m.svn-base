//
//  InterOrderRoomerCell.m
//  ElongClient
//
//  Created by Ivan.xu on 13-6-24.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "InterOrderRoomerCell.h"
#import "Utils.h"
#import "InterHotelDetailCtrl.h"
#import "InterFillOrderCtrl.h"

@interface InterOrderRoomerCell ()

@property(nonatomic,retain) UILabel *roomDespLB;      //房间信息
@property(nonatomic,retain) UILabel *roomerDespLB;  //入住人信息
@property(nonatomic,retain) UIButton *bedTypeBtn;       //选择床型
@property(nonatomic,retain) UIImageView *arrowImg;

-(void)clickToSelectBedType;        //选择房型

@end

@implementation InterOrderRoomerCell
@synthesize delegate;
@synthesize currentBedTypeIndex;
@synthesize roomDespLB,roomerDespLB;
@synthesize bedTypeBtn,bedTypeLB,arrowImg;
@synthesize lastnameTF,firstnameTF;


- (void)dealloc
{
    [roomDespLB release];
    [roomerDespLB release];
    [bedTypeLB release];
    [arrowImg release];
    [firstnameTF release];
    [lastnameTF release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 88)];
        bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:bgView];
        [bgView release];
        
        //选择床型
        if(!bedTypeBtn){
            bedTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        }
        self.bedTypeBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
        [self.bedTypeBtn addTarget:self action:@selector(clickToSelectBedType) forControlEvents:UIControlEventTouchUpInside];
        [Utils setButton:self.bedTypeBtn normalImage:@"" pressedImage:@"cell_bg.png"];
        [self.contentView addSubview:self.bedTypeBtn];
        
        //房间信息提示
        if(!roomDespLB){
            roomDespLB = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 44)];
        }
        self.roomDespLB.backgroundColor = [UIColor clearColor];
        self.roomDespLB.font = [UIFont systemFontOfSize:12];
        self.roomDespLB.textColor = RGBACOLOR(153, 153, 153, 1);
        [self.contentView addSubview:self.roomDespLB];
        
        //入住人信息提示
        if(!roomerDespLB){
            roomerDespLB = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, 100, 44)];
        }
        self.roomerDespLB.backgroundColor = [UIColor clearColor];
        self.roomerDespLB.textColor = RGBACOLOR(153, 153, 153, 1);
        self.roomerDespLB.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.roomerDespLB];
        

        if(!bedTypeLB){
            bedTypeLB = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 30, 44)];
        }
        self.bedTypeLB.backgroundColor = [UIColor clearColor];
        self.bedTypeLB.textAlignment = NSTextAlignmentRight;
        self.bedTypeLB.font  = [UIFont systemFontOfSize:12];
        self.bedTypeLB.minimumFontSize = 11;
        self.bedTypeLB.text = @"选择床型";
        [self.contentView addSubview:self.bedTypeLB];
        
        //默认床型是0,
        self.currentBedTypeIndex = 0;
        NSDictionary *roomInfo = [[InterHotelDetailCtrl rooms] safeObjectAtIndex:[InterRoomCell currentSelectedRoomIndex]];
        NSDictionary *bedGroup = [roomInfo safeObjectForKey:@"BedGroup"];
        if(DICTIONARYHASVALUE(bedGroup)){
            NSArray *bedItems = [bedGroup safeObjectForKey:@"BedItems"];
            if(ARRAYHASVALUE(bedItems)){
                NSDictionary *bedDesp = [bedItems safeObjectAtIndex:0];
                NSString *typeName = [bedDesp safeObjectForKey:@"BedDestciption"];
                self.bedTypeLB.text = typeName;
            }
        }
        
        if(!arrowImg){
            arrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 18, 20, 9, 5)];
        }
        self.arrowImg.image = [UIImage noCacheImageNamed:@"ico_downarrow.png"];
        [self.contentView addSubview:self.arrowImg];
        
        
        splitlineView1  = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 44 - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)] autorelease];
        splitlineView1.image = [UIImage noCacheImageNamed:@"dashed.png"];
        [self.contentView addSubview:splitlineView1];
        
        
        //姓
        if(!lastnameTF){
            lastnameTF = [[UITextField alloc] initWithFrame:CGRectMake(10, 44, (SCREEN_WIDTH - 40)/2, 44)];
        }
        self.lastnameTF.delegate = self;
        self.lastnameTF.backgroundColor = [UIColor clearColor];
        self.lastnameTF.borderStyle = UITextBorderStyleNone;
        self.lastnameTF.returnKeyType = UIReturnKeyDone;
        self.lastnameTF.placeholder = @"拼音或英文";
        self.lastnameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.lastnameTF.font = [UIFont systemFontOfSize:14];
        self.lastnameTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 24, 44)];
        UILabel *leftLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, 24, 20)];
        leftLb.backgroundColor = [UIColor clearColor];
        leftLb.textColor = [UIColor blackColor];
        leftLb.font = [UIFont systemFontOfSize:14];
        leftLb.textColor = RGBACOLOR(52, 52, 52, 1);
        leftLb.text = @"姓";
        [leftView addSubview:leftLb];
        [leftLb release];
        self.lastnameTF.leftView = leftView;
        self.lastnameTF.leftViewMode = UITextFieldViewModeAlways;
        [leftView release];
        [self.contentView addSubview:self.lastnameTF];
        self.lastnameTF.textColor = RGBACOLOR(52, 52, 52, 1);
        
        //姓
        if(!firstnameTF){
            firstnameTF = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 + 10, 44, (SCREEN_WIDTH - 40)/2, 44)];
        }
        self.firstnameTF.delegate = self;
        self.firstnameTF.backgroundColor = [UIColor clearColor];
        self.firstnameTF.borderStyle = UITextBorderStyleNone;
        self.firstnameTF.returnKeyType = UIReturnKeyDone;
        self.firstnameTF.placeholder = @"拼音或英文";
        self.firstnameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.firstnameTF.font = [UIFont systemFontOfSize:14];
        self.firstnameTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        UIView *leftView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 24, 44)];
        UILabel *leftLb2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, 24, 20)];
        leftLb2.backgroundColor = [UIColor clearColor];
        leftLb2.textColor = [UIColor blackColor];
        leftLb2.font = [UIFont systemFontOfSize:14];
        leftLb2.text = @"名";
        leftLb2.textColor = RGBACOLOR(52, 52, 52, 1);
        [leftView1 addSubview:leftLb2];
        [leftLb2 release];
        self.firstnameTF.leftView = leftView1;
        self.firstnameTF.leftViewMode = UITextFieldViewModeAlways;
        [leftView1 release];
        [self.contentView addSubview:self.firstnameTF];
        self.firstnameTF.textColor = RGBACOLOR(52, 52, 52, 1);
    
        
        //SplitLine
        UIImageView *splitLine = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 44 + 2, 1, 44 - 4)];
        splitLine.backgroundColor = [UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:0.7];
        [self.contentView addSubview:splitLine];
        [splitLine release];
        
        splitlineView0 = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_SCALE)] autorelease];
        splitlineView0.image = [UIImage noCacheImageNamed:@"dashed.png"];
        [self.contentView addSubview:splitlineView0];
        
        splitlineView2 = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 88 - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)] autorelease];
        splitlineView2.image = [UIImage noCacheImageNamed:@"dashed.png"];
        [self.contentView addSubview:splitlineView2];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//设置表类型
-(void)setCellType:(int)type{
    if(type==0){
        //第一行
        splitlineView0.hidden = NO;
        splitlineView2.hidden = NO;
    }
    else if(type==1){
        //中间
        splitlineView0.hidden = YES;
        splitlineView2.hidden = NO;

    }else if(type==2){
        //最后一行
        splitlineView0.hidden = YES;
        splitlineView2.hidden = NO;
    }else{
        splitlineView0.hidden = NO;
        splitlineView2.hidden = NO;
    }
}


//显示房型
-(void)showBedTypeOption:(BOOL)flag{
    //如果flag为Yes，则显示
    self.bedTypeLB.hidden = !flag;
    self.bedTypeBtn.hidden = !flag;
    self.arrowImg.hidden = !flag;
}

 //设置房间信息和入住人信息
-(void)setRoomDesp:(NSString *)roomDesp andRoomerDesp:(NSString *)roomerDesp{
    self.roomDespLB.text = roomDesp;
    CGSize size = [self.roomDespLB.text sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(10000, 44) lineBreakMode:UILineBreakModeCharacterWrap];
    self.roomDespLB.frame = CGRectMake(8, 0, size.width, 44);
    self.roomerDespLB.frame = CGRectMake(8+size.width, 0, 215-8-size.width, 44);
    self.roomerDespLB.text = roomerDesp;
}

//选择房型
-(void)clickToSelectBedType{
    if([delegate respondsToSelector:@selector(selectBedTypeWithCellIndex:withBedTypeName:)]){
        [delegate selectBedTypeWithCellIndex:self.tag withBedTypeName:self.bedTypeLB.text];
    }
}


#pragma mark - UITextField Delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if([delegate respondsToSelector:@selector(keyBoardWillShowWithCellIndex:)]){
        [delegate keyBoardWillShowWithCellIndex:self.tag];
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSMutableDictionary *tmpDic = [[InterFillOrderCtrl travellers] safeObjectAtIndex:self.tag-1];
    if(textField==self.lastnameTF){
        if(STRINGHASVALUE(self.lastnameTF.text)){
            NSString *lastname =  textField.text;
            [tmpDic safeSetObject:lastname forKey:@"Lastname"];
            
            NSLog(@"lastName:%@",lastname);
        }
    }else if(textField == self.firstnameTF){
        if(STRINGHASVALUE(self.firstnameTF.text)){
            NSString *firstname = textField.text;
            [tmpDic safeSetObject:firstname forKey:@"Firstname"];
            
            NSLog(@"firstname:%@",firstname);
        }
    }
    [[InterFillOrderCtrl travellers] replaceObjectAtIndex:self.tag-1 withObject:tmpDic];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if([string isEqualToString:@""]){       //删除功能
        return YES;
    }
    if(textField==self.firstnameTF){
        //名字长度不能超过25
        if(range.location>=25){
            return NO;
        }
    }else if(textField == self.lastnameTF){
        //姓的长度不能超过40
        if(range.location>=30){
            return NO;
        }
    }
    return YES;
}

@end
