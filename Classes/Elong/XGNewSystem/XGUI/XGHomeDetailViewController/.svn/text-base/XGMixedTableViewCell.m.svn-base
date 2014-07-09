//
//  XGMixedTableViewCell.m
//  ElongClient
//
//  Created by 李程 on 14-4-24.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "XGMixedTableViewCell.h"

@implementation XGMixedTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        UIButton *facilitiesBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        facilitiesBtn1.tag = 999;
        facilitiesBtn1.exclusiveTouch = YES;
        [facilitiesBtn1 addTarget:self action:@selector(detailAction) forControlEvents:UIControlEventTouchUpInside];
        facilitiesBtn1.frame = CGRectMake(0, 0, SCREEN_WIDTH/2, self.height);
        facilitiesBtn1.backgroundColor = [UIColor whiteColor];
        [facilitiesBtn1 setBackgroundImage:[UIImage noCacheImageNamed:@"cell_bg.png"] forState:UIControlStateHighlighted];
        [self addSubview:facilitiesBtn1];
        

        UIImageView  *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH/2)-15, 0, 5, 40)];
//        arrowView.backgroundColor = [UIColor redColor];
        arrowView.contentMode = UIViewContentModeCenter;
        arrowView.image = [UIImage imageNamed:@"ico_rightarrow.png"];//[UIImage noCacheImageNamed:@"ico_rightarrow.png"]
        [facilitiesBtn1 addSubview:arrowView];
        
        
        UILabel *facInfoLbl = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 40, 40)];
        facInfoLbl.font = [UIFont systemFontOfSize:13.0f];
        facInfoLbl.textColor = [UIColor colorWithWhite:153.0f/255.0f alpha:1.0f];
        facInfoLbl.backgroundColor = [UIColor clearColor];
        facInfoLbl.text = @"详情";
        facInfoLbl.textAlignment = UITextAlignmentRight;
        [facilitiesBtn1 addSubview:facInfoLbl];

        
        //-------------  右边   ---------------
        
        UIButton *facilitiesBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        facilitiesBtn2.tag = 1000;
        facilitiesBtn2.exclusiveTouch = YES;
        [facilitiesBtn2 addTarget:self action:@selector(evaluateAction) forControlEvents:UIControlEventTouchUpInside];
        facilitiesBtn2.frame = CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, self.height);
        facilitiesBtn2.backgroundColor = [UIColor whiteColor];
        [facilitiesBtn2 setBackgroundImage:[UIImage noCacheImageNamed:@"cell_bg.png"] forState:UIControlStateHighlighted];
        [self addSubview:facilitiesBtn2];


        UIImageView  *arrowView2 = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-15, 0, 5, 40)];
        arrowView2.contentMode = UIViewContentModeCenter;
        arrowView2.image = [UIImage noCacheImageNamed:@"ico_rightarrow.png"];
        [facilitiesBtn2 addSubview:arrowView2];

        
        //好评数  97%好评
        UILabel *commentLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 40)];
        commentLbl.font = [UIFont systemFontOfSize:14.0f];
        commentLbl.backgroundColor = [UIColor clearColor];
        commentLbl.textColor = [UIColor colorWithWhite:52.0/255.0f alpha:1];
        [facilitiesBtn2 addSubview:commentLbl];
        
        //评论条
        UILabel *commentNumLbl = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 60, 40)];
        commentNumLbl.font = [UIFont systemFontOfSize:13.0f];
        commentNumLbl.textColor = [UIColor colorWithWhite:153.0f/255.0f alpha:1.0f];
        commentNumLbl.backgroundColor = [UIColor clearColor];
        commentNumLbl.textAlignment = UITextAlignmentRight;
        [facilitiesBtn2 addSubview:commentNumLbl];

//        __block typeof(self) myCell = self;
        
        __unsafe_unretained typeof(self) myCell = self;
        
        [self performBlock:^{
            [facilitiesBtn1 addSubview:[myCell getFacilitiesView]];
            //----------------------
            NSInteger good = [[myCell.hoteldetailDict safeObjectForKey:@"GoodCommentCount"] intValue];
            NSInteger bad = [[myCell.hoteldetailDict safeObjectForKey:@"BadCommentCount"] intValue];
            if (good + bad == 0) {
                arrowView2.hidden = YES;
                commentNumLbl.hidden = YES;
                facilitiesBtn2.enabled = NO;
            }else{
                arrowView2.hidden = NO;
                commentNumLbl.hidden = NO;
                facilitiesBtn2.enabled = YES;
            }
            
            if (good + bad == 0) {
                commentLbl.text = @"暂无评论";
            }else if(good == 0 ){
                commentLbl.text = [NSString stringWithFormat:@"%d条评论",good + bad];
                commentNumLbl.text = [NSString stringWithFormat:@"%d条",bad + good];
            }else{
                NSInteger persent = ceil(good * 100/ (good + bad + 0.0f));
                commentLbl.text = [NSString stringWithFormat:@"%d%%好评",persent];
                commentNumLbl.text = [NSString stringWithFormat:@"%d条",bad + good];
            }
            
        } afterDelay:.2];
        
        
        UIView *spratorLine = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_SCALE, self.height)];
        spratorLine.backgroundColor = [UIColor grayColor];
        [self addSubview:spratorLine];
        
        
        _bottomLineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-SCREEN_SCALE, 320, SCREEN_SCALE)];
        _bottomLineImgView.image = [UIImage imageNamed:@"dashed.png"];
        [self addSubview:_bottomLineImgView];
    }
    return self;
}



