//
//  SelectedAddressView.m
//  ElongClient
//	选择邮寄地址页面
//
//  Created by haibo on 11-11-25.
//  Copyright 2011 elong. All rights reserved.
//

#import "SelectedAddressView.h"
#import "AddAddress.h"
#import "ElongClientAppDelegate.h"
#import "FlightDataDefine.h"
#import "SelectAddressCell.h"


static int WORD_WIDTH_LIMIT = 230;

@interface SelectedAddressView ()

- (int)getTableViewHeight:(NSArray *)array componentWidth:(float)componentWidth;

@end


@implementation SelectedAddressView

@synthesize addressArray;


- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	self.addressArray = nil;
	
    [super dealloc];
}


- (id)initWithFrame:(CGRect)frame AddressArray:(NSArray *)addresses {
    
    self = [super initWithFrame:frame];
    if (self) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFillInfo:) name:ADDRESS_ADD_NOTIFICATION object:nil];
		
		NSMutableArray *dataArray = [NSMutableArray array];
		for (NSDictionary *dDictionary in addresses) {
			NSString *str = [[NSString alloc] initWithFormat:@"%@ / %@", [dDictionary safeObjectForKey:KEY_NAME], [dDictionary safeObjectForKey:KEY_ADDRESS_CONTENT]];
			[dataArray addObject:str];
			[str release];
		}
		
		currentRow	= 0;
		lastRow		= 0;
		
		self.addressArray = dataArray;
		addressViewHeight = [self getTableViewHeight:addressArray componentWidth:WORD_WIDTH_LIMIT];
		
		[self performSelector:@selector(addMainView)];
    }
	
    return self;
}


- (void)addMainView {
	// 添加背景图
	backView = [UIImageView roundCornerViewWithFrame:CGRectMake(0, 0, self.frame.size.width, addressViewHeight + 100)];
	[self addSubview:backView];
	
	// 添加标题栏
	titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 200, 22)];
	titleLabel.text				= @"选择邮寄地址：";
	titleLabel.font				= FONT_16;
	titleLabel.backgroundColor	= [UIColor clearColor];
	titleLabel.textColor		= [UIColor blackColor];
	titleLabel.textAlignment	= UITextAlignmentLeft;
	[backView addSubview:titleLabel];
	[titleLabel release];
	
	// 添加地址栏
	addressTable = [[UITableView alloc] initWithFrame:CGRectMake(0, titleLabel.frame.origin.y + titleLabel.frame.size.height + 5, self.frame.size.width, addressViewHeight + 6)];
	addressTable.backgroundColor	= [UIColor clearColor];
	addressTable.separatorStyle		= UITableViewCellSeparatorStyleNone;
	addressTable.dataSource			= self;
	addressTable.delegate			= self;
	[backView addSubview:addressTable];
	[addressTable release];
	
	separator2 = [UIImageView graySeparatorWithFrame:CGRectMake(5, addressTable.frame.origin.y + addressTable.frame.size.height + 6, BOTTOM_BUTTON_WIDTH, 1)];
	separator2.clipsToBounds = YES;
	[backView addSubview:separator2];
	
	CGFloat addButtonOffY = 8 + addressTable.frame.origin.y + addressTable.frame.size.height;
	
	if ([addressArray count] == 0) {
		// 没有地址时，隐藏一部分ui
		titleLabel.hidden = YES;
		separator2.hidden = YES;
		addButtonOffY = -3.0;
	}
	
	// 添加底栏
	addButton = [UIButton arrowButtonWithTitle:@"新增邮寄地址"
									     Target:self 
									     Action:@selector(addButtonPressed) 
										  Frame:CGRectMake(5, addButtonOffY, BOTTOM_BUTTON_WIDTH, BOTTOM_BUTTON_HEIGHT)
								    Orientation:PlusSign];
	addButton.titleLabel.font = FONT_16;
	addButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 180);
	[backView addSubview:addButton];
	
	separator = [UIImageView graySeparatorWithFrame:CGRectMake(5, addButton.frame.origin.y + addButton.frame.size.height + 1, BOTTOM_BUTTON_WIDTH, 1)];
	[backView addSubview:separator];
}

#pragma mark -
#pragma mark Public Methods

- (void)setNextButtonTarget:(id)target action:(SEL)selector {
	commitButton = [UIButton uniformButtonWithTitle:@"下一步"
										  ImagePath:@"next_sign.png"
											 Target:target 
											 Action:selector 
											  Frame:CGRectMake(3, addressViewHeight + 110, 294, 46)];
	
	[self addSubview:commitButton];
}


- (NSString *)getSelectedAddress {
	return [addressArray safeObjectAtIndex:currentRow];
}

- (void) setTextField:(UITextField *)tf{
    textField  = tf;
}


#pragma mark -
#pragma mark Private Method

- (void)addButtonPressed {
    if (textField) {
        [textField resignFirstResponder];
    }
	ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
	
	AddAddress *controller = [[AddAddress alloc] init];
	[appDelegate.navigationController pushViewController:controller animated:YES];
	[controller release];
}


- (int)getLineHeight:(NSString *)string componentWidth:(float)componentWidth {
	// 获取每行cell的高度
	int height		= 0;
	UIFont *font	= FONT_12;
	CGSize size		= [string sizeWithFont:font constrainedToSize:CGSizeMake(componentWidth, 2000) lineBreakMode:UILineBreakModeCharacterWrap];
	
	height += (size.height + 10);
	if (height < 40) {
		// 最小cell高度
		height = 40;
	}
	
	return height;
}


