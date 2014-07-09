//
//  RoomType.m
//  ElongClient
//
//  Created by bin xing on 11-1-6.
//  Copyright 2011 DP. All rights reserved.
//

#import "RoomType.h"
#import "DefineHotelResp.h"
#import "DefineHotelReq.h"
#import "ElongClientAppDelegate.h"

#define kCellNormalHeight         68

static int currentRoomIndex;
static BOOL isPrepay = NO;

@interface RoomType ()

@property (nonatomic, retain) NSIndexPath *selectedCellIndexPath;
@property (nonatomic, retain) NSIndexPath *preCellIndexPath;

@end


@implementation RoomType

@synthesize selectedCellIndexPath;
@synthesize preCellIndexPath;
@synthesize detail;

+(int)currentRoomIndex{
	
	return currentRoomIndex;
}
+(void)setCurrentRoomIndex:(int)index{
	
	currentRoomIndex=index;
}


+ (BOOL)isPrepay {
    return isPrepay;
}

+ (void)setIsPrepay:(BOOL)animation {
    isPrepay = animation;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {

	if (self = [super initWithFrame:frame style:style]) {
		self.separatorStyle = UITableViewCellSeparatorStyleNone; 
    
		tableImgeDict	= [[NSMutableDictionary alloc] initWithCapacity:2];
		progressManager	= [[NSMutableArray alloc] initWithCapacity:2];
		queue			= [[NSOperationQueue alloc] init];
        

	}
	
	return self;
}

- (void) refresh:(BOOL)animated{
    self.delegate		= self;
    self.dataSource		= self;
    if (animated) {
        [self reloadData];
        
        self.selectedCellIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        self.preCellIndexPath = nil;
        [self performSelector:@selector(chooseFirstRoom) withObject:nil afterDelay:0.2];
    }else{
        self.preCellIndexPath = nil;
        self.selectedCellIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self reloadData];
        
        self.preCellIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    // 请求热度信息
    [self getHotInfo];
}

- (void) getHotInfo{
    JPostHeader *postheader=[[JPostHeader alloc] init];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
    NSString *hotelId = [[HotelDetailController hoteldetail] safeObjectForKey:RespHD_HotelId_S];
    [dict safeSetObject:hotelId forKey:@"HotelId"];
    [dict safeSetObject:[NSNumber numberWithInt:3] forKey:@"MultipleFilter"];
    hotRequest = [[HttpUtil alloc] init];
    [hotRequest connectWithURLString:HOTELSEARCH
                                Content:[postheader requesString:NO action:@"GetHotelPrompt" params:dict]
                           StartLoading:NO
                             EndLoading:NO
                               Delegate:self];
    [postheader release];
}

- (void) showFlashTips:(NSString *)tips{
    if (!tips || !detail) {
        return;
    }
    //ElongClientAppDelegate *app = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
    UIImageView *flashView = (UIImageView *)[self.superview viewWithTag:3110];
    if (flashView) {
        [flashView removeFromSuperview];
        flashView = nil;
    }
    flashView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 0, 316, 26)];
    //flashView.image = [UIImage stretchableImageWithPath:@"hotInfo_bg.png"];
    //flashView.backgroundColor =  [UIColor colorWithRed:3.0/255.0 green:145.0/255.0 blue:217.0/255.0 alpha:1];
    flashView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    flashView.layer.cornerRadius = 2.0f;
    flashView.alpha = 0;
    flashView.tag = 3110;
    flashView.clipsToBounds = YES;
    [detail.view addSubview:flashView];
    [flashView release];

    UILabel *tipsLbl = [[UILabel alloc] initWithFrame:flashView.bounds];
    tipsLbl.font = [UIFont boldSystemFontOfSize:14.0f];
    tipsLbl.textAlignment = UITextAlignmentCenter;
    tipsLbl.numberOfLines = 0;
    tipsLbl.lineBreakMode = UILineBreakModeWordWrap;
    tipsLbl.textColor = [UIColor whiteColor];
    tipsLbl.backgroundColor = [UIColor clearColor];
    [flashView addSubview:tipsLbl];
    [tipsLbl release];
    tipsLbl.text = tips;
    
    flashView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT - 66);
    [UIView animateWithDuration:0.3 animations:^{
        flashView.alpha = 1;
        flashView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT - 13 - 66);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 delay:3 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            flashView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT - 66);
            flashView.alpha = 0;
        } completion:^(BOOL finished) {
            [flashView removeFromSuperview];
        }];
    }];
}

