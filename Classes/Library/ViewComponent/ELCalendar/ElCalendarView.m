//
//  ElCalendarView.m
//  Calendar
//
//  Created by garin on 13-11-28.
//  Copyright (c) 2013年 garin. All rights reserved.
//

#import "ElCalendarView.h"
#import "UrgentTipManager.h"

#define kTrainStudentTipTag 1024
static NSString* studentTip = @"提示：学生票乘车时间限为每年的暑假6月1日至9月30日、寒假12月1日至3月31日";

//按月缓存的日历
static NSMutableArray *tableViewCellStaticList;
static NSString *cellStaticListKey;
static BOOL isCalendarFirstInit=YES;
static int timeZoneOffset;  //时区偏移量

@implementation ElCalendarView

@synthesize curDate;
@synthesize checkInDateBtn;
@synthesize checkOutDateBtn;
@synthesize startCheckInDate;
@synthesize startCheckOutDate;
@synthesize parentViewController;

#pragma mark -
#pragma mark tableViewCellStaticList 缓存实现
+(void) maketableViewCellStaticListWithKey:(NSString *) key curTimeDate:(NSDate *)curTimeDate
{
    if(tableViewCellStaticList==nil)
    {
        tableViewCellStaticList=[NSMutableArray array];
        [tableViewCellStaticList retain];
    }
    
    NSLog(@"创建 tableViewCellStaticList...");
    
    //回收全部过期的
    [tableViewCellStaticList removeAllObjects];
    
    CalendarHelper *curHelper=[CalendarHelper shared];
    
    static NSString *cellId = @"calendarcell";
    
    //初始化日历节假日
    [CalendarContentCell makeStaicHolidays];
    
    for (int i=0; i<monthCnt; i++)
    {
        CalendarContentCell *cell=[[CalendarContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        [tableViewCellStaticList addObject:cell];
        [cell release];
        cell.cellRowIndex=tableViewCellStaticList.count-1;
        
        NSDate *monthDate=[curHelper addMonth:curTimeDate addValue:i];
        if(cell)
            [cell initWithSth:monthDate];
    }
    
    //初始化完，清空节假日
    [CalendarContentCell clearStaticHolidays];
    
    //保存key
    if(cellStaticListKey)
    {
        [cellStaticListKey release];
        cellStaticListKey=nil;
    }
    
    cellStaticListKey=key;
    [cellStaticListKey retain];
    timeZoneOffset=[NSTimeZone localTimeZone].secondsFromGMT;
    
    NSLog(@"tableViewCellStaticList 结束...");
}


//返回tableViewCellStaticList
+(NSMutableArray *) getTableViewCellStaticList
{
    @synchronized(tableViewCellStaticList)
    {
        NSDate *curTimeDate=[NSDate date];
        int curTimeZoneOffset=[NSTimeZone localTimeZone].secondsFromGMT;
        
        if (curTimeZoneOffset!=timeZoneOffset)
        {
            //重置日历helper
            [CalendarHelper reset];
        }
        
        CalendarHelper *helperCalendarHelper=[CalendarHelper shared];
        NSString *curKey=nil;
        //每月第一天取上个月的key
        if ([helperCalendarHelper day:curTimeDate]==1)
        {
            curTimeDate=[curTimeDate dateByAddingTimeInterval:-(24*3600)];
            curKey=[NSString stringWithFormat:@"%d-%d",[helperCalendarHelper year:curTimeDate],[helperCalendarHelper month:curTimeDate]];
        }
        else
        {
            curKey=[NSString stringWithFormat:@"%d-%d",[helperCalendarHelper year:curTimeDate],[helperCalendarHelper month:curTimeDate]];
        }
        
        //检测时区
        if (curTimeZoneOffset!=timeZoneOffset)
        {
            [ElCalendarView maketableViewCellStaticListWithKey:curKey curTimeDate:curTimeDate];
        }
        else
        {
            if (!STRINGHASVALUE(cellStaticListKey)||tableViewCellStaticList==nil)
            {
                [ElCalendarView maketableViewCellStaticListWithKey:curKey curTimeDate:curTimeDate];
            }
            else
            {
                if(![cellStaticListKey isEqualToString:curKey])
                {
                    [ElCalendarView maketableViewCellStaticListWithKey:curKey curTimeDate:curTimeDate];
                }
            }
        }
        
        return tableViewCellStaticList;
    }
}

//删除缓存
-(void) deleteTableViewCellStaticList
{
    if (tableViewCellStaticList) {
        [tableViewCellStaticList release];
        tableViewCellStaticList=nil;
    }
    if (cellStaticListKey) {
        cellStaticListKey=nil;
    }
}


#pragma mark -
#pragma mark ElCalendarView 实现

-(void) dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [[UrgentTipManager sharedInstance] cancelUrgentTip];
    
    self.curDate=nil;
    self.trueFirstDate=nil;
    self.checkInDateBtn=nil;
    self.checkOutDateBtn=nil;
    self.startCheckInDate=nil;
    self.startCheckOutDate=nil;
    calendarView.delegate=nil;
    self.parentViewController=nil;
    
    if(tableViewCellStaticList)
    {
        for (int i=0; i<tableViewCellStaticList.count; i++)
        {
            CalendarContentCell *cell=[tableViewCellStaticList safeObjectAtIndex:i];
            if(cell)
                cell.delegate=nil;
        }
    }
    
    [_sectionHeaderView release];
    _sectionHeaderView = nil;
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame cinDate:(NSDate *) cinDate coutDate:(NSDate *) coutDate type:(CalendarType) type parentViewController:(DPNav *)parentViewController_
{
    self = [super initWithFrame:frame];
    if (self)
    {
        isFirstSelect=NO;
        scrollToIndex=-100;
        self.curDate=[NSDate date];
        calendarTypeType=type;
        self.parentViewController=parentViewController_;
        
        //check in out 变量
        if (type==HotelCalendar||type==GlobelHotelCalendar)
        {
            if(cinDate==nil||coutDate==nil)
            {
                self.startCheckInDate=[NSDate date];
                self.startCheckOutDate=[self.startCheckInDate dateByAddingTimeInterval:24*3600];
            }
            else
            {
                self.startCheckInDate=cinDate;
                self.startCheckOutDate=coutDate;
            }
        }
        else if (type==FlightCalendarGo||type==FlightCalendarBack||type==TrainCalendar||type==UseTaxi)
        {
            if(cinDate==nil)
            {
                self.startCheckInDate=[[NSDate date] dateByAddingTimeInterval:24*3600];
            }
            else
            {
      
                if (type == FlightCalendarBack) {
                    self.startCheckInDate = coutDate;//针对返程
                }else{
                    self.startCheckInDate=cinDate;
                }

            }
        }
        else
        {
            if(cinDate==nil||coutDate==nil)
            {
                self.startCheckInDate=[NSDate date];
                self.startCheckOutDate=[self.startCheckInDate dateByAddingTimeInterval:24*3600];
            }
            else
            {
                self.startCheckInDate=cinDate;
                self.startCheckOutDate=coutDate;
            }
        }

        //重置cell
        NSArray *arr=[ElCalendarView getTableViewCellStaticList];
        
        for (int i=0; i<arr.count; i++)
        {
            CalendarContentCell *cell=[arr safeObjectAtIndex:i];
            if(cell==nil)
                continue;
            
            [cell doOtherSth:self.startCheckInDate cOutdate:self.startCheckOutDate selectDayDelegate:self type:type];
        }
        
        //日期栏
        [self makeDayOfWeekUI];
        
        _sectionHeaderView = [[UIView alloc] init];
        _sectionHeaderView.backgroundColor = [UIColor whiteColor];
        
        //日历主体tableview
        [self addTabelView];
        
        
        if(calendarTypeType == TrainCalendar){
            // 学生票提示
            CGSize size = CGSizeMake(SCREEN_WIDTH, CGFLOAT_MAX);//LableWight标签宽度，固定的
            CGSize studentTipsSize = [studentTip sizeWithFont:[UIFont systemFontOfSize:12.0f] constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
            
            UILabel *trainStudentTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, studentTipsSize.width, studentTipsSize.height)];
            trainStudentTipLabel.tag = kTrainStudentTipTag;
            trainStudentTipLabel.numberOfLines = 0;
            trainStudentTipLabel.font = [UIFont systemFontOfSize:12.0f];
            trainStudentTipLabel.lineBreakMode = NSLineBreakByCharWrapping;
            trainStudentTipLabel.text = studentTip;
            _sectionHeaderView.frame = trainStudentTipLabel.bounds;
            [_sectionHeaderView addSubview:trainStudentTipLabel];
            [trainStudentTipLabel release];
        }

        
        //设置紧急提示
        [self addUrgentTipView];
        
        //滚动到某个位置
        if (scrollToIndex>0&&scrollToIndex<arr.count)
        {
            [calendarView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:scrollToIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        
        isFirstSelect=YES;
    }
    
    return self;
}

//星期栏
-(void) makeDayOfWeekUI
{
    dayWeekView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, tilteLanHeight)];
    dayWeekView.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1];
    
    NSArray *daysOfTheWeek=[NSArray arrayWithObjects:@"日",@"一",@"二",@"三",@"四",@"五",@"六", nil];
    
    float cSpan=dayWeekView.frame.size.width/daysOfTheWeek.count;
    
    if(cSpan>0)
    {
        for (int i=0; i<daysOfTheWeek.count; i++)
        {
            UILabel *temLabel = [[UILabel alloc] initWithFrame:CGRectMake(cSpan*i, tilteLanHeight-20, cSpan, 20)];
            temLabel.text = [daysOfTheWeek safeObjectAtIndex:i];
            temLabel.textAlignment = NSTextAlignmentCenter;
            temLabel.font=[UIFont systemFontOfSize:12];
            temLabel.backgroundColor = [UIColor clearColor];
            [dayWeekView addSubview:temLabel];
            [temLabel release];
        }
    }
    
    [self addSubview:dayWeekView];
    
    UIView *splitView=[[UIView alloc] initWithFrame:CGRectMake(0, tilteLanHeight - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)];
    splitView.backgroundColor=[UIColor colorWithRed:176/255.0 green:176/255.0 blue:176/255.0 alpha:1];
    [dayWeekView addSubview:splitView];
    [splitView release];
    
    [dayWeekView release];
}

