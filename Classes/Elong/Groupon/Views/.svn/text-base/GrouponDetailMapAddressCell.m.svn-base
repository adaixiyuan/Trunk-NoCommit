//
//  GrouponDetailMapAddressCell.m
//  ElongClient
//
//  Created by garin on 14-5-28.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "GrouponDetailMapAddressCell.h"
#import "PositioningManager.h"

@implementation GrouponDetailMapAddressCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
        float cellHeight = 75;
        
        // 背景色
        bgImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, cellHeight)];
        [self.contentView addSubview:bgImageView];
        bgImageView.userInteractionEnabled = YES;
        bgImageView.backgroundColor=[UIColor whiteColor];
        [bgImageView release];
        
        UIImageView *upSplitView = [[UIImageView alloc] initWithImage:[UIImage noCacheImageNamed:@"dashed.png"]];
        upSplitView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_SCALE);
        upSplitView.contentMode=UIViewContentModeScaleToFill;
        [bgImageView addSubview:upSplitView];
        [upSplitView release];
        
        addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(9, 11, 170, 0)];
        addressLabel.backgroundColor = [UIColor clearColor];
        addressLabel.font = [UIFont boldSystemFontOfSize:13];
        addressLabel.textColor = RGBACOLOR(52, 52, 52, 1);
        addressLabel.numberOfLines = 0;
        addressLabel.lineBreakMode = UILineBreakModeCharacterWrap;
        [bgImageView addSubview:addressLabel];
        [addressLabel release];
        
        poiTipsLbl = [[UILabel alloc] initWithFrame:CGRectMake(9, addressLabel.frame.origin.y + addressLabel.frame.size.height + 10, 30, 12)];
        poiTipsLbl.backgroundColor = [UIColor clearColor];
        poiTipsLbl.font = [UIFont systemFontOfSize:12.0f];
        poiTipsLbl.textColor = RGBACOLOR(129, 129, 129, 1);
        poiTipsLbl.text = @"距您";
//        [poiTipsLbl sizeToFit];
        [bgImageView addSubview:poiTipsLbl];
        [poiTipsLbl release];
        
        distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(poiTipsLbl.frame.origin.x + poiTipsLbl.frame.size.width, addressLabel.frame.origin.y + addressLabel.frame.size.height + 10, 100, 12)];
        distanceLabel.backgroundColor = [UIColor clearColor];
        distanceLabel.font = [UIFont systemFontOfSize:12.0f];
        distanceLabel.textColor = RGBACOLOR(129, 129, 129, 1);
        [bgImageView addSubview:distanceLabel];
        [distanceLabel release];
        
        // 地图图标
        mapIcon = [[UIImageView alloc] initWithFrame:CGRectMake(209, cellHeight/2 - 15 , 30, 30)];
        mapIcon.image = [UIImage noCacheImageNamed:@"groupon_detail_map.png"];
        mapIcon.contentMode = UIViewContentModeScaleToFill;
        [bgImageView addSubview:mapIcon];
        [mapIcon release];
        
        //垂直分割线
        splitView = [[UIImageView alloc] initWithFrame:CGRectMake(bgImageView.frame.size.width - 54, 7, 0.55, cellHeight - 14)];
        splitView.image = [UIImage noCacheImageNamed:@"groupon_detail_cell_split.png"];
        [bgImageView addSubview:splitView];
        [splitView release];
        
        // 电话按钮
        appointmentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        appointmentBtn.frame = CGRectMake(bgImageView.frame.size.width - 53, 0, 53, cellHeight);
        [appointmentBtn setImage:[UIImage noCacheImageNamed:@"groupon_detail_appointment.png"] forState:UIControlStateNormal];
        [appointmentBtn setTitle:@"预约咨询 " forState:UIControlStateNormal];
        [appointmentBtn setTitleColor:[UIColor colorWithRed:35.0/255.0f green:119.0/255.0f blue:232.0/255.0f alpha:1] forState:UIControlStateNormal];
        [appointmentBtn setTitleColor:[UIColor colorWithRed:17.0/255.0f green:82.0/255.0f blue:142.0/255.0f alpha:1] forState:UIControlStateHighlighted];
        appointmentBtn.titleLabel.font = [UIFont systemFontOfSize:9.0f];
        appointmentBtn.contentEdgeInsets = UIEdgeInsetsMake(22, -16, 0, 0);
        appointmentBtn.imageEdgeInsets = UIEdgeInsetsMake(-36, 27, 0, 0);
        appointmentBtn.backgroundColor = [UIColor clearColor];
        [appointmentBtn addTarget:self action:@selector(appointmentBtn:) forControlEvents:UIControlEventTouchUpInside];
        [bgImageView addSubview:appointmentBtn];
        
        downSplitView = [[UIImageView alloc] initWithImage:[UIImage noCacheImageNamed:@"dashed.png"]];
        downSplitView.frame = CGRectMake(0, cellHeight- SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE);
        downSplitView.contentMode=UIViewContentModeScaleToFill;
        [bgImageView addSubview:downSplitView];
        [downSplitView release];
    }
    return self;
}

