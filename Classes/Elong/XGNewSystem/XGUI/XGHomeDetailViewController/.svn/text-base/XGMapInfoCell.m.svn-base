//
//  XGMapInfoCell.m
//  ElongClient
//
//  Created by 李程 on 14-4-24.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "XGMapInfoCell.h"
#import "PositioningManager.h"

@interface XGMapInfoCell()


@end


@implementation XGMapInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 62);
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        UIButton *facilitiesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        facilitiesBtn.tag = 999;
        facilitiesBtn.exclusiveTouch = YES;
        [facilitiesBtn addTarget:self action:@selector(mapBtnClick) forControlEvents:UIControlEventTouchUpInside];
        facilitiesBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.height);
        facilitiesBtn.backgroundColor = [UIColor whiteColor];
        [facilitiesBtn setBackgroundImage:[UIImage noCacheImageNamed:@"cell_bg.png"] forState:UIControlStateHighlighted];
        [self addSubview:facilitiesBtn];


        UIImageView *mapInfoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 6, 60, 50)];
        mapInfoView.contentMode = UIViewContentModeCenter;
        mapInfoView.image = [UIImage noCacheImageNamed:@"groupon_detail_map.png"];
        [facilitiesBtn addSubview:mapInfoView];


        //地址
        UILabel *addressLbl = [[UILabel alloc] initWithFrame:CGRectMake(50, 12, 230, 50)];
        addressLbl.tag = 1001;
        addressLbl.backgroundColor = [UIColor clearColor];
        addressLbl.font = [UIFont systemFontOfSize:12.0f];
        addressLbl.textColor = RGBACOLOR(52, 52, 52, 1);
        addressLbl.lineBreakMode = UILineBreakModeCharacterWrap;
        addressLbl.numberOfLines = 0;
        [facilitiesBtn addSubview:addressLbl];

        //addressLbl.realText = [hoteldetail safeObjectForKey:@"Address"];
        

        
        //距离当前多少公里
        UILabel *distanceLbl = [[UILabel alloc] initWithFrame:CGRectMake(254 - 74, 36, 74, 25)];
        distanceLbl.tag = 1002;
        distanceLbl.font = [UIFont systemFontOfSize:12.0f];
        distanceLbl.textColor = [UIColor colorWithWhite:137.0f/255.0f alpha:1.0f];
        distanceLbl.backgroundColor = [UIColor clearColor];
        distanceLbl.textAlignment = UITextAlignmentRight;
        [self addSubview:distanceLbl];
        distanceLbl.frame = CGRectMake(254 - 78, 50 - 28, 74, 25);

        
        UIImageView  *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(306, 0, 5, 50)];
        arrowView.contentMode = UIViewContentModeCenter;
        arrowView.image = [UIImage noCacheImageNamed:@"ico_rightarrow.png"];
        [facilitiesBtn addSubview:arrowView];
        
        
        _topLineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREEN_SCALE)];
        _topLineImgView.image = [UIImage imageNamed:@"dashed.png"];
        [self addSubview:_topLineImgView];
        
        _bottomLineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-SCREEN_SCALE, 320, SCREEN_SCALE)];
        _bottomLineImgView.image = [UIImage imageNamed:@"dashed.png"];
        [self addSubview:_bottomLineImgView];

        
    }
    return self;
}

- (NSString *) resetHotelAddress:(float *)height
{
//    NSString *addressStr = @"北京天安门知春路五道口上地地铁旁麦当劳(屌丝一坨坨)";
    //test
    NSString *addressStr = [self.hoteldetailDict safeObjectForKey:@"Address"];
    if (addressStr.length > 32) {
        addressStr = [NSString stringWithFormat:@"%@...",[addressStr substringToIndex:32]];
    }
    CGSize size = CGSizeMake(200, 1000);
    CGSize newSize = [addressStr sizeWithFont:[UIFont systemFontOfSize:12.0f]
                            constrainedToSize:size lineBreakMode:UILineBreakModeCharacterWrap];
    *height = newSize.height;
    return addressStr;
}



-(void)layoutSubviews{
    [super layoutSubviews];
    
    UIButton *bg_btn = (UIButton *)[self viewWithTag:999];
    UILabel *addressLbl = (UILabel *)[bg_btn viewWithTag:1001];
    UILabel *distanceLbl = (UILabel *)[bg_btn viewWithTag:1002];
    
    float addressLineHeight = 0;
    
    // 计算酒店所在位置与自己的距离
    if ([_hoteldetailDict safeObjectForKey:@"Latitude"] != [NSNull null]
        && [_hoteldetailDict safeObjectForKey:@"Longitude"] != [NSNull null]
        && [_hoteldetailDict safeObjectForKey:@"Latitude"]
        && [_hoteldetailDict safeObjectForKey:@"Longitude"]) {
        
        PositioningManager *posManager = [PositioningManager shared];
        float latitude = [[_hoteldetailDict safeObjectForKey:@"Latitude"] floatValue];
        float longitude = [[_hoteldetailDict safeObjectForKey:@"Longitude"] floatValue];
        
        if (latitude != 0 || longitude != 0) {
            CLLocation *userLocation = [[CLLocation alloc] initWithLatitude:posManager.myCoordinate.latitude longitude:posManager.myCoordinate.longitude];
            CLLocation *hotelLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
            
            
            float distance = [userLocation distanceFromLocation :hotelLocation]/1000.0f;
            if(distance > 100){
                [distanceLbl setText:@""];
                // 在买有自己位置的情况下重新计算地址长度
//                addressLbl.text = [self resetHotelAddress:&addressLineHeight];
            }else{
                if (distance < 0.1) {
                    [distanceLbl setText:[NSString stringWithFormat:@"距您%.0f米",distance * 1000]];
                }else{
                    [distanceLbl setText:[NSString stringWithFormat:@"距您%.1f公里",distance]];
                }
            }
            
        }else{
            distanceLbl.text = @"";
            // 在买有自己位置的情况下s重新计算地址长度
//            addressLbl.text = [self resetHotelAddress:&addressLineHeight];
        }
    }else{
        distanceLbl.text = @"";
        // 在买有自己位置的情况下重新计算地址长度
//        addressLbl.text = [self resetHotelAddress:&addressLineHeight];
    }
    addressLbl.text = [self resetHotelAddress:&addressLineHeight];
    
    if (addressLineHeight < 20) {
        addressLbl.frame = CGRectMake(60, 1, 230, 50);
    }else{
        addressLbl.frame = CGRectMake(60, 6, 230, 50);
    }
}


-(void)mapBtnClick{
    self.mapActionBlock();
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