-(void) addTabelView
{
    calendarView=[[UITableView alloc] initWithFrame:CGRectMake(0, tilteLanHeight, SCREEN_WIDTH, MAINCONTENTHEIGHT-tilteLanHeight) style:UITableViewStylePlain];
    calendarView.dataSource=self;
    calendarView.delegate=self;
    calendarView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self addSubview:calendarView];
    [calendarView release];
    
//    calendarView.tableHeaderView = _sectionHeaderView;
}

-(void)addUrgentTipView{
    //获取紧急提示
    NSString *urgentTipType = @"";
    if(calendarTypeType== HotelCalendar){
        urgentTipType = HotelCalendarUrgentTip;
    }else if(calendarTypeType == FlightCalendarGo || calendarTypeType == FlightCalendarBack){
        urgentTipType = FlightCalendarUrgentTip;
    }else if(calendarTypeType == TrainCalendar){
        urgentTipType = TrainCalendarUrgentTip;
    }
    
    if(STRINGHASVALUE(urgentTipType)){
         UIView *weakSectionHeaderView = _sectionHeaderView;
        UITableView *weakCalendar = calendarView;
        [[UrgentTipManager sharedInstance] urgentTipViewofCategory:urgentTipType completeHandle:^(UrgentTipView *urgentTipView) {
            // 学生票提示
            UILabel *studentTipLabel = (UILabel *)[weakSectionHeaderView viewWithTag:kTrainStudentTipTag];
            if (studentTipLabel) {
                CGRect headerViewFrame = weakSectionHeaderView.frame;
                headerViewFrame.size.height += urgentTipView.bounds.size.height;
                weakSectionHeaderView.frame = headerViewFrame;
                
                urgentTipView.frame = CGRectMake(0.0f, studentTipLabel.frame.size.height, urgentTipView.bounds.size.width, urgentTipView.bounds.size.height);
                [weakSectionHeaderView addSubview:urgentTipView];
            }
            else {
                weakSectionHeaderView.frame = urgentTipView.bounds;
                [weakSectionHeaderView addSubview:urgentTipView];
            }
            
            [weakCalendar reloadData];
        }];
    }
    
}

