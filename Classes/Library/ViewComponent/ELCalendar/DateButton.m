//
//  DateButton.m
//  Calendar
//
//  Created by garin on 13-11-28.
//  Copyright (c) 2013年 garin. All rights reserved.
//

#import "DateButton.h"

@implementation DateButton

@synthesize date;
@synthesize txt;
@synthesize trueHoliday;
@synthesize isMidNight;
@synthesize couldNotSelectByCheckIn;
@synthesize type;
@synthesize isGreenDay;

-(void) dealloc
{
    self.date=nil;
    self.txt=nil;
    self.trueHoliday=nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 10, 0)];
        [self setTitleColor:[UIColor colorWithRed:37/255.0 green:37/255.0 blue:37/255.0 alpha:1] forState:UIControlStateNormal];
        self.titleLabel.font=[UIFont systemFontOfSize:16];
        self.adjustsImageWhenDisabled=NO;
        self.adjustsImageWhenHighlighted=NO;
        
        holidayLbl=[[UILabel alloc] init];
        holidayLbl.backgroundColor=[UIColor clearColor];
        holidayLbl.textColor=[UIColor colorWithRed:37/255.0 green:37/255.0 blue:37/255.0 alpha:1];
        holidayLbl.textAlignment=NSTextAlignmentCenter;
        holidayLbl.font=[UIFont systemFontOfSize:12];
        [self insertSubview:holidayLbl atIndex:0];
        [holidayLbl release];
        
        //holidayLbl.text=@"国庆节";
        curState=None;
    }
    return self;
}

-(void) setHoliday:(NSString *) holidayString
{
    holidayLbl.text=holidayString;
}

-(DateButtonState) getCheckState
{
    return curState;
}

-(void) setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    holidayLbl.frame=CGRectMake(0, 40, self.frame.size.width, self.frame.size.height-40);
}

- (void)setDateAndTitle:(NSDate *)aDate
{
    CalendarHelper *helper = [CalendarHelper shared];
    self.date=aDate;
    int day =[helper day:aDate];
    [self setTitle:[NSString stringWithFormat:@"%d",day] forState:UIControlStateNormal];
    self.txt=[NSString stringWithFormat:@"%d",day];
}

-(void) setCheckState:(DateButtonState) state
{
    if (state==curState)
    {
        return;
    }
    
    if(state==None)
    {
        [self setNormalStateUI];
    }
    else if (state==CheckIn)
    {
        [self setCheckStateUI:state];
    }
    else if (state==CheckOut)
    {
        [self setCheckStateUI:state];
    }
    else if (state==CommonCheck)
    {
        [self setCheckStateUI:state];
    }
    
    curState=state;
}

-(void) setNormalStateUI
{
//    [self setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    
    if(upLbl)
    {
        [upLbl removeFromSuperview];
        upLbl=nil;
    }
    
    if(downLbl)
    {
        [downLbl removeFromSuperview];
        downLbl=nil;
    }
    
    if (imgView) {
        [imgView removeFromSuperview];
        imgView=nil;
    }
    
    holidayLbl.hidden=NO;
    [self setTitle:self.txt forState:UIControlStateNormal];
}

