//
//  MyFavorite.m
//  ElongClient
//
//  Created by bin xing on 11-2-19.
//  Copyright 2011 DP. All rights reserved.
//

#import "MyFavorite.h"
#import "DefineHotelResp.h"
#import "DefineHotelReq.h"
static int currentIndx;
static NSMutableArray *hotels = nil;

@implementation MyFavorite
-(int)labelHeightWithNSString:(UIFont *)font string:(NSString *)string width:(int)width{
	
	CGSize expectedLabelSize = [string sizeWithFont:font constrainedToSize:CGSizeMake(width, 1000) lineBreakMode:UILineBreakModeCharacterWrap];
	
	
	return expectedLabelSize.height;
	
}


-(id)init:(NSString *)name style:(NavBtnStyle)style label:(UILabel *)label{

	if (self=[super init:name style:style]) {
		favoriteLabel=label;
	}
	return self;
}

+ (NSMutableArray *)hotels  {
	@synchronized(self) {
		if(!hotels) {
			hotels = [[NSMutableArray alloc] init];
		}
	}
	return hotels;
}

+ (int)currentIndex{
	return currentIndx;
}

-(void)loadView{
	[super loadView];
	
	defaultTableView = [[UITableView alloc] 
						initWithFrame:CGRectMake(7, 15, 306, 416-20) 
						style:UITableViewStylePlain];
	
	defaultTableView.backgroundColor = [UIColor whiteColor];
	defaultTableView.delegate=self;
	defaultTableView.dataSource=self;
	
	[self.view addSubview:defaultTableView];
	[defaultTableView release];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
   
	NSUInteger row =[indexPath row];
	static NSString *CellIdentifier = @"IdentiferFavortieCell";
	
	MyFavoriteCell *cell = (MyFavoriteCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MyFavoriteCell" owner:self options:nil];
		cell = [nib safeObjectAtIndex:0];
	}
	
	NSDictionary *hotel = [[MyFavorite hotels] safeObjectAtIndex:row];
	
	cell.hotelNameLabel.text=[hotel safeObjectForKey:RespHF__HotelName_S];
	cell.hotelRatingLabel.text=[NSString stringWithFormat:@"%.1f",[[hotel safeObjectForKey:RespHF__Rating_D] floatValue]];
	cell.hotelAddressLabel.text=[hotel safeObjectForKey:RespHF__Address_S];
	
	int heightCountForinfoLable = [self labelHeightWithNSString:cell.hotelAddressLabel.font string:cell.hotelAddressLabel.text width:210];
	
	if (heightCountForinfoLable >0){
		CGRect oldframe=cell.hotelAddressLabel.frame;
		oldframe.size.height=heightCountForinfoLable;
		oldframe.origin.y=55;
		cell.hotelAddressLabel.frame=oldframe;
		//	cell.infoLable.backgroundColor=[UIColor redColor];
		cell.cellHeight=80+heightCountForinfoLable-21;
	}else {
		cell.cellHeight=80;
	}
	
	
	int statlevel=[[hotel safeObjectForKey:RespHF__Star_I] intValue];
	if (statlevel<=0) {
		statlevel=1;
	}else if (statlevel>5) {
		statlevel=5;
	}
	cell.starLevelImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"ico_hotel_%istar.png",statlevel]];
  
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	MyFavoriteCell *cell = (MyFavoriteCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
	
	
	return cell.cellHeight;
	
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	int row = [indexPath row];
	currentIndx=row;
	[self.navigationController popViewControllerAnimated:YES];
	favoriteLabel.text=[[[MyFavorite hotels] safeObjectAtIndex:currentIndx] safeObjectForKey:RespHF__HotelName_S];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	return [[MyFavorite hotels] count];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
	//defaultTableView=nil;
	
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	//[defaultTableView release];

    [super dealloc];
}


@end