// 取消选中的日期
- (void)cancelChoosedDate:(NSInteger )dateNum
{
    CalendarHelper *helper = [CalendarHelper shared];
    NSDate *firstDate=self.checkInDateBtn.date;
    
    //取消所有的选择
    [self.checkInDateBtn setCheckState:None];
    for(int i=0;i<dateNum;i++)
    {
        firstDate=[helper nextDay:firstDate];
        DateButton *temBtn=[self findButtonFromCellListByDate:firstDate];
        if(temBtn)
        {
            [temBtn setCheckState:None];
        }
    }
    
    //还原可选,从昨天开始循环，包含凌晨预定
    NSDate *startDate=[self.curDate dateByAddingTimeInterval:-(24*3600)];
    DateButton *todayButton = [self findButtonFromCellListByDate:startDate];
    //昨天,而且是午夜，恢复可用
    if(todayButton)
    {
        if(todayButton.isMidNight)
            [todayButton setBtnEnabled:YES];
    }
    
    startDate=self.curDate;
    todayButton = [self findButtonFromCellListByDate:startDate];
    
    //今天
    if(todayButton)
    {
        [todayButton setBtnEnabled:YES];
    }
    
    int notEnableDays=[helper getalldays:startDate withCheckOutDate:self.checkInDateBtn.date];
    for(int i=0;i<notEnableDays;i++)
    {
        startDate=[helper nextDay:startDate];
        DateButton *temBtn=[self findButtonFromCellListByDate:startDate];
        if(temBtn)
        {
            [temBtn setBtnEnabled:YES];
        }
    }
    
    self.checkInDateBtn=nil;
    self.checkOutDateBtn=nil;
    
    [self.parentViewController setNavTitle:@"请选择入住日期"];
}