//入住离店状态UI
-(void) setCheckStateUI:(DateButtonState) state
{
//    [self setImageEdgeInsets:UIEdgeInsetsMake(0, 8, 12, 8)];
//    [self setImage:[UIImage imageNamed:@"calender_selectbg.png"] forState:UIControlStateNormal];
    
    if (imgView) {
        [imgView removeFromSuperview];
        imgView=nil;
    }
    
    imgView=[[UIImageView alloc] initWithFrame:CGRectMake(4, 4, 38, 36)];
    imgView.image=[UIImage noCacheImageNamed:@"calender_selectbg.png"];
    [self addSubview:imgView];
    [imgView release];
    
    if (type==HotelCalendar||type==GlobelHotelCalendar)
    {
        if (state==CheckIn)
        {
            UIImageView *cancelView=[[UIImageView alloc] initWithFrame:CGRectMake(-4, -3, 18, 18)];
            cancelView.image=[UIImage noCacheImageNamed:@"calendar_cancel.png"];
            cancelView.tag=1230600;
            [imgView addSubview:cancelView];
            [cancelView release];
        }
    }
    
//    int ran=rand();
//    
//    if(ran %2==0&&NO)
//    {
//        UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 5, self.frame.size.width-10, 30)];
//        imgView.image=[UIImage imageNamed:@"calendar_button_left.png"];
//        [self addSubview:imgView];
//        [imgView release];
//    }
//    else
//    {
//        UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 5, self.frame.size.width, 30)];
//        imgView.image=[UIImage imageNamed:@"calendar_button_middle.png"];
//        [self addSubview:imgView];
//        [imgView release];
//    }
    
    if(upLbl)
    {
        [upLbl removeFromSuperview];
        upLbl=nil;
    }
    
    if(downLbl)
    {
        [downLbl removeFromSuperview];
        downLbl=nil;
    }

    
    upLbl=[[UILabel alloc] initWithFrame:CGRectMake(0, -6, self.frame.size.width,self.frame.size.height)];
    upLbl.text=self.txt;
    upLbl.font=[UIFont boldSystemFontOfSize:14];
    upLbl.textAlignment=NSTextAlignmentCenter;
    upLbl.textColor=[UIColor whiteColor];
    upLbl.backgroundColor=[UIColor clearColor];
    [self addSubview:upLbl];
    [upLbl release];
    
    //普通选中下边不管
    if(state==CommonCheck)
    {
        [self setTitle:@"" forState:UIControlStateNormal];
        return;
    }
    
    downLbl=[[UILabel alloc] initWithFrame:CGRectMake(0, 40, self.frame.size.width, self.frame.size.height-40)];
    if(state==CheckIn)
    {
        if (type==HotelCalendar||type==GlobelHotelCalendar) {
            downLbl.text=@"入住";
        }
        else if(type==FlightCalendarGo||type==TrainCalendar)
        {
            downLbl.text=@"出发";
        }
        else if(type==FlightCalendarBack)
        {
            downLbl.text=@"返程";
        }
        else if(type==UseTaxi)
        {
            downLbl.text=@"接机";
        }
    }
    else if(state==CheckOut)
        downLbl.text=@"离店";        
    
    downLbl.backgroundColor=[UIColor clearColor];
    downLbl.textColor=[UIColor colorWithRed:29/255.0 green:94/255.0 blue:226/255.0 alpha:1];
    downLbl.textAlignment=NSTextAlignmentCenter;
    downLbl.font=[UIFont systemFontOfSize:12];
    [self addSubview:downLbl];
    [downLbl release];
    
    holidayLbl.hidden=YES;
    [self setTitle:@"" forState:UIControlStateNormal];
}

//不可用时的button的UI
-(void) setBtnEnabled:(BOOL) ennable
{
    self.enabled=ennable;
    
    if(ennable)
    {
        if (self.isGreenDay)
        {
            [self setTitleColor:[UIColor colorWithRed:20/255.0 green:157/255.0 blue:52/255.0 alpha:1] forState:UIControlStateNormal];
        }
        else
        {
            [self setTitleColor:[UIColor colorWithRed:37/255.0 green:37/255.0 blue:37/255.0 alpha:1] forState:UIControlStateNormal];
        }
        
        holidayLbl.textColor=[UIColor colorWithRed:37/255.0 green:37/255.0 blue:37/255.0 alpha:1];
    }
    
    else
    {
        [self setTitleColor:[UIColor colorWithRed:174/255.0 green:174/255.0 blue:174/255.0 alpha:1] forState:UIControlStateNormal];
        
        holidayLbl.textColor=[UIColor colorWithRed:174/255.0 green:174/255.0 blue:174/255.0 alpha:1];
    }
}

@end
