//
//  XGHomeOrderDetailSource.m
//  ElongClient
//
//  Created by 李程 on 14-5-13.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "XGHomeOrderDetailSource.h"
#import "XGOrderDetailCell.h"
@implementation XGHomeOrderDetailSource


-(id)initWithOrder:(XGOrderModel *)orderModel table:(UITableView *)aTableView{
    self = [super init];
    
    if (self) {
        
        self.mainTable = aTableView;
        self.mainTable.delegate = self;
        self.mainTable.dataSource = self;
        self.orderModel = orderModel;
//        _currentOrder = [[NSDictionary alloc] initWithDictionary:anOrder];
//        
//        //能否拨打电话
        self.isCanTel = STRINGHASVALUE(self.orderModel.HotelPhone)?YES:NO;
        
    }
    return self;

}



#pragma mark UIScrollViewDelegate
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (scrollView == self.mainTable)
    {
        CGFloat sectionHeaderHeight = [self tableView:self.mainTable heightForHeaderInSection:1];
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0){
            
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y,0, 0, 0);
        }
        else if (scrollView.contentOffset.y>=sectionHeaderHeight){
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
    
    
}



#pragma mark - UITableView Datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==0){
        return 1;
    }if(section==1){
        return 9;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *identify = @"XGOrderDetailCell";
    XGOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if(cell==nil){
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"XGOrderDetailCell" owner:self options:nil];
        cell = [nibs objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    cell.callTeleBlock = ^(void){  //打电话
        [_myparentViewController clickOrderDetailCell_TelPhoneBtn];
    };
    cell.keyLabel.frame = CGRectMake(10, 0, 70, 44);
    cell.valueLabel.frame = CGRectMake(90, 0, 220, 44);
    
    cell.valueLabel.font = [UIFont systemFontOfSize:15];
    cell.value1Label.font = [UIFont systemFontOfSize:15];
    cell.topLineImgView.hidden = indexPath.row==0?NO:YES;
    cell.telPhoneBtn.hidden  = YES;
    int rows = [self tableView:tableView numberOfRowsInSection:indexPath.section];
    if(indexPath.row==rows-1){
        cell.bottomLineImgView.frame = CGRectMake(0, cell.bounds.size.height-SCREEN_SCALE, 320, SCREEN_SCALE);
    }else{
        cell.bottomLineImgView.frame = CGRectMake(90, cell.bounds.size.height-SCREEN_SCALE, 230, SCREEN_SCALE);
    }
    
    
    if(indexPath.section==0){
        if(indexPath.row == 0){
            cell.keyLabel.text = @"订单总额：";
            
//            NSString *currency = [_currentOrder safeObjectForKey:@"Currency"];  //货币符号
//            NSString *currencyMark = currency;
//            if ([currency isEqualToString:@"HKD"]) {
//                currencyMark = @"HK$";
//            }
//            else if ([currency isEqualToString:@"RMB"]) {
//                currencyMark = @"¥";
//            }
            
            NSString *currencyMark = @"¥";
            
            //订单价格
            NSString *orderPrice = [NSString stringWithFormat:@"%@%.f",currencyMark,[self.orderModel.SumPrice doubleValue]];
            orderPrice = STRINGHASVALUE(orderPrice)?orderPrice:@"--";
            
            cell.valueLabel.text = orderPrice;
            cell.valueLabel.textColor = RGBACOLOR(254, 75, 32, 1);
            cell.valueLabel.frame = CGRectMake(90, 0, 60, 44);
            cell.valueLabel.font = [UIFont boldSystemFontOfSize:15];
            
            //暂时只支持非会员显示支付类型
            ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
            if(!appDelegate.isNonmemberFlow){
                //支付类型
//                NSString *vouchTips = [[_currentOrder safeObjectForKey:@"VouchMoney"] floatValue] > 0 ? @"(担保)" : @"(到店付款)";
                NSString *paymentType = [self.orderModel.Payment intValue] == 0 ? @"(到店付款)" : @"(预付)";
                paymentType = STRINGHASVALUE(paymentType)?paymentType:@"";
                
                cell.value1Label.textColor = [UIColor darkGrayColor];
                cell.value1Label.font = [UIFont systemFontOfSize:13];
                cell.value1Label.text = [NSString stringWithFormat:@"%@",paymentType];
                CGSize orderPriceSize = [orderPrice sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(INT_MAX, 30)];
                cell.value1Label.frame = CGRectMake(90+orderPriceSize.width+10, 0, 160, 44);
            }
        }
    }else if(indexPath.section==1){
        
        if(indexPath.row==0){
            cell.keyLabel.text = @"入住日期：";
            cell.keyLabel.frame = CGRectMake(10, 0, 70, 44);
            
            //到店日期
            
            NSString *arriveString = [TimeUtils makeJsonDateWithNSTimeInterval_C2C:[self.orderModel.ArriveDate longLongValue]];
            NSString *arriveDate = [TimeUtils displayDateWithJsonDate:arriveString formatter:@"M月d日"]; //到店日期
            
            arriveDate = STRINGHASVALUE(arriveDate)?arriveDate:@"--";
            
            //            cell.valueLabel.text = arriveDate;
            cell.valueLabel.text = [NSString stringWithFormat:@"%@",arriveDate];
            cell.valueLabel.frame = CGRectMake(90, 0, 80, 44);
            cell.valueLabel.font = [UIFont boldSystemFontOfSize:15];
            
            
            cell.key1Label.text = @"离店日期：";
            cell.key1Label.frame = CGRectMake(170, 0, 70, 44);
            
            //离店时间
            
            NSString *departString = [TimeUtils makeJsonDateWithNSTimeInterval_C2C:[self.orderModel.LeaveDate longLongValue]];
            NSString *departDate = [TimeUtils displayDateWithJsonDate:departString formatter:@"M月d日"];      //离店日期
            
            departDate = STRINGHASVALUE(departDate)?departDate:@"--";
            
            //            cell.value1Label.text = departDate;
            cell.value1Label.text =  [NSString stringWithFormat:@"%@",departDate];
            cell.value1Label.frame = CGRectMake(240, 0, 180, 44);
            cell.value1Label.font = [UIFont boldSystemFontOfSize:15];
        }
        else if(indexPath.row==1){
            cell.keyLabel.text = @"入住房型：";
            NSString *roomTypeName = self.orderModel.RoomTypeName;      //房型名称
            roomTypeName = STRINGHASVALUE(roomTypeName)?roomTypeName:@"--";
            cell.valueLabel.text = roomTypeName;
        }
        else if (indexPath.row==2){
            
            cell.keyLabel.text = @"房间数量：";
            NSNumber *roomTypeName = self.orderModel.WareCount;      //房型名称
            
            NSString *content = @"";
            if (roomTypeName==nil||[roomTypeName isKindOfClass:[NSNull class]]) {
                content = @"无";
            }else{
                content = [NSString stringWithFormat:@"%d",[roomTypeName intValue]];
            }
            
            cell.valueLabel.text = content;
            
        }
        else if(indexPath.row==3){
            cell.keyLabel.text = @"入 住  人：";
            NSMutableString *guestName = [NSMutableString stringWithFormat:@""];
            id value = self.orderModel.GuestName;        //入住人
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
        }
        else if(indexPath.row==4){
            cell.keyLabel.text = @"保留时间：";
            NSString *keepTime = @"";
            ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
            if(!appDelegate.isNonmemberFlow){
                //保留时间
                NSString *keepTime0String = [TimeUtils makeJsonDateWithNSTimeInterval_C2C:[self.orderModel.TimeEarly longLongValue]];
                NSString *keepTime0 = [TimeUtils displayDateWithJsonDate:keepTime0String formatter:@"MM-dd"]; //到店日期
                
                NSString *keepTime1String = [TimeUtils makeJsonDateWithNSTimeInterval_C2C:[self.orderModel.TimeLate longLongValue]];
                NSString *keepTime1 = [TimeUtils displayDateWithJsonDate:keepTime1String formatter:@"MM-dd"];
                
                keepTime = [NSString stringWithFormat:@"%@-%@",[TimeUtils displayDateWithJsonDate:keepTime0String formatter:@"M月d日 hh:mm"],[TimeUtils displayDateWithJsonDate:keepTime1String formatter:@"hh:mm"]];
                
                if (![keepTime0 isEqualToString:keepTime1]) {
                    keepTime = [NSString stringWithFormat:@"%@-次日%@",[TimeUtils displayDateWithJsonDate:keepTime0String formatter:@"M月d日 hh:mm"],[TimeUtils displayDateWithJsonDate:keepTime1String formatter:@"hh:mm"]];
                }
                keepTime = STRINGHASVALUE(keepTime)?keepTime:@"--";
            }else{
                keepTime = @"";
            }
//            else{
//                keepTime = [_currentOrder safeObjectForKey:@"ArriveTimeRange"];     //非会员取到店时间
//            }
            
            cell.valueLabel.text = keepTime;
        }
        else if(indexPath.row == 5){
            cell.keyLabel.text = @"预订日期：";
            
            //预定时间  没有
            NSString *createTimeString = [TimeUtils makeJsonDateWithNSTimeInterval_C2C:[self.orderModel.CreateTime longLongValue]];
            NSString *bookingDate = [TimeUtils displayDateWithJsonDate:createTimeString formatter:@"yyyy-MM-dd"];    //预订日期
            bookingDate = STRINGHASVALUE(bookingDate)?bookingDate:@"--";
            cell.valueLabel.text = bookingDate;
        }
        else if(indexPath.row == 6){
            cell.keyLabel.text = @"酒店名称：";
            
            NSString *hotelName = self.orderModel.HotelName;    //酒店名称
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
        }else if(indexPath.row == 7){
            cell.keyLabel.text = @"酒店地址：";
            
            NSString *hotelAddress = STRINGHASVALUE(self.orderModel.HotelAddress)?self.orderModel.HotelAddress:@"--";   //酒店地址
            hotelAddress = STRINGHASVALUE(hotelAddress)?hotelAddress:@"--";
            cell.valueLabel.text = hotelAddress;
            
            //重新设置valueLabel的高度
            int height = [self labelHeightWithString:hotelAddress Width:220 font:[UIFont systemFontOfSize:15]];
            height = height>44?height+12:44;
            CGRect valueFrame = cell.valueLabel.frame;
            valueFrame.size.height = height;
            cell.valueLabel.frame = valueFrame;
            
            //重新设置底线的位置
            cell.bottomLineImgView.frame = CGRectMake(cell.valueLabel.frame.origin.x, height-SCREEN_SCALE, 320, SCREEN_SCALE);       //y值会变化
            
//            cell.goHotelBtn.hidden = NO;
//            CGRect goHotelFrame = cell.goHotelBtn.frame;
//            goHotelFrame.origin.y = height-6;
//            cell.goHotelBtn.frame = goHotelFrame;
//            
//            //重新设置底线的位置
//            cell.bottomLineImgView.frame = CGRectMake(cell.valueLabel.frame.origin.x , height+25-SCREEN_SCALE, 320, SCREEN_SCALE);       //y值会变化
        }else if(indexPath.row==8){
            cell.keyLabel.text = @"酒店电话：";
            NSString *hotelTelPhone = STRINGHASVALUE(self.orderModel.HotelPhone)?self.orderModel.HotelPhone:@"暂无";  //酒店电话
            cell.valueLabel.text = hotelTelPhone;
            cell.valueLabel.textColor = RGBACOLOR(46, 126, 234, 1);
            //电话按钮点击
            cell.telPhoneBtn.hidden = !_isCanTel;
        }
        
        
    }
    
    static   NSString    *cellidentifier  = @"memberidentifier";
    
    UITableViewCell *cell2  = (UITableViewCell   *)[tableView dequeueReusableCellWithIdentifier:cellidentifier];
    if (!cell2) {
        
        cell2  = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifier];
        
    }
    cell2.textLabel.text = @"AAA";
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section==1 ){
        return 10;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //根据内容的长度计算高度
//    if(indexPath.section==0){
//        return 20;
//    }else{
//        return 0;
//    }
    
    if (indexPath.section ==1 && indexPath.row == 7) {
        
        NSString *hotelAddress = STRINGHASVALUE(self.orderModel.HotelAddress)?self.orderModel.HotelAddress:@"--";   //酒店地址
        hotelAddress = STRINGHASVALUE(hotelAddress)?hotelAddress:@"--";
        //重新设置valueLabel的高度
        int height = [self labelHeightWithString:hotelAddress Width:220 font:[UIFont systemFontOfSize:15]];
        height = height>44?height+12:44;
        
        return height;
        
    }else{
        return 44;
    }
    
}


//根据字体获得高度
-(float)labelHeightWithString:(NSString *)text Width:(int)width font:(UIFont *)font{
    CGSize fontSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(width, INT_MAX) lineBreakMode:UILineBreakModeCharacterWrap];
    int height = fontSize.height<=30?30:fontSize.height+12;
    return height;
}

@end