#pragma -mark
#pragma -mark TableViewDelegate

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return;
}

#pragma -mark
#pragma -mark TableViewDataSource

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return monthCnt;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSDate *monthDate=[helper addMonth:self.curDate addValue:indexPath.row];
    
    NSArray *arr=[ElCalendarView getTableViewCellStaticList];
    CalendarContentCell *cell=[arr safeObjectAtIndex:indexPath.row];
    NSDate *monthDate=cell.curDate;
    
    int allRow=[self getRowsByDate:monthDate];
    NSLog(@"monthDate:%@,allRow:%d",monthDate,allRow);
    return monthLanHeight+allRow*dayLanHeight;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarContentCell *cell = [[ElCalendarView getTableViewCellStaticList] safeObjectAtIndex:indexPath.row];
    
    return cell;
}

//得到当前星期有几行
-(int) getRowsByDate:(NSDate *) date
{
    CalendarHelper *helper = [CalendarHelper shared];
    
    NSDate *firstDate = [helper firstDayOfMonthContainingDate:date];
    
    int dayOfWeek=[helper dayOfWeekForDate:firstDate];   //星期几
    int monthDays=[helper getDayCountOfMonth:firstDate]; //当前月有几天
    int allRow=(dayOfWeek+monthDays-1)%7>0?(dayOfWeek+monthDays-1)/7+1:(dayOfWeek+monthDays-1)/7;
    
    return allRow;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return _sectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return _sectionHeaderView.bounds.size.height;
}

#pragma mark -
#pragma mark UIScrollViewDelegate
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updateYearTxt];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self updateYearTxt];
    }
}

//更新年
-(void) updateYearTxt
{
    CalendarHelper *helper = [CalendarHelper shared];
    NSArray *cells = [calendarView visibleCells];
    if (ARRAYHASVALUE(cells)) {
        CalendarContentCell *cell=[cells safeObjectAtIndex:0];
        if (cell) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_SelectYear_CALENDAR object:[NSString stringWithFormat:@"%d年",[helper year:cell.curDate]]];
        }
    }
}

