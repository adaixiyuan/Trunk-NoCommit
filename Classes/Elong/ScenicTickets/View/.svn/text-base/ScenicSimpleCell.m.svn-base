//
//  ScenicSimpleCell.m
//  ElongClient
//
//  Created by Jian.Zhao on 14-5-5.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ScenicSimpleCell.h"
#import "ScenicTicketsPublic.h"

@implementation CustomLable

-(id) initWithFrame:(CGRect)frame andInsets: (UIEdgeInsets) insets{
    
    self = [super initWithFrame:frame];
    if(self){
        self.insets = insets;
    }
    return self;
}

-(id) initWithInsets: (UIEdgeInsets) insets{
    
    self = [super init];
    if(self){
        self.insets = insets;
    }
    return self;
}
-(void) drawTextInRect:(CGRect)rect {
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.insets)];
}
@end

@implementation ScenicSimpleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier Height:(CGFloat)height
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        //Add line
        [self addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_SCALE)]];
        [self addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0,height-SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)]];
        
        UIEdgeInsets insets0 = {5,10,5,50};
        UIEdgeInsets insets1 = {0,10,0,20};

        if ([reuseIdentifier isEqualToString:ScenicSimpleCell_Loaction]) {
            //
            _location = [[CustomLable alloc] initWithFrame:CGRectMake(0,SCREEN_SCALE, SCREEN_WIDTH,height-SCREEN_SCALE*2) andInsets:insets0];
            //_location.text = @"北京市朝阳区酒仙桥中路18号幸福大厦右侧临街旁酒仙桥中路18号幸福大厦右侧临街旁";
            _location.font = FONT_13;
            _location.numberOfLines = 0;
            _location.textColor = RGBACOLOR(54, 54, 54, 1);
            _location.lineBreakMode = NSLineBreakByWordWrapping;
            _location.backgroundColor = [UIColor whiteColor];
            [self addSubview:_location];
            
            UIImageView *ima = [[UIImageView alloc] initWithFrame:CGRectMake(270,(height-30)/2.0, 30, 30)];
            ima.image = [UIImage imageNamed:@"groupon_detail_map.png"];
            [_location addSubview:ima];
            [ima release];
            
            //ico_rightarrow.png
            UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(305,(height-9)/2.0, 5, 9)];
            arrow.image = [UIImage imageNamed:@"ico_rightarrow.png"];
            [_location addSubview:arrow];
            [arrow release];
            
        }
        /*
        else if ([reuseIdentifier isEqualToString:ScenicSimpleCell_Intro]){
            //
            _scenicName = [[CustomLable alloc] initWithFrame:CGRectMake(0,SCREEN_SCALE,SCREEN_WIDTH, 35) andInsets:insets1];
           // _scenicName.text = @"颐和园景区介绍";
            _scenicName.backgroundColor = [UIColor whiteColor];
            _scenicName.font = FONT_15;
            [self addSubview:_scenicName];
            
            [self addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0, 40, SCREEN_WIDTH,SCREEN_SCALE)]];
            
            _scenicIntro = [[CustomLable alloc] initWithFrame:CGRectMake(0, 41, SCREEN_WIDTH,height-41-5) andInsets:insets1];
            //_scenicIntro.text = @"颐和园集历代皇家园林之大成，荟萃南北私家园林之精华，颐和园是中国现存最完整、规模最大的园林";
            _scenicIntro.backgroundColor = [UIColor whiteColor];
            _scenicIntro.numberOfLines = 0;
            _scenicIntro.lineBreakMode = NSLineBreakByWordWrapping;
            _scenicIntro.font = FONT_13;
            [self addSubview:_scenicIntro];
        }
         */
        else if ([reuseIdentifier isEqualToString:ScenicSimpleCell_Notice]){
            
            UILabel *tip = [[UILabel alloc] initWithFrame:CGRectMake(0,SCREEN_SCALE, 110, height-SCREEN_SCALE*2)];
            tip.backgroundColor =[UIColor whiteColor];
            tip.text = @"  预订须知";
            tip.font = FONT_15;
            [self addSubview:tip];
            [tip release];
            
            _simpleNotice = [[CustomLable alloc] initWithFrame:CGRectMake(tip.frame.size.width,SCREEN_SCALE, SCREEN_WIDTH-tip.frame.size.width, height-SCREEN_SCALE*2) andInsets:insets1];
            //_simpleNotice.text = @"如需预订，您最晚要在当天08:00前下单，请尽早预订";
            _simpleNotice.font = FONT_13;
            _simpleNotice.numberOfLines = 0;
            _simpleNotice.lineBreakMode = NSLineBreakByWordWrapping;
            _simpleNotice.textColor = RGBACOLOR(54, 54, 54, 1);
            _simpleNotice.backgroundColor = [UIColor whiteColor];
            [self addSubview:_simpleNotice];
            
            //ico_rightarrow.png
            UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(190,(height-9)/2.0, 5, 9)];
            arrow.image = [UIImage imageNamed:@"ico_rightarrow.png"];
            [_simpleNotice addSubview:arrow];
            [arrow release];
        }
    }
    return self;
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

-(void)dealloc{
    self.location = nil;
    self.scenicIntro = nil;
    self.scenicName = nil;
    self.simpleNotice = nil;
    [super dealloc];
}

@end