#pragma mark -
#pragma mark HttpRequest
- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSData *)responseData{
    NSString *string = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
	NSDictionary *root = [string JSONValue];
	
	if ([Utils checkJsonIsErrorNoAlert:root]) {
		return ;
	}
    
    NSLog(@"%@",root);
    //NSInteger browsePrompt = [[[root safeObjectForKey:@"BrowsePrompt"] safeObjectForKey:@"Number"] intValue];
    NSInteger orderPrompt = [[[root safeObjectForKey:@"OrderPrompt"] safeObjectForKey:@"Number"] intValue];
    NSString *tips = nil;
    if(orderPrompt){
        tips = [NSString stringWithFormat:@"两天内共有 %d 人预订该酒店",orderPrompt];
    }
    
    //[self showFlashTips:tips];
    [self performSelector:@selector(showFlashTips:) withObject:tips afterDelay:.3];
}

- (void)httpConnectionDidFailed:(HttpUtil *)util withError:(NSError *)error{
    
}



- (void)chooseFirstRoom {
	if ([[[HotelDetailController hoteldetail] safeObjectForKey:RespHD_Rooms_A] count] > 0) {
		[self tableView:self didSelectRowAtIndexPath:selectedCellIndexPath];
	}
}


- (NSInteger) getDiscount:(NSDictionary *)hotel{
    NSInteger formerPirce = 0;
    if ([hotel safeObjectForKey:@"OriginalPrice"]!=[NSNull null] && [hotel safeObjectForKey:@"OriginalPrice"]) {
        formerPirce = [[hotel safeObjectForKey:@"OriginalPrice"] intValue];
    }
    
    NSInteger price = [[NSString stringWithFormat:@"%.f",[[hotel safeObjectForKey:RespHD__AveragePrice_D] floatValue]] intValue];
    
    if (formerPirce == 0) {
        return 0;
    }else if(formerPirce - price<=0){
        return 0;
    }else{
        return (price + 0.0) * 10/formerPirce;
    }
}

