//
//  FlightEditInsurerView.m
//  ElongClient
//
//  Created by chenggong on 13-12-13.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "FlightEditInsurerView.h"
#import "FlightEditInsurerViewCell.h"

#define kFlightEditInsurerInfoViewX             17.0f
#define kFlightEditInsurerInfoViewY             47.0f
#define kFlightEditInsurerInfoViewHeight        390.0f
#define kFlightEditInsurerCommonLabelHeight     44.0f
#define kFlightEditMoneyDescriptionWidth        80.0f
#define kFlightEditRmbSignLabelWidth            13.0f
#define kFlightEditTotalMoneyLabelWidth         118.0f
#define kFlightEditMoneyLabelEdgeInset          15.0f
#define kFlightEditInsureDescriptionWidth       88.0f
#define kFlightEditInsureMoneyAndNumWidth       116.0f
#define kFlightEditSwitchWidth                  63.0f
#define kFlightEditCellHeight                   44.0f

@interface FlightEditInsurerView ()

@property (nonatomic, retain) UILabel *totalMoneyLabel;
@property (nonatomic, retain) UILabel *insurerMoneyAndNumLabel;
@property (nonatomic, retain) UIView *insurerInfoView;
@property (nonatomic, retain) UIView *maskView;
@property (nonatomic, retain) UITableView *insurerTableView;
@property (nonatomic, retain) UISwitch *insureSwitch;
@property (nonatomic, retain) NSMutableDictionary *selectedDictionary;

@end

@implementation FlightEditInsurerView

- (void)dealloc
{
    self.insurerArray = nil;
    self.selectedDictionary = nil;
    
    self.totalMoneyLabel = nil;
    self.insurerMoneyAndNumLabel = nil;
    
    _insurerTableView.delegate = nil;
    _insurerTableView.dataSource = nil;
    self.insurerTableView = nil;
    self.insureSwitch = nil;
    
    [_maskView removeFromSuperview];
//    self.maskView = nil;
    [_insurerInfoView removeFromSuperview];
//    self.insurerInfoView = nil;
    
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        NSMutableDictionary *tempMutableDictionary = [[NSMutableDictionary alloc] init];
        self.selectedDictionary = tempMutableDictionary;
        [tempMutableDictionary release];
        
        self.frame = CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.backgroundColor = [UIColor colorWithRed:245.0f / 255 green:245.0f / 255 blue:245.0f / 255 alpha:1.0f];
        
        UIWindow *window = ((ElongClientAppDelegate *)[UIApplication sharedApplication].delegate).window;
        
        UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        self.maskView = maskView;
        maskView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.8f];
        
        // 单击手势
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskSingleTap:)];
        singleTap.numberOfTapsRequired = 1;
        singleTap.numberOfTouchesRequired = 1;
        singleTap.delegate = self;
        singleTap.cancelsTouchesInView = NO;
        [maskView addGestureRecognizer:singleTap];
        [singleTap release];
        
        [window addSubview:maskView];
        [maskView release];
        
        // Info content view.
        UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(kFlightEditInsurerInfoViewX, kFlightEditInsurerInfoViewY, SCREEN_WIDTH - 2 * kFlightEditInsurerInfoViewX, kFlightEditInsurerInfoViewHeight * COEFFICIENT_Y)];
        tempView.backgroundColor = [UIColor whiteColor];
        [window addSubview:tempView];
        self.insurerInfoView = tempView;
        [tempView release];
        
        
        // Title label.
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(_insurerInfoView.frame), kFlightEditInsurerCommonLabelHeight)];
        titleLabel.backgroundColor = [UIColor colorWithRed:245.0f / 255 green:245.0f / 255 blue:245.0f / 255 alpha:1.0f];
        titleLabel.text = @"保险";
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont fontWithName:@"STHeitiJ-Light" size:18.0f];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [_insurerInfoView addSubview:titleLabel];
        [titleLabel release];
        
        // Total money content label.
        UILabel *totalMoneyContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, kFlightEditInsurerCommonLabelHeight, CGRectGetWidth(_insurerInfoView.frame), kFlightEditInsurerCommonLabelHeight)];
        totalMoneyContentLabel.backgroundColor = [UIColor colorWithRed:245.0f / 255 green:245.0f / 255 blue:245.0f / 255 alpha:1.0f];
        UIView *cellTopLineView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 0.5f)];
        cellTopLineView.backgroundColor = [UIColor grayColor];
        [totalMoneyContentLabel addSubview:cellTopLineView];
        [cellTopLineView release];
        
        UIView *cellBottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetHeight(totalMoneyContentLabel.frame) - 0.5f, 320.0f, 0.5f)];
        cellBottomLineView.backgroundColor = [UIColor grayColor];
        [totalMoneyContentLabel addSubview:cellBottomLineView];
        [cellBottomLineView release];
        
        // Money description label.
        UILabel *moneyDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(kFlightEditMoneyLabelEdgeInset, 0.0f, kFlightEditMoneyDescriptionWidth, kFlightEditInsurerCommonLabelHeight)];
        moneyDescriptionLabel.text = @"保险总金额";
        moneyDescriptionLabel.textColor = [UIColor blackColor];
        moneyDescriptionLabel.font = [UIFont fontWithName:@"STHeitiJ-Medium" size:16.0f];
        [totalMoneyContentLabel addSubview:moneyDescriptionLabel];