//得到滑动到的年份
-(NSString *) getCurYearTxt
{
    CalendarHelper *helper = [CalendarHelper shared];
    NSArray *cells = [calendarView visibleCells];
    if (ARRAYHASVALUE(cells)) {
        CalendarContentCell *cell=[cells safeObjectAtIndex:0];
        if (cell)
        {
            return [NSString stringWithFormat:@"%d年",[helper year:cell.curDate]];
        }
    }
    
    return @"";
}

//得到实际的第一个月的时间
-(NSDate *) getTrueStartDate
{
    if (self.trueFirstDate==nil) {
        NSArray *arr=[ElCalendarView getTableViewCellStaticList];
        CalendarContentCell *cell=[arr safeObjectAtIndex:0];
        self.trueFirstDate=cell.curDate;
    }
    
    return self.trueFirstDate;
}

#pragma mark -
#pragma mark SelectDayDelegate
//选中某一天的回掉
-(void) tableCellSelectDay:(DateButton *) dataBtn type:(CalendarType) type isInit:(BOOL) isInit
{
    if(dataBtn==nil)
        return;
    
    if (type==HotelCalendar||type==GlobelHotelCalendar)
    {
        if (isFirstSelect)
        {
            NSLog(@"第一次点击");
            
            if (self.checkInDateBtn)
            {
                //先点入住，取消所有
                [self tableCellSelectDayForHotel:self.checkInDateBtn isInit:isInit];
            }
            
            isFirstSelect=NO;
        }
        
        [self tableCellSelectDayForHotel:dataBtn isInit:isInit];
    }
    else if (type==TrainCalendar||type==FlightCalendarGo||type==FlightCalendarBack||type==UseTaxi)
    {
        if (UseTaxi==type&&!isInit)
        {
            //非初始化，用车日历，只能选中30天
            NSDate *monthyearDate=[curDate dateByAddingTimeInterval:60*60*24*30];
            CalendarHelper *helper = [CalendarHelper shared];
            if ([helper compareDate:dataBtn.date withCheckOutDate:monthyearDate]==1)
            {
                [Utils alert:@"目前最长提前30天预订用车服务。"];
                return;
            }
        }
        
        [self tableCellSelectDayForTrainAndFlight:dataBtn];
    }
    
    NSLog(@"date:%@",dataBtn.date);
}