// 构造酒店设置界面
- (UIView *) getFacilitiesView
{
    float cellWidth = 25;
    UIScrollView *hotelFacilityView = [[UIScrollView alloc] initWithFrame:CGRectMake(2, 0, cellWidth * 4, 44)];
    hotelFacilityView.showsHorizontalScrollIndicator = NO;
    hotelFacilityView.showsVerticalScrollIndicator = NO;
    hotelFacilityView.scrollsToTop = NO;
    
    NSInteger count = 0;
    BOOL swimming = NO;
    BOOL wifi = NO;
    BOOL park = NO;
    BOOL airplane = NO;

    long hotelFacilityCode = [[self.hoteldetailDict safeObjectForKey:@"HotelFacilityCode"] longValue];
    NSLog(@"hotelFacilityCode==%ld",hotelFacilityCode);
    
//    long hotelFacilityCode = 28689;
    //test
    for (int i = 0; i < 15;i++) {
        if((hotelFacilityCode & (1 << i)) > 0){
            
            UILabel *flcodeDesp=[[UILabel alloc] initWithFrame:CGRectMake(count * cellWidth, 25, cellWidth, 25)];
            flcodeDesp.textAlignment=UITextAlignmentCenter;
            flcodeDesp.numberOfLines=0;
            flcodeDesp.font= [UIFont systemFontOfSize:8.0f];
            flcodeDesp.adjustsFontSizeToFitWidth=YES;
            flcodeDesp.backgroundColor = [UIColor clearColor];
            flcodeDesp.textColor=[UIColor colorWithRed:118/255.0f green:118/255.0f blue:118/255.0f alpha:1];
            [hotelFacilityView addSubview:flcodeDesp];
            
            UIImageView *facImageView = [[UIImageView alloc] initWithFrame:CGRectMake(count * cellWidth, 0, cellWidth, 40)];
            facImageView.contentMode = UIViewContentModeCenter;
            [hotelFacilityView addSubview:facImageView];
            
            count++;
            switch (i) {
                case 0:
                    wifi = YES;
                    facImageView.image = [UIImage noCacheImageNamed:@"room_wifi.png"];
                    //flcodeDesp.text=@"WIFI";
                    break;
                case 1:
                    if (wifi) {
                        count--;
                        [facImageView removeFromSuperview];
                        [flcodeDesp removeFromSuperview];
                    }else{
                        facImageView.image = [UIImage noCacheImageNamed:@"room_wifi.png"];
                        //flcodeDesp.text=@"WIFI";
                    }
                    break;
                case 2:
                    count--;
                    [facImageView removeFromSuperview];
                    [flcodeDesp removeFromSuperview];
                    break;
                case 3:
                    count--;
                    [facImageView removeFromSuperview];
                    [flcodeDesp removeFromSuperview];
                    break;
                case 4:
                    park = YES;
                    facImageView.image = [UIImage noCacheImageNamed:@"room_park.png"];
                    //flcodeDesp.text=@"停车场";
                    break;
                case 5:
                    if (park) {
                        count--;
                        [facImageView removeFromSuperview];
                        [flcodeDesp removeFromSuperview];
                    }else{
                        facImageView.image = [UIImage noCacheImageNamed:@"room_park.png"];
                        //flcodeDesp.text=@"停车场";
                    }
                    break;
                case 6:
                    airplane = YES;
                    facImageView.image = [UIImage noCacheImageNamed:@"room_airplane.png"];
                    //flcodeDesp.text=@"接机";
                    break;
                case 7:
                    if (airplane) {
                        count--;
                        [facImageView removeFromSuperview];
                        [flcodeDesp removeFromSuperview];
                    }else{
                        facImageView.image = [UIImage noCacheImageNamed:@"room_airplane.png"];
                        //flcodeDesp.text=@"接机";
                    }
                    break;
                case 8:
                    swimming = YES;
                    facImageView.image = [UIImage noCacheImageNamed:@"room_swimming.png"];
                    //flcodeDesp.text=@"游泳池";
                    break;
                case 9:
                    if (swimming) {
                        count--;
                        [facImageView removeFromSuperview];
                        [flcodeDesp removeFromSuperview];
                    }else{
                        facImageView.image = [UIImage noCacheImageNamed:@"room_swimming.png"];
                        //flcodeDesp.text=@"游泳池";
                    }
                    break;
                case 10:
                    facImageView.image = [UIImage noCacheImageNamed:@"room_Fitness.png"];
                    //flcodeDesp.text=@"健身房";
                    break;
                case 11:
                    facImageView.image = [UIImage noCacheImageNamed:@"room_printing.png"];
                    //flcodeDesp.text=@"商务中心";
                    break;
                case 12:
                    facImageView.image = [UIImage noCacheImageNamed:@"room_meeting.png"];
                    //flcodeDesp.text=@"会议室";
                    break;
                case 13:
                    facImageView.image = [UIImage noCacheImageNamed:@"room_breakfast.png"];
                    //flcodeDesp.text=@"餐厅";
                    break;
                case 14:
                    facImageView.image = [UIImage noCacheImageNamed:@"room_online.png"];
                    //flcodeDesp.text=@"宽带";
                    break;
                default:
                    break;
            }
        }
    }
    hotelFacilityView.contentSize = CGSizeMake(cellWidth * count, 44);
    hotelFacilityView.userInteractionEnabled = NO;
    
    return hotelFacilityView;

}

//详情
-(void)detailAction{
    self.detailBlock();
    
}
//评价
-(void)evaluateAction{
    self.evaluateBlock();
}


-(void)layoutSubviews{
    [super layoutSubviews];
}

-(void)dealloc{

}



- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