//        [moneyDescriptionLabel release];
        
        // RMB sign label.
        UILabel *rmbSignLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(moneyDescriptionLabel.frame) + CGRectGetWidth(moneyDescriptionLabel.frame), 0.0f, kFlightEditRmbSignLabelWidth, kFlightEditInsurerCommonLabelHeight)];
        rmbSignLabel.text = @"￥";
        rmbSignLabel.textColor = [UIColor colorWithRed:254.0f / 255 green:75.0f / 255 blue:32.0f / 255 alpha:1.0f];
        rmbSignLabel.font = [UIFont fontWithName:@"STHeitiJ-Medium" size:13.0f];
        [totalMoneyContentLabel addSubview:rmbSignLabel];
        
        // Money label.
        UILabel *totalMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(rmbSignLabel.frame) + CGRectGetWidth(rmbSignLabel.frame), 0.0f, kFlightEditTotalMoneyLabelWidth, kFlightEditInsurerCommonLabelHeight)];
        totalMoneyLabel.textAlignment = NSTextAlignmentLeft;
        totalMoneyLabel.text = @"";
        totalMoneyLabel.textColor = [UIColor colorWithRed:254.0f / 255 green:75.0f / 255 blue:32.0f / 255 alpha:1.0f];
        totalMoneyLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0f];
        self.totalMoneyLabel = totalMoneyLabel;
        [totalMoneyContentLabel addSubview:totalMoneyLabel];
        
        [totalMoneyLabel release];
        [rmbSignLabel release];
        [moneyDescriptionLabel release];
        
        [_insurerInfoView addSubview:totalMoneyContentLabel];
        [totalMoneyContentLabel release];
        
        // Insure content label.
        UILabel *insureContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, kFlightEditInsurerCommonLabelHeight * 2, CGRectGetWidth(_insurerInfoView.frame), kFlightEditInsurerCommonLabelHeight)];
        insureContentLabel.userInteractionEnabled = YES;
        insureContentLabel.backgroundColor = [UIColor whiteColor];
        cellBottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetHeight(insureContentLabel.frame) - 0.5f, CGRectGetWidth(_insurerInfoView.frame), 0.5f)];
        cellBottomLineView.backgroundColor = [UIColor grayColor];
        [insureContentLabel addSubview:cellBottomLineView];
        [cellBottomLineView release];
        
        // Insure description label.
        UILabel *insureDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(kFlightEditMoneyLabelEdgeInset, 0.0f, kFlightEditInsureDescriptionWidth, kFlightEditInsurerCommonLabelHeight)];
        insureDescriptionLabel.text = @"航空意外险";
        insureDescriptionLabel.textColor = [UIColor blackColor];
        insureDescriptionLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.0f];
        [insureContentLabel addSubview:insureDescriptionLabel];
        
        // Money and number label.
        UILabel *insureMoneyAndNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(insureDescriptionLabel.frame) + CGRectGetWidth(insureDescriptionLabel.frame), 0.0f, kFlightEditInsureMoneyAndNumWidth, kFlightEditInsurerCommonLabelHeight)];
        insureMoneyAndNumLabel.text = @"";
        insureMoneyAndNumLabel.textColor = [UIColor blackColor];
        insureMoneyAndNumLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.0f];
        self.insurerMoneyAndNumLabel = insureMoneyAndNumLabel;
        [insureContentLabel addSubview:insureMoneyAndNumLabel];
        
        UISwitch* tempSwitch = [[ UISwitch alloc]initWithFrame:CGRectMake(CGRectGetMinX(insureMoneyAndNumLabel.frame) + CGRectGetWidth(insureMoneyAndNumLabel.frame), 7.0f, kFlightEditSwitchWidth, kFlightEditInsurerCommonLabelHeight)];
        [tempSwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
        self.insureSwitch = tempSwitch;
        [insureContentLabel addSubview:tempSwitch];
        
        [tempSwitch release];
        [insureDescriptionLabel release];
        [insureMoneyAndNumLabel release];
        
        [_insurerInfoView addSubview:insureContentLabel];
        [insureContentLabel release];
        
        UITableView *tempTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, kFlightEditInsurerCommonLabelHeight * 3, CGRectGetWidth(_insurerInfoView.frame), kFlightEditInsurerCommonLabelHeight * 3 + 0.5f)];
        tempTableView.hidden = !_insureSwitch.on;
        tempTableView.dataSource = self;
        tempTableView.delegate = self;
        tempTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        cellBottomLineView = [[[UIView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetHeight(insureContentLabel.frame) - 0.5f, 320.0f, 0.5f)] autorelease];
