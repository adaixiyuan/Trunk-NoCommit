//
//  GrouponListCell.m
//  ElongClient
//  团购订单列表cell
//
//  Created by haibo on 11-11-29.
//  Copyright 2011 elong. All rights reserved.
//

#import "GrouponListCell.h"


@implementation GrouponListCell

@synthesize hotelnameLabel;
@synthesize orderIDLabel;
@synthesize orderpriceLabel;
@synthesize bookNumLabel;
@synthesize orderTotalLabel;
@synthesize statesLabel;
@synthesize orderID;
@synthesize orderprice;	
@synthesize bookNum;	
@synthesize orderTotal;	
@synthesize payBtn;
@synthesize delegate;
@synthesize rightArrow;

- (void)dealloc {
	self.hotelnameLabel		= nil;
	self.orderIDLabel		= nil;
	self.orderpriceLabel	= nil;
	self.bookNumLabel		= nil;
	self.orderTotalLabel	= nil;
	self.statesLabel		= nil;
	self.rightArrow         = nil;
    self.orderID            = nil;
    self.orderprice         = nil;
    self.bookNum            = nil;
    self.orderTotal         = nil;
    self.payBtn             = nil;
    self.rightArrow         = nil;
	
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        
        UIView* b_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 130)];
		b_view.backgroundColor = [UIColor clearColor];
		UIButton* b_btn = [UIButton buttonWithType:UIButtonTypeCustom];
		b_btn.backgroundColor = [UIColor clearColor];
		b_btn.frame = CGRectMake(0, 0, 320, 130);
		[b_btn setBackgroundImage:COMMON_BUTTON_PRESSED_IMG forState:UIControlStateHighlighted];
		[b_view addSubview:b_btn];
		self.selectedBackgroundView = b_view;
		[b_view release];
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    for (UIView *subview in self.subviews) {
        for (UIView *subview2 in subview.subviews) {
            if ([NSStringFromClass([subview2 class]) isEqualToString:@"UITableViewCellDeleteConfirmationView"]) { // move delete confirmation view
                [subview bringSubviewToFront:subview2];
            }
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}

- (void)payByalipay
{
    
    if ([[ServiceConfig share] monkeySwitch])
    {
        // 开着monkey时不发生事件
        return;
    }
    
	if([delegate respondsToSelector:@selector(payOrderByalipay:)]){
		[delegate payOrderByalipay:self];
	}
}



@end
