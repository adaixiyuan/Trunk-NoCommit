//
//  FlightSeatClass.m
//  ElongClient
//
//  Created by elong lide on 12-1-9.
//  Copyright 2012 elong. All rights reserved.
//

#import "FlightSeatClass.h"


@implementation FlightSeatClass
@synthesize isSelected;
@synthesize iconImgView;
@synthesize selectImgView;
@synthesize eachpriceLabel;
@synthesize dicountLabel;
@synthesize seatPriceLabel,oilTaxLabel,airTaxLabel,detail,changeDetailLabel,returnDetailLabel,changeTitleLabel,rightarrow,seattypeNameLabel,moredetailbtn;
@synthesize upperHalfLabel;
@synthesize lowerHalfLabel;
@synthesize tReturnDetailLabel;
@synthesize tChangeDetailLabel;
@synthesize tChangeTitleLabel;
@synthesize tRightarrow;
@synthesize tMoredetailbtn;
@synthesize transView;
@synthesize couponLabel;
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}

//预订事件处理
-(void)BookingFlight:(UIButton*)sender{
    //交给detail的类处理
//    if ([detail respondsToSelector:@selector(orderButtonPressed)]) {
//		[detail orderButtonPressed];
//	}
}


- (void)setTransitModel:(BOOL)animated {
    if (animated) {
        // 中转模式布局
        // 上半部分
        upperHalfLabel.hidden = NO;
        int offY = upperHalfLabel.frame.origin.y + upperHalfLabel.frame.size.height + 3;
        int maxHeight = (self.view.frame.size.height - upperHalfLabel.frame.origin.y - 20) / 2;
        
        returnTitleLabel.frame = CGRectMake(returnTitleLabel.frame.origin.x, offY, returnTitleLabel.frame.size.width, returnTitleLabel.frame.size.height);
        returnDetailLabel.frame = CGRectMake(returnDetailLabel.frame.origin.x, offY, 190, [self getLineHeight:returnDetailLabel.text componentWidth:190 componentHeight:maxHeight - 30]);
        offY += returnDetailLabel.frame.size.height;
        
        //设置退票label尺寸
        int reheight = returnDetailLabel.frame.size.height;
        if (reheight >= maxHeight - 40) {
            rightarrow.hidden = NO;
            rightarrow.frame = CGRectMake(rightarrow.frame.origin.x, offY + 2, rightarrow.frame.size.width, rightarrow.frame.size.height);
            
            moredetailbtn.hidden = NO;
            moredetailbtn.frame = CGRectMake(moredetailbtn.frame.origin.x, offY - 3, moredetailbtn.frame.size.width, moredetailbtn.frame.size.height);
            
            changeDetailLabel.hidden = YES;
            changeTitleLabel.hidden = YES;
        }
        else {
            //设置改签尺寸
            changeTitleLabel.frame = CGRectMake(changeTitleLabel.frame.origin.x, offY, changeTitleLabel.frame.size.width, changeTitleLabel.frame.size.height);
            
            changeDetailLabel.frame = CGRectMake(changeDetailLabel.frame.origin.x, offY, 190, [self getLineHeight:changeDetailLabel.text componentWidth:190 componentHeight:maxHeight - 30 -returnDetailLabel.frame.size.height]);
            offY += changeDetailLabel.frame.size.height;
            
            int he = changeDetailLabel.frame.size.height;
            
            if (he >= maxHeight - 70) {
                rightarrow.hidden = NO;
                rightarrow.frame = CGRectMake(rightarrow.frame.origin.x, offY + 2, rightarrow.frame.size.width, rightarrow.frame.size.height);
                moredetailbtn.hidden = NO;
                moredetailbtn.frame = CGRectMake(moredetailbtn.frame.origin.x, offY - 3, moredetailbtn.frame.size.width, moredetailbtn.frame.size.height);
            }
        }
        
        // 页面下半部分
        transView.hidden = NO;
        transView.frame = CGRectMake(transView.frame.origin.x, self.view.frame.size.height - 15 - maxHeight, transView.frame.size.width, maxHeight);
        offY = lowerHalfLabel.frame.origin.y + lowerHalfLabel.frame.size.height + 3;
        
        tReturnDetailLabel.frame = CGRectMake(tReturnDetailLabel.frame.origin.x, tReturnDetailLabel.frame.origin.y, 190, [self getLineHeight:tReturnDetailLabel.text componentWidth:190 componentHeight:maxHeight - 30]);
        offY += tReturnDetailLabel.frame.size.height;
        
        //设置退票label尺寸
        reheight = tReturnDetailLabel.frame.origin.y + tReturnDetailLabel.frame.size.height;
        if (reheight >= maxHeight - 40) {
            tRightarrow.hidden = NO;
            tRightarrow.frame = CGRectMake(tRightarrow.frame.origin.x, offY + 2, tRightarrow.frame.size.width, tRightarrow.frame.size.height);
            
            tMoredetailbtn.hidden = NO;
            tMoredetailbtn.frame = CGRectMake(tMoredetailbtn.frame.origin.x, offY - 3, tMoredetailbtn.frame.size.width, tMoredetailbtn.frame.size.height);
            
            tChangeDetailLabel.hidden = YES;
            tChangeTitleLabel.hidden = YES;
        }
        else {
            //设置改签尺寸
            tChangeTitleLabel.frame = CGRectMake(tChangeTitleLabel.frame.origin.x, offY, tChangeTitleLabel.frame.size.width, tChangeTitleLabel.frame.size.height);
            
            tChangeDetailLabel.frame = CGRectMake(tChangeDetailLabel.frame.origin.x, offY, 190, [self getLineHeight:tChangeDetailLabel.text componentWidth:190 componentHeight:maxHeight - 30 -tReturnDetailLabel.frame.size.height]);
            offY += tChangeDetailLabel.frame.size.height;
            
            int he = tChangeDetailLabel.frame.size.height;
            
            if (he >= maxHeight - 70) {
                tRightarrow.hidden = NO;
                tRightarrow.frame = CGRectMake(tRightarrow.frame.origin.x, offY + 2, tRightarrow.frame.size.width, tRightarrow.frame.size.height);
                tMoredetailbtn.hidden = NO;
                tMoredetailbtn.frame = CGRectMake(tMoredetailbtn.frame.origin.x, offY - 3, tMoredetailbtn.frame.size.width, tMoredetailbtn.frame.size.height);
            }
        }
    }
    else {
        // 非中转模式布局
        self.returnDetailLabel.frame = CGRectMake(self.returnDetailLabel.frame.origin.x, self.returnDetailLabel.frame.origin.y, 190, [self getLineHeight:self.returnDetailLabel.text componentWidth:190 componentHeight:self.view.frame.size.height / 2 - 10]);
        
        self.changeTitleLabel.frame = CGRectMake(self.changeTitleLabel.frame.origin.x, self.returnDetailLabel.frame.origin.y + self.returnDetailLabel.frame.size.height + 8,
                                                 self.changeTitleLabel.frame.size.width, self.changeTitleLabel.frame.size.height);
        self.rightarrow.hidden = YES;
        self.changeDetailLabel.frame = CGRectMake(self.changeDetailLabel.frame.origin.x, self.returnDetailLabel.frame.origin.y + self.returnDetailLabel.frame.size.height + 8,
                                                  190, [self getLineHeight:self.changeDetailLabel.text componentWidth:190 componentHeight:self.view.frame.size.height / 2 - 10]);
        self.moredetailbtn.hidden = YES;
        
        int maxHeight = SCREEN_4_INCH ? 345 : 255;
        //设置退票label尺寸
        int reheight = self.returnDetailLabel.frame.origin.y + self.returnDetailLabel.frame.size.height;
        if (reheight >= maxHeight) {
            self.rightarrow.hidden = NO;
            self.moredetailbtn.hidden = NO;
            
            self.changeDetailLabel.hidden = YES;
            self.changeTitleLabel.hidden = YES;
        }
        else {
            //设置改签尺寸
            
            int he = self.changeDetailLabel.frame.origin.y + self.changeDetailLabel.frame.size.height;
            
            if (he > maxHeight) {
                self.moredetailbtn.hidden = NO;
                self.changeDetailLabel.frame = CGRectMake(self.changeDetailLabel.frame.origin.x,
                                                          self.changeDetailLabel.frame.origin.y,
                                                          self.changeDetailLabel.frame.size.width,
                                                          maxHeight - self.changeDetailLabel.frame.origin.y);
                
                self.rightarrow.hidden = NO;
            }
        }
        
        // 根据屏幕尺寸，重设按钮位置
        CGRect tempRect = self.moredetailbtn.frame;
        tempRect.origin.y = self.view.frame.size.height - tempRect.size.height - 5;
        self.moredetailbtn.frame = tempRect;
        
        tempRect = self.rightarrow.frame;
        tempRect.origin.y = self.view.frame.size.height - tempRect.size.height - 15;
        self.rightarrow.frame = tempRect;
        // ========================================
    }
}