//        cellBottomLineView.backgroundColor = [UIColor grayColor];
//        [tempTableView addSubview:cellBottomLineView];
//        [cellBottomLineView release];
        
        self.insurerTableView = tempTableView;
        [_insurerInfoView addSubview:tempTableView];
        [tempTableView release];
        
        UIButton *okButton = [UIButton uniformButtonWithTitle:@"确认" ImagePath:@"" Target:self Action:@selector(okButtonPressed) Frame:CGRectMake(15.0f, 343.0f * COEFFICIENT_Y, 260.0f, 40.0f)];
        [_insurerInfoView addSubview:okButton];
        
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton setImage:[UIImage noCacheImageNamed:@"closeRoundButton.png"] forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(closeInsurerInfoView:) forControlEvents:UIControlEventTouchUpInside];
        closeButton.frame = CGRectMake(CGRectGetWidth(_insurerInfoView.frame) - 57.0f / 2, - 57.0f / 2, 57.0f, 57.0f);
        [_insurerInfoView addSubview:closeButton];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - Public methods.
- (void)refreshInsurerTableView
{
    if (_insurerArray && [_insurerArray count] > 0) {
        [_insurerTableView reloadData];
    }
}

#pragma mark - Private methods.
- (void)okButtonPressed
{
}

- (void)closeInsurerInfoView:(id)sender
{
    [self removeFromSuperview];
}


#pragma mark - UIGestureDelegate Implement method.
- (void)maskSingleTap:(UIGestureRecognizer *)gestureRecognizer{
    [self removeFromSuperview];
}

#pragma mark - UISwitch Implement method.
- (void) switchValueChanged:(id)sender{
    UISwitch* control = (UISwitch*)sender;
    if(control == _insureSwitch){
        //添加自己要处理的事情代码
        _insurerTableView.hidden =  !_insureSwitch.on;
        if (_insureSwitch.on) {
            _insurerMoneyAndNumLabel.text = [NSString stringWithFormat:@"(￥30/人x%d)", [_selectedDictionary count]];
            _totalMoneyLabel.text = [NSString stringWithFormat:@"%d", [_selectedDictionary count] * 30];
        }
        else {
            _insurerMoneyAndNumLabel.text = @"";
            _totalMoneyLabel.text = @"";
        }
    }
}

#pragma mark -
#pragma mark Delegate
#pragma mark UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_insurerArray) {
        return [_insurerArray count];
    }
	return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return kFlightEditCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *FlightEditInsurerViewCellKey = @"FlightEditInsurerViewCellKey";
    FlightEditInsurerViewCell *cell = (FlightEditInsurerViewCell *)[tableView dequeueReusableCellWithIdentifier:FlightEditInsurerViewCellKey];
    if (cell == nil) {
        cell = [[[FlightEditInsurerViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FlightEditInsurerViewCellKey] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *cellLineView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, kFlightEditCellHeight - 0.5f, 320.0f, 0.5f)];
        cellLineView.backgroundColor = [UIColor grayColor];
        [cell addSubview:cellLineView];
        [cellLineView release];
    }
    cell.backgroundColor = [UIColor whiteColor];
    
    //set cell
    NSUInteger row = [indexPath row];
    //    row -= cellRowOffset;
    //select
    if ([_selectedDictionary safeObjectForKey:indexPath] == [_insurerArray safeObjectAtIndex:row]) {
        cell.isSelected = YES;
        cell.selectImgView.image = [UIImage imageNamed:@"btn_checkbox_checked.png"];
    } else {
        cell.isSelected = NO;
        cell.selectImgView.image = [UIImage imageNamed:@"btn_checkbox.png"];
    }

    
    cell.nameLabel.text = [_insurerArray safeObjectAtIndex:row];
    return cell;
}

//select cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    FlightEditInsurerViewCell *cell = (FlightEditInsurerViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.isSelected) {
        cell.isSelected = NO;
        [_selectedDictionary removeObjectForKey:indexPath];
        cell.selectImgView.image = [UIImage imageNamed:@"btn_checkbox.png"];
        
    } else {
        cell.isSelected = YES;
        [_selectedDictionary safeSetObject:[_insurerArray safeObjectAtIndex:[indexPath row]] forKey:indexPath];
        cell.selectImgView.image = [UIImage imageNamed:@"btn_checkbox_checked.png"];
    }
    
    if (_insureSwitch.on) {
        _insurerMoneyAndNumLabel.text = [NSString stringWithFormat:@"(￥30/人x%d)", [_selectedDictionary count]];
        _totalMoneyLabel.text = [NSString stringWithFormat:@"%d", [_selectedDictionary count] * 30];
    }
    
    [tableView reloadData];
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
