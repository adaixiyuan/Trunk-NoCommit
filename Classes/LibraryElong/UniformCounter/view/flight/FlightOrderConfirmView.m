//
//  FlightOrderConfirmView.m
//  ElongClient
//
//  Created by 赵 海波 on 14-3-14.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "FlightOrderConfirmView.h"
#import "FlightOrderConfirmTableCell.h"
#import "FlightDataDefine.h"
#import "FlightOrderConfirmPassengerCell.h"

#define CELL_HEIGHT_BIG     73
#define CELL_HEIGHT_NORMAL  44

@implementation FlightOrderConfirmView

- (id)init
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _height = CELL_HEIGHT_BIG;
        
        isSingleTrip = YES;
        if ([[[FlightData getFDictionary] safeObjectForKey:KEY_SELECT_FLIGHT_TYPE] intValue] == DEFINE_ROUND_TRIP)
        {
            isSingleTrip = NO;
            _height += CELL_HEIGHT_BIG;
        }
        
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, _height);
        self.clipsToBounds = YES;
        
        [self makeUpDisplayView];
    }
    
    return self;
}


- (void)makeUpDisplayView
{
    UITableView *contentTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT - 50) style:UITableViewStylePlain];
    contentTable.backgroundColor = [UIColor clearColor];
    contentTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    contentTable.dataSource = self;
    contentTable.delegate = self;
    [self addSubview:contentTable];
}


- (void)showPassengers
{
    _height = passengerCellHeight + CELL_HEIGHT_BIG + SCREEN_SCALE;
    
    if (!isSingleTrip)
    {
        _height += CELL_HEIGHT_BIG;
    }
    
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, _height);
}


- (void)hiddenPassengers
{
    _height = CELL_HEIGHT_BIG;
    
    if (!isSingleTrip)
    {
        _height += CELL_HEIGHT_BIG;
    }
    
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, _height);
}