- (int)getLineHeight:(NSString *)string componentWidth:(CGFloat)componentWidth componentHeight:(CGFloat)componentHeight
{
	int height = 0;
	//componentWidth -= 10;
	UIFont *font = FONT_12;
	CGSize size = [string sizeWithFont:font constrainedToSize:CGSizeMake(componentWidth, componentHeight)];
	
	height = size.height;
	if (height < 15)
    {
		height = 15;
	}
	
	return height;
}


- (void)setDiscountModel:(BOOL)isDiscount WithOriginPrice:(NSString *)originPrice
{
    if (isDiscount)
    {
        // 立减显示布局
        seattypeNameLabel.frame = CGRectMake(24, 17, 123, 43);
        orderButton.frame = CGRectMake(175, 24, 90, 30);
        
        if (STRINGHASVALUE(originPrice))
        {
            // 有划价时不展示coupon
            _discountIcon.hidden = NO;
            _originPriceLabel.hidden = NO;
            _originPriceLabel.text = [NSString stringWithFormat:@"¥  %@", originPrice];
            _priceLine.hidden = NO;
            CGRect rect = _priceLine.frame;
            rect.size.width = _originPriceLabel.text.length * 7 + 5;
            _priceLine.frame = rect;
            
            // 只隐藏coupon，不管恢复
            couponLabel.hidden = YES;
            _couponIcon.hidden = YES;
        }
    }
    else
    {
        // 非立减显示布局
        seattypeNameLabel.frame = CGRectMake(24, 11, 123, 43);
        orderButton.frame = CGRectMake(175, 18, 90, 30);
        
        _discountIcon.hidden = YES;
        _priceLine.hidden = YES;
        _originPriceLabel.hidden = YES;
    }
}