- (void) appointmentBtn:(id)sender
{
    if ([_delegate respondsToSelector:@selector(appointmentCellAppoint)])
    {
        [_delegate appointmentCellAppoint];
    }
}

- (void) setAddress:(NSString *)address coordinate:(CLLocationCoordinate2D)coordinate
{
    addressLabel.text = address;
    
    poiTipsLbl.hidden = NO;
    
    //设置距离
    if (coordinate.latitude == 0 && coordinate.longitude == 0)
    {
        distanceLabel.text =@"";
        poiTipsLbl.hidden = YES;
    }
    else
    {
        PositioningManager *poi = [PositioningManager shared];
        
        CLLocation *myLocation = [[CLLocation alloc] initWithLatitude:poi.myCoordinate.latitude longitude:poi.myCoordinate.longitude];
        CLLocation *hotelLocation = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        CLLocationDistance distance = [myLocation distanceFromLocation:hotelLocation];
        [myLocation release];
        [hotelLocation release];
        
        if (distance<100) {
            distanceLabel.text = [NSString stringWithFormat:@"%.f米",distance];
        }else{
            if (distance/1000>100) {
                distanceLabel.text =@"";
                poiTipsLbl.hidden = YES;
            }else{
                distanceLabel.text = [NSString stringWithFormat:@"%.1f公里",distance/1000];
            }
        }
    }
    
    CGSize txtSize = [addressLabel.text sizeWithFont:addressLabel.font constrainedToSize:CGSizeMake(addressLabel.frame.size.width, MAXFLOAT) lineBreakMode:UILineBreakModeCharacterWrap];
    addressLabel.frame = CGRectMake(addressLabel.frame.origin.x, addressLabel.frame.origin.y , addressLabel.frame.size.width, txtSize.height);

    poiTipsLbl.frame = CGRectMake(poiTipsLbl.frame.origin.x, addressLabel.frame.origin.y + addressLabel.frame.size.height + 5,
                                     poiTipsLbl.frame.size.width, poiTipsLbl.frame.size.height);
    
    distanceLabel.frame = CGRectMake(distanceLabel.frame.origin.x, addressLabel.frame.origin.y + addressLabel.frame.size.height + 5,
                                     distanceLabel.frame.size.width, distanceLabel.frame.size.height);
    
    if (poiTipsLbl.hidden)
    {
        downSplitView.frame = CGRectMake(downSplitView.frame.origin.x, addressLabel.frame.origin.y + addressLabel.frame.size.height  + 10,
                                         downSplitView.frame.size.width, downSplitView.frame.size.height);
    }
    else
    {
        downSplitView.frame = CGRectMake(downSplitView.frame.origin.x, distanceLabel.frame.origin.y + distanceLabel.frame.size.height + 10,
                                         downSplitView.frame.size.width, downSplitView.frame.size.height);
    }
    
    bgImageView.frame = CGRectMake(bgImageView.frame.origin.x, bgImageView.frame.origin.y, bgImageView.frame.size.width, downSplitView.frame.origin.y + downSplitView.frame.size.height);
    
    float cellNewHeight = bgImageView.frame.size.height;
    
    splitView.frame = CGRectMake(splitView.frame.origin.x, 7, 0.55, cellNewHeight - 14);
    mapIcon.frame = CGRectMake(mapIcon.frame.origin.x, cellNewHeight/2 - mapIcon.frame.size.height/2, mapIcon.frame.size.width, mapIcon.frame.size.height);
    appointmentBtn.frame = CGRectMake(appointmentBtn.frame.origin.x, 0 , appointmentBtn.frame.size.width, cellNewHeight);
}
@end