- (void)requestImageWithURLPath:(NSString *)path AtIndexPath:(NSIndexPath *)indexPath {  
	// 从url请求图片
	if (![progressManager containsObject:indexPath]) {
		// 过滤重复请求
		ImageDownLoader *downLoader = [[ImageDownLoader alloc] initWithURLPath:path keyString:nil indexPath:indexPath];
		[queue addOperation:downLoader];
		downLoader.delegate		= self;
		downLoader.noDataImage	= [UIImage imageNamed:@"bg_nohotelpic.png"];
		//[downLoader startDownloadWithURLPath:path keyString:hotelID indexPath:indexPath];
		[progressManager addObject:indexPath];
		[downLoader release];
	}
} 


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([[[HotelDetailController hoteldetail] safeObjectForKey:RespHD_Rooms_A] count] != indexPath.row) {
		static NSString *cellIdentifier = @"roomtypecell";
		
		RoomTypeCell *cell = (RoomTypeCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
		
		if (cell == nil) {
            cell = [[[RoomTypeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
		}
		NSUInteger row = [indexPath row];
		NSDictionary *room = [[[HotelDetailController hoteldetail] safeObjectForKey:RespHD_Rooms_A] safeObjectAtIndex:row];

		NSArray *iconDatas = [room safeObjectForKey:ADDITONINFOLIST_HOTEL];
		
		//========================= 根据数据的不同，调整cell中的控件大小和布局 ==========================
		// 货币符号显示
		NSString *currencyStr = [room safeObjectForKey:RespHL_Currency];
		if ([currencyStr isEqualToString:CURRENCY_HKD] ||
			[currencyStr isEqualToString:CURRENCY_MOP]) {
			cell.roomMarkLabel.text		= [currencyStr isEqualToString:CURRENCY_HKD] ? CURRENCY_HKDMARK : CURRENCY_MOPMARK;
		}
		else {
			cell.roomMarkLabel.text		= [currencyStr isEqualToString:CURRENCY_RMB] ? CURRENCY_RMBMARK : currencyStr;
		}
		
		cell.roomPriceLabel.frame		= CGRectMake(42, 12, 55, 20);
		cell.roomMarkLabel.frame		= CGRectMake(17, 12, 25, 20);
		cell.discountPriceLabel.frame	= CGRectMake(46, 37, 50, 17);
		cell.discountMarkLabel.text		= cell.roomMarkLabel.text;
		
		// 是否有房型图片,调整布局
        NSLog(@"==%@",[room safeObjectForKey:PICURL_HOTEL]);
		if (STRINGHASVALUE([room safeObjectForKey:PICURL_HOTEL])) {
			[cell adjustBackView:YES giftDes:nil];
			[cell makeRoomIconsByData:iconDatas HaveImage:YES];
            
            if (![tableImgeDict safeObjectForKey:indexPath]) {
				cell.roomImg.image = nil;
				[cell.roomImg startLoadingByStyle:UIActivityIndicatorViewStyleGray];
				
				[self requestImageWithURLPath:[room safeObjectForKey:PICURL_HOTEL]
								  AtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
			}else {
				[cell.roomImg endLoading];
				cell.roomImg.image = [tableImgeDict safeObjectForKey:indexPath];
			}
		}
		else {
			[cell adjustBackView:NO giftDes:nil];
			[cell makeRoomIconsByData:iconDatas HaveImage:NO];
			cell.roomImg.image = nil;
		}
        
        // 特价房做结构调整
        cell.roomPriceLabel.text		 = [NSString stringWithFormat:@"%.f",[[room safeObjectForKey:RespHD__AveragePrice_D] floatValue]];
        cell.discountPriceLabel.hidden	 = YES;
        cell.discountMarkLabel.hidden	 = YES;
        cell.lineView.hidden			 = YES;
        cell.discountImg.hidden			 = YES;
        cell.DragonVIPImg.hidden		 = YES;
        cell.timelimitImg.hidden         = YES;
        
        cell.roomPriceLabel.frame		= CGRectOffset(cell.roomPriceLabel.frame, 0, 10);
        cell.roomMarkLabel.frame		= CGRectOffset(cell.roomMarkLabel.frame, 0, 10);
        int remainingroomstock = [[room safeObjectForKey:@"MinRoomStocks"] integerValue];
		BOOL isAvailable = [[room safeObjectForKey:RespHD__IsAvailable_B] boolValue];
        if (remainingroomstock > 0 && remainingroomstock<=3 && isAvailable) {
            cell.bookbtn.frame = CGRectMake(237, 28, 66, 25);
            cell.remainroomstockLabel.text = [NSString stringWithFormat:@"仅剩%d间",remainingroomstock];
            cell.remainroomstockLabel.hidden = NO;
            cell.remainroomstockLabel.textColor = [UIColor colorWithRed:220/255.0 green:52/255.0 blue:2/255.0 alpha:1.0];
        }
        else{
            cell.bookbtn.frame = CGRectMake(237, 35, 66, 25);
            cell.remainroomstockLabel.hidden = YES;
        }
		NSString *typeName = [room safeObjectForKey:RespHD__RoomTypeName_S];
        float originalPrice = [[room safeObjectForKey:@"OriginalPrice"] floatValue];
		if ([[room safeObjectForKey:@"IsLastMinutesRoom"] boolValue] ) {
            cell.roomPriceLabel.frame		= CGRectMake(42, 12 + 6, 55, 20);
            cell.roomMarkLabel.frame		= CGRectMake(17, 13 + 5, 25, 20);
            
            float roomPrice = [[room safeObjectForKey:RespHD__AveragePrice_D] floatValue];
			cell.roomPriceLabel.text		 = [NSString stringWithFormat:@"%.f",roomPrice];
			cell.discountPriceLabel.hidden   = NO;
			cell.discountPriceLabel.text	 = [NSString stringWithFormat:@"%.f", originalPrice];
			cell.discountMarkLabel.hidden	 = NO;
            
			CGSize lineSize					 = [cell.discountPriceLabel.text sizeWithFont:cell.discountPriceLabel.font];
			cell.lineView.hidden			 = NO;
			cell.lineView.frame				 = CGRectMake(43, 46, lineSize.width + 6, 1);
            //若原价为0 则去掉划价
			if (originalPrice <= 0 || originalPrice <= roomPrice) {
                cell.discountPriceLabel.hidden = YES;
                cell.discountMarkLabel.hidden = YES;
                cell.lineView.hidden = YES;
                cell.roomPriceLabel.frame		= CGRectMake(42, 26, 55, 20);
                cell.roomMarkLabel.frame		= CGRectMake(17, 27-1, 25, 20);

            }
			cell.discountImg.hidden			 = NO;
            
           
		}
        NSString *vipNO = [[AccountManager instanse] DragonVIP];
        if ([[room safeObjectForKey:@"CustomerLevel"] intValue] == 4 && [[AccountManager instanse] isLogin] && [vipNO length]>0 ) {
            float discountPrice = [[room safeObjectForKey:@"LongCuiOriginalPrice"] floatValue];
            float roomPrice = [[room safeObjectForKey:RespHD__AveragePrice_D] floatValue];
            if (discountPrice > 0 && discountPrice > roomPrice) {
                cell.roomPriceLabel.frame		= CGRectMake(42, 12 + 6, 55, 20);
                cell.roomMarkLabel.frame		= CGRectMake(17, 13 + 5, 25, 20);
                
                cell.roomPriceLabel.text		 = [NSString stringWithFormat:@"%.f",roomPrice];
                cell.discountPriceLabel.hidden   = NO;
                cell.discountPriceLabel.text	 = [NSString stringWithFormat:@"%.f", discountPrice];
                cell.discountMarkLabel.hidden	 = NO;
                CGSize lineSize					 = [cell.discountPriceLabel.text sizeWithFont:cell.discountPriceLabel.font];
                cell.lineView.hidden			 = NO;
                cell.lineView.frame				 = CGRectMake(43, 46, lineSize.width + 6, 1);
                cell.DragonVIPImg.hidden			 = NO;
            }
            else
            {
                cell.DragonVIPImg.hidden			 = NO;
            }
		}
		// ======================================================================================================
        
        // 预付显示
        if ([[room safeObjectForKey:@"PayType"] intValue] == 0) {
            cell.prepayIcon.hidden = YES;
            [cell.couponbtn setTitleColor:[UIColor colorWithRed:1.0f green:84.0/255.0f blue:0 alpha:1] forState:UIControlStateNormal];
            [cell.couponbtn setBackgroundImage:[UIImage imageNamed:@"money_back_ico.png"] forState:UIControlStateNormal];
        }
        else {
            cell.prepayIcon.hidden = NO;
            [cell.couponbtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [cell.couponbtn setBackgroundImage:[UIImage imageNamed:@"money_reduce_ico.png"] forState:UIControlStateNormal];
        }
        
        [cell setRoomTypeName:typeName breakfastNum:0];
    
		cell.description.text=[room safeObjectForKey:RespHD__Description_S];
		
		if ([room safeObjectForKey:RespHD__HotelCoupon_DI] != [NSNull null]) {
			NSString *co = [NSString stringWithFormat:_string(@"s_coupon_string"),
							[[[room safeObjectForKey:RespHD__HotelCoupon_DI] safeObjectForKey:RespHD___TrueUpperlimit] intValue]];
			cell.couponbtn.hidden=NO;
			cell.couponbtn.titleEdgeInsets = UIEdgeInsetsMake(1, 25, 0, 0);
			[cell.couponbtn setTitle:co forState:UIControlStateNormal];
			[cell.couponbtn setTitleColor:[UIColor colorWithRed:1.0f green:84.0/255.0f blue:0 alpha:1] forState:UIControlStateNormal];
		}else {
			cell.couponbtn.hidden=YES;
		}
		cell.roomindex=row;
		
		cell.bookbtn.enabled = isAvailable;
        
        if(selectedCellIndexPath && [selectedCellIndexPath compare:indexPath] == NSOrderedSame) {
            cell.separatorLine.hidden = YES;
        }
        else {
            cell.separatorLine.hidden = NO;
        }
            
		return cell;
	}
	else {
		// 必要的占位栏
		UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
														reuseIdentifier:nil] autorelease];
		cell.userInteractionEnabled = NO;
        
        UIImageView *cellBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 12, 16)];
        cellBgView.image = [UIImage stretchableImageWithPath:@"hoteldetail_cell_footer.png"];
        [cell addSubview:cellBgView];
        cellBgView.opaque = YES;
        [cellBgView release];
			
		return cell;
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[[HotelDetailController hoteldetail] safeObjectForKey:RespHD_Rooms_A] count] + 1;
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return;
    }
	self.selectedCellIndexPath = indexPath;
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    RoomTypeCell *cell = (RoomTypeCell *)[tableView cellForRowAtIndexPath:indexPath];
    
	if(![preCellIndexPath isEqual:selectedCellIndexPath]) {
		cell.separatorLine.hidden = YES;
		
		RoomTypeCell *lastCell = (RoomTypeCell *)[tableView cellForRowAtIndexPath:preCellIndexPath];
		lastCell.separatorLine.hidden = NO;
		self.preCellIndexPath = selectedCellIndexPath;
	}
	else {
		cell.separatorLine.hidden = NO;
        self.selectedCellIndexPath = nil;
		self.preCellIndexPath = nil;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([[[HotelDetailController hoteldetail] safeObjectForKey:RespHD_Rooms_A] count] == indexPath.row) {
		return 91;
	}
	else {
		if(selectedCellIndexPath != nil && [selectedCellIndexPath compare:indexPath] == NSOrderedSame && ![preCellIndexPath isEqual:selectedCellIndexPath])
		{
			// 选中行高度
			NSDictionary *room = [[[HotelDetailController hoteldetail] safeObjectForKey:RespHD_Rooms_A] safeObjectAtIndex:indexPath.row];
			if ([room safeObjectForKey:PICURL_HOTEL] != [NSNull null]) {
				// 有房型图片时的高度
				return  159;
			}
			else {
				// 没有房型图片时的高度
				return  126;
			}
		}
		else {
			return kCellNormalHeight;
		}
	}
}


#pragma mark -
#pragma mark ImageDown Delegate

- (void)imageDidLoad:(NSDictionary *)imageInfo {
	UIImage *image          = [imageInfo safeObjectForKey:keyForImage];
	NSIndexPath *indexPath	= [imageInfo safeObjectForKey:keyForPath];
	
	[tableImgeDict safeSetObject:image forKey:indexPath];
	
	NSDictionary *celldata = [NSDictionary dictionaryWithObjectsAndKeys:  
							  indexPath, @"indexPath",   
							  image, @"image",  
							  nil];  
	
	[self performSelectorOnMainThread:@selector(setCellImageWithData:) withObject:celldata waitUntilDone:NO];
}


- (void)setCellImageWithData:(id)celldata {
	UIImage *img		= [celldata safeObjectForKey:@"image"]; 
	NSIndexPath *index	= [celldata safeObjectForKey:@"indexPath"];
	
	RoomTypeCell *cell = (RoomTypeCell *)[self cellForRowAtIndexPath:index];
	[cell.roomImg endLoading];
	cell.roomImg.image = img;
}


- (void)dealloc {
	self.selectedCellIndexPath = nil;
	self.preCellIndexPath = nil;
    self.detail = nil;
    
    [hotRequest cancel];
    SFRelease(hotRequest);
	
	// cancel Downloads
	[queue cancelAllOperations];
	[queue release];
	
	[tableImgeDict release];
	[progressManager release];
    
    [super dealloc];
}


@end
