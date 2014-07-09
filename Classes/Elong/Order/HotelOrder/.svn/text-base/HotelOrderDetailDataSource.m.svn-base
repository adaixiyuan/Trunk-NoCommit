//
//  HotelOrderDetailDataSource.m
//  ElongClient
//
//  Created by Ivan.xu on 14-3-18.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "HotelOrderDetailDataSource.h"
#import "HotelOrderDetailViewController.h"

@implementation HotelOrderDetailDataSource

- (void)dealloc
{
    [_currentOrder release];
    [_mainTable release];
    [super dealloc];
}

-(id)initWithOrder:(NSDictionary *)anOrder table:(UITableView *)aTableView{
    self = [super init];
    if(self){
        _mainTable = [aTableView retain];
        _mainTable.delegate = self;
        _mainTable.dataSource = self;
        
        _currentOrder = [[NSDictionary alloc] initWithDictionary:anOrder];
        
        //能否拨打电话
        _isCanTel = STRINGHASVALUE([anOrder safeObjectForKey:@"HotelPhone"])?YES:NO;
    }
    return self;
}

//根据字体获得高度
-(float)labelHeightWithString:(NSString *)text Width:(int)width font:(UIFont *)font{
    CGSize fontSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(width, INT_MAX) lineBreakMode:UILineBreakModeCharacterWrap];
    int height = fontSize.height<=30?30:fontSize.height+12;
    return height;
}

/* 根据日期，获取对应的星期 */
-(NSString *)getDateNoteWithDate:(NSDate *)date{
    //用于今日、明日显示判断
    NSString *todayStr = [TimeUtils displayDateWithNSDate:[NSDate date] formatter:@"M月d日"];
    NSString *tomorrowStr = [TimeUtils displayDateWithNSDate:[NSDate dateWithTimeInterval:24*3600 sinceDate:[NSDate date]] formatter:@"M月d日"];
    NSString *dateStr = [TimeUtils displayDateWithNSDate:date formatter:@"M月d日"];
    
    NSString *dateNote = @"";
    if([todayStr isEqualToString:dateStr]){
        dateNote = @"今天";   //判断今天
    }else if([tomorrowStr isEqualToString:dateStr]){
        dateNote = @"明天";   //判断明天
    }else{
        //如果不是今天、明天，则显示周几..
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *comps = [calendar components:(NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit)
                                              fromDate:date];
        NSInteger weekday = [comps weekday]; // 星期几（注意，周日是“1”，周一是“2”。。。。）
        switch (weekday) {
            case 1:
                dateNote = @"周日";
                break;
            case 2:
                dateNote = @"周一";
                break;
            case 3:
                dateNote = @"周二";
                break;
            case 4:
                dateNote = @"周三";
                break;
            case 5:
                dateNote = @"周四";
                break;
            case 6:
                dateNote = @"周五";
                break;
            case 7:
                dateNote = @"周六";
                break;
            default:
                break;
        }
    }
    return dateNote;
}