-(void)viewDidLoad{
	[super viewDidLoad];
	//背景图片
	bgImgView.image = [UIImage stretchableImageWithPath:@"round_shadow_bg.png"];
	
    //预订按钮
    orderButton = [UIButton uniformBottomButtonWithTitle:@"预订" 
                                               ImagePath:@"ico_flightdetailbook.png" 
                                                  Target:self 
                                                  Action:@selector(BookingFlight:)
                                                   Frame:CGRectMake(175, 18, 90, 30)];
    [self.view addSubview:orderButton];
    
}


- (void)dealloc
{
    [bgImgView release];
	[iconImgView release];
	[selectImgView release];
	[eachpriceLabel release];
	[dicountLabel release];
    [returnTitleLabel release];
    
    self.seattypeNameLabel = nil;
    self.seatPriceLabel = nil;
    self.airTaxLabel = nil;
    self.oilTaxLabel = nil;
    self.detail = nil;
    self.returnDetailLabel = nil;
    self.changeDetailLabel = nil;
    self.changeTitleLabel = nil;
    self.rightarrow = nil;
    self.couponLabel = nil;
    self.moredetailbtn = nil;
    self.upperHalfLabel = nil;
    self.lowerHalfLabel = nil;
    self.tReturnDetailLabel = nil;
    self.tChangeDetailLabel = nil;
    self.tChangeTitleLabel = nil;
    self.tRightarrow = nil;
    self.tMoredetailbtn = nil;
    self.transView = nil;
    
    [super dealloc];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

@end