- (int)getTableViewHeight:(NSArray *)array componentWidth:(float)componentWidth {
	// 获取tableview的总高度（各行之和）
	int height = 0;
	if (array == nil || [array count] == 0) {
		return height;
	}
	
	for (int i = 0; i < [array count]; i++) {
		NSString *text = [array safeObjectAtIndex:i];
		height += ([self getLineHeight:text componentWidth:componentWidth]);
	}
	
	if (height > self.frame.size.height - 170) {
		height = self.frame.size.height - 170;
	}
	
	return height;
}


- (void)getFillInfo:(NSNotification *)noti {
	// 接收新加入的地址信息
	NSDictionary *dDictionary = (NSDictionary *)[noti object];
	NSString *str = [NSString stringWithFormat:@"%@ / %@", [dDictionary safeObjectForKey:KEY_NAME], [dDictionary safeObjectForKey:KEY_ADDRESS_CONTENT]];
	
	if (![addressArray containsObject:str]) {
		[addressArray addObject:str];
		titleLabel.hidden = NO;
		separator2.hidden = NO;
		
		addressViewHeight = [self getTableViewHeight:addressArray componentWidth:WORD_WIDTH_LIMIT];
		[self performSelector:@selector(refreshFrames)];
	}
	
	currentRow	= [addressArray indexOfObject:str];
	lastRow		= currentRow;
	[addressTable reloadData];
	[addressTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:currentRow inSection:0]
							  animated:NO scrollPosition:UITableViewScrollPositionTop];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ADDRESS_ADD_NOTIFICATION object:nil];
}


- (void)refreshFrames {
	// 刷新各个控件的frame
	backView.frame		= CGRectMake(0, 0, self.frame.size.width, addressViewHeight + 100);
	addressTable.frame	= CGRectMake(0, titleLabel.frame.origin.y + titleLabel.frame.size.height + 9, self.frame.size.width, addressViewHeight);
	separator2.frame	= CGRectMake(5, addressTable.frame.origin.y + addressTable.frame.size.height + 1, BOTTOM_BUTTON_WIDTH, 1);
	addButton.frame		= CGRectMake(5, 3 + addressTable.frame.origin.y + addressTable.frame.size.height, BOTTOM_BUTTON_WIDTH, BOTTOM_BUTTON_HEIGHT);
	commitButton.frame	= CGRectMake(5, addressViewHeight + 110, BOTTOM_BUTTON_WIDTH, 46);
	separator.frame		= CGRectMake(5, addButton.frame.origin.y + addButton.frame.size.height + 1, BOTTOM_BUTTON_WIDTH, 1);
}


#pragma mark -
#pragma mark UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (addressArray == nil || [addressArray count] == 0) {
		return 0;
	}
	
	return [addressArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [self getLineHeight:[addressArray safeObjectAtIndex:indexPath.row] componentWidth:WORD_WIDTH_LIMIT];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *SelectAddressKey = @"SelectAddressKey";
    SelectAddressCell *cell = (SelectAddressCell *)[tableView dequeueReusableCellWithIdentifier:SelectAddressKey];
	
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SelectAddressCell" owner:self options:nil];
        for (id oneObject in nib) {
            if ([oneObject isKindOfClass:[SelectAddressCell class]]) {
                cell = (SelectAddressCell *)oneObject;
			}
		}
    }
	
	//set cell
    NSUInteger row = [indexPath row];
	if (currentRow == row) {
		cell.isSelected = YES;
		cell.selectImgView.image = [UIImage imageNamed:@"btn_checkbox_checked.png"];
	}
	else {
		cell.isSelected = NO;
		cell.selectImgView.image = [UIImage imageNamed:@"btn_checkbox.png"];
	}
	
	cell.addressLabel.text	= [addressArray safeObjectAtIndex:row];
	cell.addressLabel.frame = CGRectMake(cell.addressLabel.frame.origin.x, cell.addressLabel.frame.origin.y,
										 WORD_WIDTH_LIMIT, [self getLineHeight:[addressArray safeObjectAtIndex:row] componentWidth:WORD_WIDTH_LIMIT]);
	cell.lineImgView.frame = CGRectMake(5, cell.addressLabel.frame.size.height + 4, BOTTOM_BUTTON_WIDTH, 1);
	cell.selectImgView.center = CGPointMake(cell.selectImgView.center.x, cell.addressLabel.center.y);
	if (indexPath.row == [addressArray count] - 1) {
		cell.lineImgView.hidden = YES;
	}
	else {
		cell.lineImgView.hidden = NO;
	}

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	SelectAddressCell *cell = (SelectAddressCell *)[tableView cellForRowAtIndexPath:indexPath];
	currentRow				= [indexPath row];
	
	if (cell.isSelected == NO) {
		cell.isSelected = YES;
		cell.selectImgView.image = [UIImage imageNamed:@"btn_checkbox_checked.png"];
		
		SelectAddressCell *cell = (SelectAddressCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:lastRow inSection:0]];
		cell.isSelected = NO;
		cell.selectImgView.image = [UIImage imageNamed:@"btn_checkbox.png"];
		
		lastRow = currentRow;
	}
}


@end