//酒店，国际酒店的处理逻辑
-(void) tableCellSelectDayForHotel:(DateButton *)dataBtn isInit:(BOOL) isInit
{
    CalendarHelper *helper = [CalendarHelper shared];
    
    // 比较选中的日期，如果在选中的入住日期之前，则取消入离店
    if ([helper compareDate:self.checkInDateBtn.date withCheckOutDate:dataBtn.date]==1)  //入住日期小于今天
    {
        int allDays = allDays=[helper getalldays:self.checkInDateBtn.date withCheckOutDate:self.checkOutDateBtn.date];
        
        [self cancelChoosedDate:allDays];
    }
    
    
    if(self.checkInDateBtn)
    {
        if([helper getalldays:self.checkInDateBtn.date withCheckOutDate:dataBtn.date]>checkMaxDays)
        {
            NSString *message=[NSString stringWithFormat:@"如果您需要入住酒店超过%d天，请致电400-666-1166，我们会竭诚为您服务。",checkMaxDays];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
            return;
        }
        
        //入住天数
        int allDays=0;
        //从入住天数开始的第一天
        NSDate *firstDate=self.checkInDateBtn.date;
        
        //点击已经选中的入住按钮，取消入离店
        if(dataBtn==self.checkInDateBtn)
        {
            allDays=[helper getalldays:self.checkInDateBtn.date withCheckOutDate:self.checkOutDateBtn.date];
            
            [self cancelChoosedDate:allDays];
            
            return;
        }
        
        //离店逻辑************************
        //入店之前不能选
        if([helper compareDate:self.checkInDateBtn.date withCheckOutDate:dataBtn.date]==1)
        {
            NSDate *yesterdayDate=[self.curDate dateByAddingTimeInterval:-(24*3600)];
            //如果是午夜，选中昨日入店
            if (dataBtn.isMidNight)
            {
                DateButton *temBtn=[self findButtonFromCellListByDate:yesterdayDate];
                if(temBtn)
                {
                    int temAllDays=[helper getalldays:temBtn.date withCheckOutDate:self.checkOutDateBtn.date];
                    if(temAllDays>checkMaxDays)
                    {
                        NSString *message=[NSString stringWithFormat:@"如果您需要入住酒店超过%d天，请致电400-666-1166，我们会竭诚为您服务。",checkMaxDays];
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                        message:message
                                                                       delegate:nil
                                                              cancelButtonTitle:@"确定"
                                                              otherButtonTitles:nil];
                        [alert show];
                        [alert release];
                        return;
                    }
                    
                    [self.checkInDateBtn setCheckState:None];
                    [self.checkInDateBtn setCheckState:CommonCheck];
                    self.checkInDateBtn=temBtn;
                    [self.checkInDateBtn setCheckState:None];
                    [self.checkInDateBtn setCheckState:CheckIn];
                    
                    [self setCalendarTitle:temAllDays];
                    if (!isInit)
                    {
                        [self closeCalendar];
                    }
                }
            }
            return;
        }
        
        //如果离店已经选中，全部还原
        if(self.checkOutDateBtn)
        {
            firstDate=self.checkInDateBtn.date;
            allDays=[helper getalldays:self.checkInDateBtn.date withCheckOutDate:self.checkOutDateBtn.date];
            for(int i=0;i<allDays;i++)
            {
                firstDate=[helper nextDay:firstDate];
                DateButton *temBtn=[self findButtonFromCellListByDate:firstDate];
                if(temBtn)
                {
                    [temBtn setCheckState:None];
                }
            }
        }
        
        //选中该选中的
        self.checkOutDateBtn=dataBtn;
        firstDate=self.checkInDateBtn.date;
        allDays=[helper getalldays:self.checkInDateBtn.date withCheckOutDate:self.checkOutDateBtn.date];
        
        for(int i=0;i<allDays;i++)
        {
            firstDate=[helper nextDay:firstDate];
            DateButton *temBtn=[self findButtonFromCellListByDate:firstDate];
            if(temBtn)
            {
                if(i==(allDays-1))
                {
                    [temBtn setCheckState:None];
                    [temBtn setCheckState:CheckOut];
                }
                else
                {
                    [temBtn setCheckState:None];
                    [temBtn setCheckState:CommonCheck];
                }
            }
        }
        
        [self setCalendarTitle:allDays];
        if (!isInit)
        {
            [self closeCalendar];
        }
    }
    else
    {
        //不能被checkin选中,日历的最后一天
        if(dataBtn.couldNotSelectByCheckIn)
            return;
        
        self.checkInDateBtn=dataBtn;
        [self.checkInDateBtn setBtnEnabled:YES];
        [self.checkInDateBtn setCheckState:None];
        [self.checkInDateBtn setCheckState:CheckIn];
        //初始化入店之前不能选
        NSDate *firstDate = [helper firstDayOfMonthContainingDate:[self getTrueStartDate]];
        NSDate *lastDate;
        int notEnableDays;
        //初始化到今天
        if (isInit)
        {
            lastDate = curDate;
            notEnableDays=[helper getalldays:firstDate withCheckOutDate:lastDate];
        }
        else
        {
//            lastDate = self.checkInDateBtn.date;
            lastDate = [NSDate date];
            
            // 判断可选日期是否包含
            NSDate *dawnDate=[self.curDate dateByAddingTimeInterval:-(24*3600)];
            DateButton *dawnButton = [self findButtonFromCellListByDate:dawnDate];
            
            // 如果是凌晨预定或者国际酒店
            if ((calendarTypeType == GlobelHotelCalendar) || (dawnButton != nil))
            {
                lastDate = [[NSDate date] dateByAddingTimeInterval:-(24*3600)];
            }
            
            notEnableDays=[helper getalldays:firstDate withCheckOutDate:self.checkInDateBtn.date];
        }
        
        for(int i=0;i<notEnableDays;i++)
        {
            lastDate=[helper preDay:lastDate];
            
            DateButton *temBtn=[self findButtonFromCellListByDate:lastDate];
            if(temBtn)
            {
                if (isInit)
                {
                    if(temBtn.isMidNight)
                    {
                        [temBtn setBtnEnabled:YES];
                    }
                    else
                    {
                        [temBtn setBtnEnabled:NO];
                    }
                }
                else
                {
//                    if(temBtn.isMidNight&&[helper dateIsToday:dataBtn.date])
//                    {
//                        [temBtn setBtnEnabled:YES];
//                    }
//                    else
//                    {
//                        [temBtn setBtnEnabled:NO];
//                    }
                    [temBtn setBtnEnabled:NO];
                }
            }
        }
        
        [self.parentViewController setNavTitle:@"请选择离店日期"];
    }
}