#pragma mark -
#pragma mark TableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowNumber = 2;        // 必定存在乘客栏和去程航班
    
    if (!isSingleTrip)
    {
        rowNumber += 1;     // 往返航班加一行显示返程
    }
    
    return rowNumber;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger passengerIndex = isSingleTrip ? 1 : 2;
    
    if (indexPath.row < passengerIndex)
    {
        // 此段显示航班信息
        static NSString *identifier = @"identifier";
        FlightOrderConfirmTableCell *cell = (FlightOrderConfirmTableCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil)
        {
            cell = [FlightOrderConfirmTableCell cellFromNib];
        }
        
        Flight *flight = nil;
        if (indexPath.row == 0)
        {
            // 第一行展示去程
            int arrayIndex = [[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_1] intValue];
            if ([[FlightData getFArrayGo] count] > 0 &&
                [[FlightData getFArrayGo] safeObjectAtIndex:arrayIndex] != nil)
            {
               flight = [[FlightData getFArrayGo] safeObjectAtIndex:arrayIndex];
            }
            
            cell.isReturnFlight = NO;
        }
        else
        {
            // 如果是往返航班，第二行展示返程
            int arrayIndex = [[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_2] intValue];
            if ([[FlightData getFArrayReturn] count] > 0 &&
                [[FlightData getFArrayReturn] safeObjectAtIndex:arrayIndex] != nil)
            {
                flight = [[FlightData getFArrayReturn] safeObjectAtIndex:arrayIndex];
            }
            
            cell.isReturnFlight = YES;
        }
        
        if (isSingleTrip)
        {
            // 单程航班显示航空公司icon
            cell.iconImageView.image = [UIImage noCacheImageNamed:[Utils getAirCorpPicName:[flight getAirCorpName]]];
        }
        else
        {
            // 往返航班显示去、返的icon
            if (indexPath.row == 0)
            {
                cell.iconImageView.image = [UIImage noCacheImageNamed:@"flight_go_icon.png"];
            }
            else
            {
                cell.iconImageView.image = [UIImage noCacheImageNamed:@"flight_return_icon.png"];
            }
        }
        
        cell.airlineNameLabel.text = [NSString stringWithFormat:@"%@%@", [flight getAirCorpName], [flight getFlightNumber]];
        cell.spaceNameLabel.text = [NSString stringWithFormat:@"%@", [flight getTypeName]];
        cell.departTimeLabel.text = [NSString stringWithFormat:@"%@", [TimeUtils displayDateWithJsonDate:[flight getDepartTime] formatter:@"HH:mm"]];
        cell.departAirPortLabel.text = [NSString stringWithFormat:@"%@", [flight getDepartAirport]];
        cell.arriveTimeLabel.text = [NSString stringWithFormat:@"%@", [TimeUtils displayDateWithJsonDate:[flight getArriveTime] formatter:@"HH:mm"]];
        cell.arriveAirPortLabel.text = [NSString stringWithFormat:@"%@", [flight getArriveAirport]];
        
        return cell;      
    }
    else
    {
        // 此段显示乘客及行程单信息
        static NSString *passengerIdentifier = @"passengerIdentifier";
        FlightOrderConfirmPassengerCell *cell = (FlightOrderConfirmPassengerCell *)[tableView dequeueReusableCellWithIdentifier:passengerIdentifier];
        
        if (cell == nil) {
            NSMutableArray *pArray = [[FlightData getFDictionary] safeObjectForKey:KEY_PASSENGER_LIST];
			for (int i=0; i<[pArray count]; i++) {
				// 乘机人列表
				UILabel *customerLabel = [[UILabel alloc] init];
                NSString *cerType = [Utils getCertificateName:[[[pArray safeObjectAtIndex:i] safeObjectForKey:KEY_CERTIFICATE_TYPE] intValue]];
                NSString *cerNumber = [[pArray safeObjectAtIndex:i] safeObjectForKey:KEY_CERTIFICATE_NUMBER];
                if ([cerType isEqualToString:@"身份证"]) {
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[pArray safeObjectAtIndex:i]];
                    [dic safeSetObject:cerNumber forKey:KEY_CERTIFICATE_NUMBER];
                    
                    cerNumber = [cerNumber stringByReplacingCharactersInRange:NSMakeRange([cerNumber length] - 4, 4) withString:@"****"];
                    
                }
                
                customerLabel.text = [NSString stringWithFormat:@"%@ / %@ / %@", [[pArray safeObjectAtIndex:i] safeObjectForKey:KEY_NAME], cerType, cerNumber];
				customerLabel.adjustsFontSizeToFitWidth = YES;
				customerLabel.minimumFontSize = 12;
				customerLabel.font = FONT_B14;
                customerLabel.backgroundColor = [UIColor clearColor];
				[cell.contentView addSubview:customerLabel];
                [customerLabel release];
			}
            
            NSString *postName = @"";
            NSString *postAddress = @"";
            
            switch ([[[FlightData getFDictionary] safeObjectForKey:KEY_TICKET_GET_TYPE] intValue]) {
                case DEFINE_POST_TYPE_NOT_NEED:
                    postName = nil;
                    postAddress = nil;
                    break;
                case DEFINE_POST_TYPE_POST:
                    postName = @"行程单邮寄地址：";
                    postAddress = [NSString stringWithFormat:@"%@ / %@", [[FlightData getFDictionary] safeObjectForKey:KEY_NAME], [[FlightData getFDictionary] safeObjectForKey:KEY_ADDRESS_CONTENT]];
                    break;
                case DEFINE_POST_TYPE_SELF_GET:
                    postName = @"机场自取：";
                    postAddress = [NSString stringWithFormat:@"%@", [[FlightData getFDictionary] safeObjectForKey:KEY_ADDRESS_NAME]];
                    break;
            }
            
            cell = [[[FlightOrderConfirmPassengerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:passengerIdentifier passengerInfo:pArray postName:postName postAddress:postAddress] autorelease];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(12.0f, passengerCellHeight - SCREEN_SCALE, SCREEN_WIDTH - 12, SCREEN_SCALE)]];
        }
        
        return cell;
    }
    
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger passengerIndex = isSingleTrip ? 1 : 2;
    
    if (indexPath.row < passengerIndex)
    {
        return 73;
    }
    else
    {
        int height = 40;
        if (![[[FlightData getFDictionary] safeObjectForKey:KEY_TICKET_GET_TYPE] intValue] == DEFINE_POST_TYPE_NOT_NEED) {
            height += 70.0f;
        }
        
        if ([[[FlightData getFDictionary] safeObjectForKey:KEY_PASSENGER_LIST] count] != 0) {
            height += [[[FlightData getFDictionary] safeObjectForKey:KEY_PASSENGER_LIST] count] * 22.0f;
        }
        else {
            height = 0.0f;
            
        }
        
        passengerCellHeight = height;
        
        return height;
    }
    
    return 0.0f;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (1 == section)
    {
        UIView *headerView = [[[UIView alloc] init] autorelease];
        headerView.backgroundColor = [UIColor clearColor];
    }
    
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        return 15.0f;
    }
    
    return 0.0f;
}


@end
