//
//  SepecialNeedOptionView.m
//  ElongClient
//
//  Created by Ivan.xu on 13-6-25.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "SepecialNeedOptionView.h"
#import "Utils.h"
#import "InterHotelDetailCtrl.h"

@interface SepecialNeedOptionView ()

@property(nonatomic,copy) NSString *needInfo;
@property(nonatomic,retain) NSMutableDictionary *selectedSepecialInfo;

-(void)confirm;

@end

@implementation SepecialNeedOptionView
@synthesize needInfo;
@synthesize selectedSepecialInfo;
@synthesize delegate;

- (void)dealloc
{
    [needInfo release];
    [selectedSepecialInfo release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithSpecialNeeds:(NSString *)sepecialNeedInfo{
    self = [super init];
    if(self){
        self.needInfo = sepecialNeedInfo;
        if(!selectedSepecialInfo){
            selectedSepecialInfo = [[NSMutableDictionary alloc] initWithCapacity:1];
        }
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 244)];
        contentView.backgroundColor = RGBACOLOR(248, 248, 248, 1);
        [self addSubview:contentView];
        [contentView release];
        
        UITableView *mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, 150)];
        mainTable.backgroundColor = [UIColor clearColor];
        mainTable.delegate = self;
        mainTable.dataSource = self;
        mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        [contentView addSubview:mainTable];
        [mainTable release];
        mainTable.scrollEnabled = NO;
        
        
        UILabel *noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 194, 300, 50)];
        noteLabel.backgroundColor = [UIColor clearColor];
        noteLabel.font = [UIFont systemFontOfSize:13];
        noteLabel.textColor = RGBACOLOR(93, 93, 93, 1);
        noteLabel.numberOfLines = 2;
        noteLabel.lineBreakMode = UILineBreakModeTailTruncation;
        noteLabel.text = @"我们会将您的偏好转达给酒店，但不保证酒店一定可以满足(包括床型偏好)";
        [contentView addSubview:noteLabel];
        [noteLabel release];
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        [contentView addSubview:headerView];
        [headerView release];

        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT)];
		[titleLabel setBackgroundColor:[UIColor clearColor]];
		[titleLabel setFont:FONT_B18];
		[titleLabel setTextAlignment:UITextAlignmentCenter];
		[titleLabel setTextColor:RGBACOLOR(52, 52, 52, 1)];
		[titleLabel setText:@"其他偏好"];
		[headerView addSubview:titleLabel];
		[titleLabel release];
        
        UIImageView *topSplitView = [[UIImageView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)];
        topSplitView.image = [UIImage noCacheImageNamed:@"dashed.png"];
        [headerView addSubview:topSplitView];
        [topSplitView release];
        
        // left button
        
        UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 0, 50, NAVIGATION_BAR_HEIGHT)];
		[leftBtn.titleLabel setFont:FONT_B16];
		[leftBtn setTitle:@"取消" forState:UIControlStateNormal];
		[leftBtn setTitleColor:COLOR_NAV_BTN_TITLE forState:UIControlStateNormal];
        [leftBtn setTitleColor:COLOR_NAV_BIN_TITLE_H forState:UIControlStateHighlighted];
		[leftBtn addTarget:self action:@selector(dismissInView) forControlEvents:UIControlEventTouchUpInside];
		[headerView addSubview:leftBtn];
		[leftBtn release];
        
        // left button
		UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(320-55, 5, 50, TABITEM_DEFALUT_HEIGHT)];
		[rightBtn.titleLabel setFont:FONT_B16];
		[rightBtn setTitle:@"确定" forState:UIControlStateNormal];
        [rightBtn setTitleColor:COLOR_NAV_BTN_TITLE forState:UIControlStateNormal];
        [rightBtn setTitleColor:COLOR_NAV_BIN_TITLE_H forState:UIControlStateHighlighted];
		[rightBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
		[headerView addSubview:rightBtn];
		[rightBtn release];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/




#pragma mark - UITableView delegate and Datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary *roomInfo = [[InterHotelDetailCtrl rooms] safeObjectAtIndex:[InterRoomCell currentSelectedRoomIndex]];
    NSDictionary *remark = [roomInfo safeObjectForKey:@"Remark"];       //特殊需求
    NSArray *sepecialNeed = [remark safeObjectForKey:@"SpecialNeeds"];
    return sepecialNeed.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"BedType";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(!cell){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName] autorelease];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        UIImageView *checkImg = [[UIImageView alloc] initWithFrame:CGRectMake(18, 10, 28, 24)];
        checkImg.tag = 101;
        checkImg.contentMode = UIViewContentModeCenter;
        checkImg.image = [UIImage imageNamed:@"btn_choice.png"];
        checkImg.highlightedImage = [UIImage imageNamed:@"btn_choice_checked.png"];
        [cell addSubview:checkImg];
        [checkImg release];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake( 60 ,10, 300, 24)];
        label.tag = 102;
		label.backgroundColor	= [UIColor clearColor];
		label.font				= FONT_B16;
		label.adjustsFontSizeToFitWidth = YES;
		label.minimumFontSize	= 14;
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		[cell addSubview:label];
		[label release];
        
        //虚线
        UIImageView *dashLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44 - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)];
        dashLine.image = [UIImage noCacheImageNamed:@"dashed.png"];
        [cell addSubview:dashLine];
        [dashLine release];
    }
    
    UIImageView *checkImg = (UIImageView *)[cell viewWithTag:101];
    UILabel *textLabel = (UILabel *)[cell viewWithTag:102];
    
    NSDictionary *roomInfo = [[InterHotelDetailCtrl rooms] safeObjectAtIndex:[InterRoomCell currentSelectedRoomIndex]];
    NSDictionary *remark = [roomInfo safeObjectForKey:@"Remark"];       //特殊需求
    NSArray *sepecialNeed = [remark safeObjectForKey:@"SpecialNeeds"];
    NSDictionary *sepecialInfo = [sepecialNeed safeObjectAtIndex:indexPath.row];
    textLabel.text = [sepecialInfo safeObjectForKey:@"Text"];
    
    if([self.needInfo rangeOfString:textLabel.text].length>0){
        checkImg.highlighted = YES;
        [self.selectedSepecialInfo safeSetObject:sepecialInfo forKey:[NSString stringWithFormat:@"%d",indexPath.row]];
    }else{
        checkImg.highlighted = NO;
        [self.selectedSepecialInfo safeSetObject:[NSNull null] forKey:[NSString stringWithFormat:@"%d",indexPath.row]];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIImageView *checkImg = (UIImageView *)[cell viewWithTag:101];
    
    NSDictionary *tmpDic = [self.selectedSepecialInfo safeObjectForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
    if(DICTIONARYHASVALUE(tmpDic)){
        [self.selectedSepecialInfo safeSetObject:[NSNull null] forKey:[NSString stringWithFormat:@"%d",indexPath.row]];
        checkImg.highlighted = NO;
    }else{
        NSDictionary *roomInfo = [[InterHotelDetailCtrl rooms] safeObjectAtIndex:[InterRoomCell currentSelectedRoomIndex]];
        NSDictionary *remark = [roomInfo safeObjectForKey:@"Remark"];       //特殊需求
        NSArray *sepecialNeed = [remark safeObjectForKey:@"SpecialNeeds"];
        NSDictionary *sepecialInfo = [sepecialNeed safeObjectAtIndex:indexPath.row];
        [self.selectedSepecialInfo safeSetObject:sepecialInfo forKey:[NSString stringWithFormat:@"%d",indexPath.row]];
        checkImg.highlighted = YES;
    }
}


-(void)confirm{
    CFShow(self.selectedSepecialInfo);
    if([delegate respondsToSelector:@selector(postSelectedSepecialNeedOption:)]){
        [delegate postSelectedSepecialNeedOption:self.selectedSepecialInfo];
    }
}

- (void)dismissInView{
    if ([delegate respondsToSelector:@selector(cancelSelectedSepecial)]) {
        [delegate cancelSelectedSepecial];
    }
}

@end