#pragma mark - UITableView Datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==0){
        return 1;
    }else if(section==1){
        return 1;
    }if(section==2){
        return 8;
    }else if(section==3){
        return 1;
    }else if(section==4){
        return 1;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==1){
        if(indexPath.row==0){
            UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell_one"] autorelease];
            cell.backgroundColor = [UIColor clearColor];
//            cell.backgroundView = nil;
            
            //续住提示信息
            NSString *rebookingPrompt = @"如您需要续住，请再次下单以保证您正常获得积分、返现等优惠。";       //再次预订提示
            UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 20)];
            textLabel.backgroundColor = [UIColor clearColor];
            
            textLabel.text = rebookingPrompt;
            textLabel.textColor = RGBACOLOR(153, 153, 153, 1);
            textLabel.numberOfLines = 0;
            textLabel.font = [UIFont systemFontOfSize:10];
            [cell addSubview:textLabel];
            [textLabel release];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else if(indexPath.section==4){
        if(indexPath.row==0){
            UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell_two"] autorelease];
            cell.backgroundColor = [UIColor clearColor];
            cell.clipsToBounds = YES;
            
            //担保或预付规则
            NSString *rules = @"";
            if (STRINGHASVALUE([_currentOrder objectForKey:@"PrepayRule"])) {
                rules = [_currentOrder objectForKey:@"PrepayRule"];
            }else if(STRINGHASVALUE([_currentOrder objectForKey:@"PrepayRule"])){
                rules = [_currentOrder objectForKey:@"VouchRule"];
            }
            
            CGSize ruleSize = [rules sizeWithFont:[UIFont systemFontOfSize:10] constrainedToSize:CGSizeMake(300, INT_MAX)];
            UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, ruleSize.height)];
            textLabel.backgroundColor = [UIColor clearColor];
            
            textLabel.text = rules;
            textLabel.textColor = RGBACOLOR(153, 153, 153, 1);
            textLabel.numberOfLines = 0;
            textLabel.font = [UIFont systemFontOfSize:10];
            [cell addSubview:textLabel];
            [textLabel release];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }
    
    static NSString *identify = @"HotelOrderDetailCell";
    HotelOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if(cell==nil){
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"HotelOrderDetailCell" owner:self options:nil];
        cell = [nibs objectAtIndex:0];
    }
    cell.delegate = self.parentViewController;      //委托给给父类
    
    cell.keyLabel.text = @"";
    cell.key1Label.text = @"";
    cell.valueLabel.text = @"";
    cell.value1Label.text  = @"";
    
    cell.keyLabel.frame = CGRectMake(10, 0, 70, 44);
    cell.key1Label.frame = CGRectMake(10, 0, 70, 44);
    cell.valueLabel.frame = CGRectMake(90, 0, 220, 44);
    cell.value1Label.frame = CGRectMake(90, 0, 220, 44);
    
    cell.value1Label.font = [UIFont systemFontOfSize:15];
    cell.valueLabel.font = [UIFont systemFontOfSize:15];
    
    if(indexPath.row>0){
        cell.topLineImgView.hidden = YES;
    }else{
        cell.topLineImgView.hidden = NO;
    }
    int rows = [self tableView:tableView numberOfRowsInSection:indexPath.section];
    if(indexPath.row==rows-1){
        cell.bottomLineImgView.frame = CGRectMake(0, cell.bounds.size.height-SCREEN_SCALE, 320, SCREEN_SCALE);
    }else{
        cell.bottomLineImgView.frame = CGRectMake(90, cell.bounds.size.height-SCREEN_SCALE, 230, SCREEN_SCALE);
    }
    
    if(indexPath.section==0){
        if(indexPath.row == 0){
            cell.keyLabel.text = @"订单总额：";
            
            NSString *currency = [_currentOrder safeObjectForKey:@"Currency"];  //货币符号
            NSString *currencyMark = currency;
            if ([currency isEqualToString:@"HKD"]) {
                currencyMark = @"HK$";
            }
            else if ([currency isEqualToString:@"RMB"]) {
                currencyMark = @"¥";
            }
            
            //订单价格
            NSString *orderPrice = [NSString stringWithFormat:@"%@%.f",currencyMark,[[_currentOrder safeObjectForKey:@"SumPrice"] doubleValue]];
            orderPrice = STRINGHASVALUE(orderPrice)?orderPrice:@"--";
            
            cell.valueLabel.text = orderPrice;
            cell.valueLabel.textColor = RGBACOLOR(254, 75, 32, 1);
            cell.valueLabel.frame = CGRectMake(90, 0, 60, 44);
            cell.valueLabel.font = [UIFont boldSystemFontOfSize:15];
            
            //暂时只支持非会员显示支付类型
            ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
            if(!appDelegate.isNonmemberFlow){
                //支付类型
                NSString *vouchTips = [[_currentOrder safeObjectForKey:@"VouchMoney"] floatValue] > 0 ? @"(担保)" : @"(到店付款)";
                NSString *paymentType = [[_currentOrder safeObjectForKey:@"Payment"] intValue] == 0 ? vouchTips : @"(预付)";
                paymentType = STRINGHASVALUE(paymentType)?paymentType:@"";
                
                cell.value1Label.textColor = [UIColor darkGrayColor];
                cell.value1Label.font = [UIFont systemFontOfSize:13];
                cell.value1Label.text = [NSString stringWithFormat:@"%@",paymentType];
                CGSize orderPriceSize = [orderPrice sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(INT_MAX, 30)];
                cell.value1Label.frame = CGRectMake(90+orderPriceSize.width+10, 0, 160, 44);
            }
        }
    }else if(indexPath.section==2){
        if(indexPath.row==0){
            cell.keyLabel.text = @"入住日期：";
            cell.keyLabel.frame = CGRectMake(10, 0, 70, 44);
            
            //到店日期
            NSString *arriveDate =  [TimeUtils displayDateWithJsonDate:[_currentOrder safeObjectForKey:@"ArriveDate"] formatter:@"M月d日"];     //入住时间
            arriveDate = STRINGHASVALUE(arriveDate)?arriveDate:@"--";
            
//            cell.valueLabel.text = arriveDate;
            cell.valueLabel.text = [NSString stringWithFormat:@"%@",arriveDate];
            cell.valueLabel.frame = CGRectMake(90, 0, 80, 44);
            cell.valueLabel.font = [UIFont boldSystemFontOfSize:15];
            
            
            cell.key1Label.text = @"离店日期：";
            cell.key1Label.frame = CGRectMake(170, 0, 70, 44);
            
            //离店时间
            NSString *departDate = [TimeUtils displayDateWithJsonDate:[_currentOrder safeObjectForKey:@"LeaveDate"] formatter:@"M月d日"];
            departDate = STRINGHASVALUE(departDate)?departDate:@"--";
            
//            cell.value1Label.text = departDate;
            cell.value1Label.text =  [NSString stringWithFormat:@"%@",departDate];
            cell.value1Label.frame = CGRectMake(240, 0, 180, 44);
            cell.value1Label.font = [UIFont boldSystemFontOfSize:15];
        }else if(indexPath.row==1){
            cell.keyLabel.text = @"入住房型：";
            
            NSString *roomTypeName = [_currentOrder safeObjectForKey:@"RoomTypeName"];      //房型名称
            roomTypeName = STRINGHASVALUE(roomTypeName)?roomTypeName:@"--";
            cell.valueLabel.text = roomTypeName;
        }else if(indexPath.row==2){
            cell.keyLabel.text = @"入 住  人：";
            
            NSMutableString *guestName = [NSMutableString stringWithFormat:@""];
            id value = [_currentOrder safeObjectForKey:@"GuestName"];        //入住人
            if([value isKindOfClass:[NSString class]]){
                guestName = STRINGHASVALUE(value)?value:@"--";
            }else if([value isKindOfClass:[NSArray class]]){
                int count = 0;
                for (NSString *s in value)
                {
                    [guestName appendFormat:@"%@ ",s];
                    count++;
                    if (count>=4) {
                        [guestName appendFormat:@"%@",@"\n"];
                        count=0;
                    }
                }
            }
            cell.valueLabel.text = guestName;
        }else if(indexPath.row==3){
            cell.keyLabel.text = @"保留时间：";
            
            NSString *keepTime = @"";
            ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
            if(!appDelegate.isNonmemberFlow){
                //保留时间
                NSString *keepTime0 = [TimeUtils displayDateWithJsonDate:[_currentOrder safeObjectForKey:@"TimeEarly"] formatter:@"MM-dd"];
                NSString *keepTime1 = [TimeUtils displayDateWithJsonDate:[_currentOrder safeObjectForKey:@"TimeLate"] formatter:@"MM-dd"];
                keepTime = [NSString stringWithFormat:@"%@-%@",[TimeUtils displayDateWithJsonDate:[_currentOrder safeObjectForKey:@"TimeEarly"] formatter:@"M月d日 HH:mm"],[TimeUtils displayDateWithJsonDate:[_currentOrder safeObjectForKey:@"TimeLate"] formatter:@"HH:mm"]];
                if (![keepTime0 isEqualToString:keepTime1]) {
                    keepTime = [NSString stringWithFormat:@"%@-次日%@",[TimeUtils displayDateWithJsonDate:[_currentOrder safeObjectForKey:@"TimeEarly"] formatter:@"M月d日 HH:mm"],[TimeUtils displayDateWithJsonDate:[_currentOrder safeObjectForKey:@"TimeLate"] formatter:@"HH:mm"]];
                }
                keepTime = STRINGHASVALUE(keepTime)?keepTime:@"--";
            }else{
                keepTime = [_currentOrder safeObjectForKey:@"ArriveTimeRange"];     //非会员取到店时间
            }

            cell.valueLabel.text = keepTime;
        }else if(indexPath.row == 4){
            cell.keyLabel.text = @"预订日期：";
            
            NSString *bookingDate = [TimeUtils displayDateWithJsonDate:[_currentOrder safeObjectForKey:CREATETIME] formatter:@"yyyy-MM-dd"];    //预订日期
            bookingDate = STRINGHASVALUE(bookingDate)?bookingDate:@"--";
            cell.valueLabel.text = bookingDate;
        }else if(indexPath.row == 5){
            cell.keyLabel.text = @"酒店名称：";
            
            NSString *hotelName = [_currentOrder safeObjectForKey:@"HotelName"];    //酒店名称
            hotelName = STRINGHASVALUE(hotelName)?hotelName:@"--";
            cell.valueLabel.text = hotelName;
            
            //重新设置valueLabel的高度
            int height = [self labelHeightWithString:hotelName Width:220 font:[UIFont systemFontOfSize:15]];
            height = height>44?height:44;
            CGRect valueFrame = cell.valueLabel.frame;
            valueFrame.size.height = height;
            cell.valueLabel.frame = valueFrame;
            
            //重新设置底线的位置
            cell.bottomLineImgView.frame = CGRectMake(cell.valueLabel.frame.origin.x, height-SCREEN_SCALE, 320, SCREEN_SCALE);       //y值会变化
        }else if(indexPath.row == 6){
            cell.keyLabel.text = @"酒店地址：";
            
            NSString *hotelAddress = STRINGHASVALUE([_currentOrder safeObjectForKey:@"HotelAddress"])?[_currentOrder safeObjectForKey:@"HotelAddress"]:@"--";   //酒店地址
            hotelAddress = STRINGHASVALUE(hotelAddress)?hotelAddress:@"--";
            cell.valueLabel.text = hotelAddress;
            
            //重新设置valueLabel的高度
            int height = [self labelHeightWithString:hotelAddress Width:220 font:[UIFont systemFontOfSize:15]];
            height = height>44?height+12:44;
            CGRect valueFrame = cell.valueLabel.frame;
            valueFrame.size.height = height;
            cell.valueLabel.frame = valueFrame;
        
            cell.goHotelBtn.hidden = NO;
            CGRect goHotelFrame = cell.goHotelBtn.frame;
            goHotelFrame.origin.y = height-6;
            cell.goHotelBtn.frame = goHotelFrame;
            
            //重新设置底线的位置
            cell.bottomLineImgView.frame = CGRectMake(cell.valueLabel.frame.origin.x , height+25-SCREEN_SCALE, 320, SCREEN_SCALE);       //y值会变化
        }else if(indexPath.row==7){
            cell.keyLabel.text = @"酒店电话：";
            
            NSString *hotelTelPhone = STRINGHASVALUE([_currentOrder safeObjectForKey:@"HotelPhone"])?[_currentOrder safeObjectForKey:@"HotelPhone"]:@"暂无";  //酒店电话
            
            cell.valueLabel.text = hotelTelPhone;
            cell.valueLabel.textColor = RGBACOLOR(46, 126, 234, 1);
            //电话按钮点击
            cell.telPhoneBtn.hidden = !_isCanTel;
        }
    }else if(indexPath.section==3){
        if(indexPath.row==0){
            cell.keyLabel.text = @"发票状态：";
            
            NSDictionary *invoiceInfo = [_currentOrder safeObjectForKey:@"InvoiceInfo"];
            int source = [[invoiceInfo objectForKey:@"Source"] intValue];       //发票来源(0不开发票,1elong开发票,2酒店开发票)
            BOOL isInvoiced = [[invoiceInfo objectForKey:@"IsInvoiced"] intValue];
            
            if(source==1 && isInvoiced){
                cell.valueLabel.text = @"已开具";
                //显示查看发票流程按钮
                cell.lookInvoiceFlowBtn.hidden = NO;
            }else{
                cell.valueLabel.text = @"未开具";
                cell.lookInvoiceFlowBtn.hidden = YES;
            }
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //根据内容的长度计算高度
    if(indexPath.section==1){
        return 20;
    }else if(indexPath.section==2){
        if(indexPath.row==2){
            //入住人
            NSMutableString *guestName = [NSMutableString stringWithFormat:@""];
            id value = [_currentOrder safeObjectForKey:@"GuestName"];        //入住人
            if([value isKindOfClass:[NSString class]]){
                guestName = STRINGHASVALUE(value)?value:@"--";
            }else if([value isKindOfClass:[NSArray class]]){
                int count = 0;
                for (NSString *s in value)
                {
                    [guestName appendFormat:@"%@ ",s];
                    count++;
                    if (count>=4) {
                        [guestName appendFormat:@"%@",@"\n"];
                        count=0;
                    }
                }
            }
            
            int height = [self labelHeightWithString:guestName Width:220 font:[UIFont systemFontOfSize:15]];
            height = height>44?height:44;
            return height;
        }
        if(indexPath.row == 5){
            NSString *hotelName = [_currentOrder safeObjectForKey:@"HotelName"];    //酒店名称
            hotelName = STRINGHASVALUE(hotelName)?hotelName:@"--";
            
            int height = [self labelHeightWithString:hotelName Width:220 font:[UIFont systemFontOfSize:15]];
            height = height>44?height:44;
            return height;
        }else if(indexPath.row == 6){
            NSString *hotelAddress = STRINGHASVALUE([_currentOrder safeObjectForKey:@"HotelAddress"])?[_currentOrder safeObjectForKey:@"HotelAddress"]:@"--";   //酒店地址
            hotelAddress = STRINGHASVALUE(hotelAddress)?hotelAddress:@"--";

            int height = [self labelHeightWithString:hotelAddress Width:220 font:[UIFont systemFontOfSize:15]];
            height = height>44?height+12:44;
            return height + 25;     //25按钮是带我去酒店的高度
        }
    }else if(indexPath.section==4){
        if(indexPath.row==0){
            //担保或预付规则
            NSString *rules = @"";
            if (STRINGHASVALUE([_currentOrder objectForKey:@"PrepayRule"])) {
                rules = [_currentOrder objectForKey:@"PrepayRule"];
            }else if(STRINGHASVALUE([_currentOrder objectForKey:@"PrepayRule"])){
                rules = [_currentOrder objectForKey:@"VouchRule"];
            }
            if(!STRINGHASVALUE(rules)){
                return 0;
            }
            
            CGSize ruleSize = [rules sizeWithFont:[UIFont systemFontOfSize:10] constrainedToSize:CGSizeMake(300, INT_MAX)];
            return ruleSize.height+12;
        }
    }

    return 44;

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section==0 || section==2 || section==4){
        return 0;
    }
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionHeaderView =  [[UIView alloc] init];
    sectionHeaderView.backgroundColor = [UIColor clearColor];
    return [sectionHeaderView autorelease];
}


@end