//设置入住了几天
-(void) setCalendarTitle:(int) allDays
{
    //设置状态
    if (allDays>0)
    {
        [self.parentViewController setNavTitle:[NSString stringWithFormat:@"入住%d晚",allDays]];
    }
}

//滚动到某个位置
-(void) scroolToIndex:(int) scroolIndex
{
    scrollToIndex=scroolIndex;
}

//火车和机票的处理逻辑
-(void) tableCellSelectDayForTrainAndFlight:(DateButton *)dataBtn
{
    if (self.checkInDateBtn)
    {
        [self.checkInDateBtn setCheckState:None];
    }
    else
    {
        CalendarHelper *helper = [CalendarHelper shared];
        //今天之前不能选
        NSDate *firstDate = [helper firstDayOfMonthContainingDate:[self getTrueStartDate]];
        NSDate *lastDate = [NSDate date];
        int notEnableDays=[helper getalldays:firstDate withCheckOutDate:lastDate];
        for(int i=0;i<notEnableDays;i++)
        {
            lastDate=[helper preDay:lastDate];
            
            DateButton *temBtn=[self findButtonFromCellListByDate:lastDate];
            if(temBtn)
            {
                [temBtn setBtnEnabled:NO];
            }
        }

    }
    
    BOOL isConfirm=YES;
    
    if (self.checkInDateBtn==nil)
    {
        isConfirm=NO;
    }
    
    self.checkInDateBtn=dataBtn;
    [self.checkInDateBtn setBtnEnabled:YES];
    [self.checkInDateBtn setCheckState:None];
    [self.checkInDateBtn setCheckState:CheckIn];
    
    if (isConfirm)
    {
        [self closeCalendar];
    }
}

//关闭日历
-(void) closeCalendar
{
    [self performSelector:@selector(performCloseCalendar) withObject:nil afterDelay:0.3];
}

-(void) performCloseCalendar
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_CLOSE_CALENDAR object:nil];
}

//根据日期找到对应button
-(DateButton *) findButtonFromCellListByDate:(NSDate *) _targetDate
{
    NSArray *arr=[ElCalendarView getTableViewCellStaticList];
    if(arr==nil)
        return nil;
    
    CalendarHelper *helper = [CalendarHelper shared];
    
    int targetDateMonth=[helper month:_targetDate];
    
    for (int i=0; i<arr.count; i++)
    {
//        NSDate *monthDate=[helper addMonth:self.curDate addValue:i];
        CalendarContentCell *cell=arr[i];
        if (cell==nil) {
            continue;
        }
        
        NSDate *monthDate=cell.curDate;
        
        if (monthDate)
        {
            int mon=[helper month:monthDate];
            if(mon==targetDateMonth)
            {
                
                if(cell)
                {
                    DateButton *temBtn = [cell findButtonInView:_targetDate];
                    if(temBtn)
                    {
                        return temBtn;
                    }
                }
            }
        }
    }
    
    return nil;
}

//设置入住几晚的title
-(void) selectDaysCnt:(int) days
{
    [self.parentViewController setNavTitle:[NSString stringWithFormat:@"入住%d晚",days]];
}

//根据日期找到对应button,废弃
-(void) setViewActive
{
    return;
    if (!isCalendarFirstInit)
    {
        return;
    }
    
    isCalendarFirstInit=NO;
    
    NSArray *arr=[ElCalendarView getTableViewCellStaticList];
    if(arr==nil)
        return;
    
    for (int i=0; i<arr.count; i++)
    {
        CalendarContentCell *cell=arr[i];
        if(cell)
        {
            [cell setCellActive];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
