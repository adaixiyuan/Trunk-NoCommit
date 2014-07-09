//
//  ELCalendarViewController.m
//  Calendar
//
//  Created by garin on 13-11-27.
//  Copyright (c) 2013年 garin. All rights reserved.
//

#import "ELCalendarViewController.h"
#import "CalendarHelper.h"

@implementation ELCalendarViewController
@synthesize checkInDate;
@synthesize checkOutDate;
@synthesize delegate;
@synthesize type;

-(void) dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    self.checkInDate=nil;
    self.checkOutDate=nil;
    self.delegate=nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

- (id) initWithCheckIn:(NSDate *)checkIn checkOut:(NSDate *)checkOut type:(CalendarType)calendarType{
    
    NSString *curTitle=nil;
    if (calendarType == HotelCalendar||calendarType == GlobelHotelCalendar)
    {
        curTitle = @"入离日期";
    }
    else
    {
        if (calendarType==FlightCalendarGo||calendarType==TrainCalendar)
        {
            curTitle=@"出发日期";
        }
        else if(calendarType==FlightCalendarBack)
        {
            curTitle=@"返程日期";
        }
        else if (calendarType==UseTaxi)
        {
            curTitle=@"接机日期";
        }
    }
    
    if (self = [super initWithTopImagePath:nil andTitle:curTitle style:_NavOlnyHotelBookmark_])
    {
        //事先更新下
        [ElCalendarView getTableViewCellStaticList];
        
        self.checkInDate = checkIn;
        self.checkOutDate = checkOut;
        self.type = calendarType;

        calendar=[[ElCalendarView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) cinDate:self.checkInDate coutDate:self.checkOutDate type:type parentViewController:self];
        [self.view addSubview:calendar];
        [calendar release];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(comfirmBtn:) name:NOTI_CLOSE_CALENDAR object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectYear:) name:NOTI_SelectYear_CALENDAR object:nil];
        
        //年份
        UIView *rightView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, NAVBAR_WORDBTN_WIDTH, NAVBAR_ITEM_HEIGHT)];
        rightView.backgroundColor=[UIColor clearColor];
        
        yearLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, NAVBAR_WORDBTN_WIDTH-4, NAVBAR_ITEM_HEIGHT)];
        yearLbl.font = FONT_B15;
        yearLbl.backgroundColor=[UIColor clearColor];
        yearLbl.textAlignment = UITextAlignmentRight;
        //    yearLbl.textColor=COLOR_NAV_BTN_TITLE;
        CalendarHelper *helper=[CalendarHelper shared];
        yearLbl.text=[NSString stringWithFormat:@"%d年",[helper year:calendar.curDate]];
        [rightView addSubview:yearLbl];
        [yearLbl release];
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:rightView];
        [rightView release];
        
        self.navigationItem.rightBarButtonItem = item;
        [item release];
        
        [self performSelector:@selector(setYearTxt) withObject:nil afterDelay:0.2];
    }

    return self;
}

-(void) setYearTxt
{
    yearLbl.text=[calendar getCurYearTxt];
}

- (void)back
{
    if([delegate respondsToSelector:@selector(ElcalendarViewSelectDay:checkinDate:checkoutDate:)] && (type == TrainCalendar))
    {
        [delegate ElcalendarViewSelectDay:self checkinDate:nil checkoutDate:nil];
    }
	
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor=[UIColor whiteColor];
}

-(void) backBtn:(id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) selectYear:(NSNotification *) noti
{
    NSString *txt=[noti object];
    
    if (STRINGHASVALUE(txt)) {
        yearLbl.text=txt;
    }
}

-(void) comfirmBtn:(id) sender
{
    if (type==HotelCalendar||type==GlobelHotelCalendar)
    {
        if(calendar==nil||calendar.checkInDateBtn.date==nil||calendar.checkOutDateBtn.date==nil)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"请选择入离店日期"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
            return;
        }
    }
    else
    {
        if(calendar==nil||calendar.checkInDateBtn.date==nil)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"请选择出发日期"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
            return;
        }
    }
    
    if([delegate respondsToSelector:@selector(ElcalendarViewSelectDay:checkinDate:checkoutDate:)])
    {
        [delegate ElcalendarViewSelectDay:self checkinDate:calendar.checkInDateBtn.date checkoutDate:calendar.checkOutDateBtn.date];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
