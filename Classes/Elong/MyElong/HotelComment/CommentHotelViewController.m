    //
//  CommentHotelViewController.m
//  ElongClient
//
//  Created by 赵 海波 on 12-4-12.
//  Copyright 2012 elong. All rights reserved.
//

#import "CommentHotelViewController.h"
#import "CommentHotelRequest.h"
#import "AccountManager.h"
#import "ResizeLabel.h"
#import "Utils.h"
#import "ElongURL.h"
#import "CommentHotelListViewController.h"
#import "EmbedTextField.h"
#import "MyElongCenter.h"

#define kUpBtnTag		1025
#define kDownBtnTag		1026
#define TIP_STR			@"为了给其它用户提供更有价值的意见，请您发表10个字以上的点评"

@implementation CommentHotelViewController

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[dataDic release];
	[upIcon release];
	[downIcon release];
	[contentView release];
	
    [super dealloc];
}

#pragma mark -
#pragma mark Initialization

- (id)initWithDatas:(NSDictionary *)dic commentType:(CommentType)type{
    NSString *titleName = @"酒店点评";
    if(type==GROUPON){
        titleName = @"团购点评";
    }
	if (self = [super initWithTopImagePath:@"" andTitle:titleName style:_NavOnlyBackBtnStyle_]) {
		dataDic = [[NSDictionary alloc] initWithDictionary:dic];
		_currentCommentType = type;
        
		[self performSelector:@selector(makeUIElements)];
		
        UIBarButtonItem *rightBarItem = [UIBarButtonItem navBarRightButtonItemWithTitle:@"提交" Target:self Action:@selector(clickNavRightBtn)];
		self.navigationItem.rightBarButtonItem = rightBarItem;
        
	}
	
	return self;
}


#pragma mark -
#pragma Private Methods

- (void)closeKeyboard {
	[self.view endEditing:YES];
}


- (void)commitComment {
	NSString *msg = [self performSelector:@selector(checkInputContent)];
	
	if (msg) {
		[PublicMethods showAlertTitle:msg Message:nil];
	}
	else {
        if(_currentCommentType==HOTEL){
            CommentHotelRequest *req = [CommentHotelRequest shared];
            [req restoreComment];
            [req setHotelID:[dataDic safeObjectForKey:HOTELID_REQ]];
            [req setCommentContent:contentView.text];
            [req setRecommendType:upIcon.highlighted ? @"Good" : @"Bad"];
            [req setOrderNO:[dataDic safeObjectForKey:ORDERID_GROUPON]];
            [req setNickNmae:nickNameField.text];
            
            [Utils request:HOTELSEARCH req:[req getCommentHotelReq] delegate:self];
        }else{
            //团购提交
            long long cardNo = [[[AccountManager instanse] cardNo] longLongValue];
            NSMutableDictionary *jsonDictionary = [NSMutableDictionary dictionaryWithCapacity:1];
            [jsonDictionary safeSetObject:[NSNumber numberWithLongLong:cardNo] forKey:@"CardNo"];
            NSString *productId = [NSString stringWithFormat:@"%d",[[dataDic safeObjectForKey:@"ProductId"] intValue]];
            [jsonDictionary safeSetObject:productId forKey:@"ProductId"];
            NSString *productName = [dataDic safeObjectForKey:@"ProductName"];
            [jsonDictionary safeSetObject:productName forKey:@"Title"];
            int orderNo = [[dataDic safeObjectForKey:@"OrderNo"] intValue];
            [jsonDictionary safeSetObject:[NSNumber numberWithInt:orderNo] forKey:@"OrderNo"];
            NSString *memeberName = nickNameField.text;
            [jsonDictionary safeSetObject:memeberName forKey:@"MemberName"];
            [jsonDictionary safeSetObject:contentView.text forKey:@"Content"];
            int recommendType =upIcon.highlighted ? 1:-1;
            [jsonDictionary safeSetObject:[NSNumber numberWithInt:recommendType] forKey:@"RecommendType"];
            
            
            NSString *paramJson = [jsonDictionary JSONString];
            [HttpUtil requestURL:[PublicMethods composeNetSearchUrl:@"myelong" forService:@"publishGrouponHotelComment"] postContent:paramJson delegate:self];

        }

	}
}


- (void)clickNavRightBtn {
	[self closeKeyboard];
	[self commitComment];
}


- (void)makeUIElements {
	// ======================= bg =======================
	bgView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT)];
    bgView.backgroundColor = [UIColor clearColor];
	[self.view addSubview:bgView];
	[bgView release];
	
	offY = 20.0f;
	
	UIButton *resignBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[resignBtn addTarget:self action:@selector(closeKeyboard) forControlEvents:UIControlEventTouchUpInside];
	resignBtn.frame = CGRectMake(0, 0, bgView.frame.size.width, bgView.frame.size.height);
	[bgView addSubview:resignBtn];
	
	// ======================= hotel name =======================
	UILabel *hotelTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, offY + 2, 68, 16)];
	hotelTitleLabel.text = @"酒店名：";
    if(_currentCommentType==GROUPON){
        hotelTitleLabel.text = @"团    购：";
    }
	hotelTitleLabel.font = FONT_15;
	hotelTitleLabel.textColor = [UIColor blackColor];
	hotelTitleLabel.backgroundColor = [UIColor clearColor];
	[bgView addSubview:hotelTitleLabel];
	[hotelTitleLabel release];
	
	ResizeLabel *hotelNameLabel = [[ResizeLabel alloc] init];
	hotelNameLabel.backgroundColor = [UIColor clearColor];
	hotelNameLabel.numberOfLines = 0;
	[hotelNameLabel resizeByFrame:CGRectMake(75, offY, 222, 100)];
	[hotelNameLabel resizeByFont:FONT_B16];
    if(_currentCommentType==HOTEL){
        [hotelNameLabel resizeByText:[dataDic safeObjectForKey:HOTELNAME_GROUPON]];
    }else{
        [hotelNameLabel resizeByText:[dataDic safeObjectForKey:@"ProductName"]];
    }
	[bgView addSubview:hotelNameLabel];
	[hotelNameLabel release];
	
	offY = hotelNameLabel.frame.origin.y + hotelNameLabel.frame.size.height + 10;
    
    //add BG
    UIView *nickBg = [[UIView alloc] initWithFrame:CGRectMake(0, offY, 320, 88)];
    nickBg.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:nickBg];
    [nickBg release];
    [nickBg addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0, 0, 320, SCREEN_SCALE)]];
	
    nickNameField = [[EmbedTextField alloc] initWithFrame:CGRectMake(12, 0, 290, 44) Title:@"昵    称：" TitleFont:FONT_15];
	nickNameField.returnKeyType = UIReturnKeyDone;
	nickNameField.placeholder	= @"选填";
    nickNameField.textFont = FONT_15;
	nickNameField.delegate		= self;
	[nickBg addSubview:nickNameField];
	[nickNameField release];
	
	[nickBg addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0, 44 - SCREEN_SCALE, 320, SCREEN_SCALE)]];
	
	// ======================= choose object =======================
	ButtonView *upButton = [[ButtonView alloc] initWithFrame:CGRectMake(8, 44, 132, 44)];
	upButton.delegate = self;
	upButton.tag = kUpBtnTag;
	[nickBg addSubview:upButton];
	[upButton release];
	
	upIcon = [[UIImageView alloc] initWithImage:[UIImage noCacheImageNamed:@"btn_checkbox.png"]
							   highlightedImage:[UIImage noCacheImageNamed:@"btn_checkbox_checked.png"]];
	upIcon.frame = CGRectMake(7, 12, 19, 19);
	upIcon.highlighted = YES;			// 默认选择好评
	[upButton addSubview:upIcon];
	
	UIImageView *upSignView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 12, 19, 19)];
	upSignView.image = [UIImage noCacheImageNamed:@"ico_good.png"];
	[upButton addSubview:upSignView];
	[upSignView release];
	
	UILabel *upTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(69, 12, 55, 19)];
	upTextLabel.text = @"推荐";
	upTextLabel.font = FONT_15;
	upTextLabel.textColor = [UIColor blackColor];
	upTextLabel.backgroundColor = [UIColor clearColor];
	[upButton addSubview:upTextLabel];
	[upTextLabel release];
	
	// =======================================================================
	
	ButtonView *downButton = [[ButtonView alloc] initWithFrame:CGRectMake(172, 44, 132, 44)];
	downButton.delegate = self;
	downButton.tag = kDownBtnTag;
	[nickBg addSubview:downButton];
	[downButton release];
	
	downIcon = [[UIImageView alloc] initWithImage:[UIImage noCacheImageNamed:@"btn_checkbox.png"]
							   highlightedImage:[UIImage noCacheImageNamed:@"btn_checkbox_checked.png"]];
	downIcon.frame = CGRectMake(7, 12, 19, 19);
	[downButton addSubview:downIcon];
	
	UIImageView *downSignView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 12, 19, 19)];
	downSignView.image = [UIImage noCacheImageNamed:@"ico_bad.png"];
	[downButton addSubview:downSignView];
	[downSignView release];
	
	UILabel *downTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(69, 12, 55, 19)];
	downTextLabel.text = @"不推荐";
	downTextLabel.font = FONT_15;
	downTextLabel.textColor = [UIColor blackColor];
	downTextLabel.backgroundColor = [UIColor clearColor];
	[downButton addSubview:downTextLabel];
	[downTextLabel release];
	
    
    offY  += 88;
	[bgView addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0, offY - SCREEN_SCALE, 320, SCREEN_SCALE)]];
	offY += 20;
    
//	offY += 50;
//	// ======================= UITextView =======================
//	UIImageView *roundCornerBg = [[UIImageView alloc] initWithFrame:CGRectMake(15, offY, BOTTOM_BUTTON_WIDTH, 168)];
//	roundCornerBg.image = [UIImage stretchableImageWithPath:@"textview_bg.png"];
//	[bgView addSubview:roundCornerBg];
//	[roundCornerBg release];
	
	contentView = [[UITextView alloc] initWithFrame:CGRectMake(0, offY, 320, 160)];
	contentView.text		= TIP_STR;
    contentView.returnKeyType = UIReturnKeyDone;
	contentView.textColor	= [UIColor grayColor];
	contentView.font		= [UIFont systemFontOfSize:14];
	contentView.delegate	= self;
	[contentView setBackgroundColor:[UIColor whiteColor]];
    [bgView addSubview:contentView];

    [bgView addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0, offY, 320, SCREEN_SCALE)]];
    [bgView addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0, offY + 160 - SCREEN_SCALE, 320, SCREEN_SCALE)]];
    
}


- (NSString *)checkInputContent {
	if ([contentView.text length] == 0 || [contentView.text isEqualToString:TIP_STR]) {
		return @"请您输入点评内容后再提交";
	}
	else if (contentView.text.length > 2000) {
		return @"点评内容需要在2000字以内，请您稍做修改后再提交";
	}
	
	return nil;
}


- (void)editBeginAction {
	if (bgView.frame.size.height > 200) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDuration:0.3f];
		
		bgView.frame = CGRectMake(0, 0, bgView.frame.size.width, MAINCONTENTHEIGHT - 210);
		bgView.contentSize = CGSizeMake(bgView.frame.size.width, offY + 240);
		
		[UIView commitAnimations];
	}
}


- (void)editEndAction {
	if (bgView.frame.size.height == MAINCONTENTHEIGHT - 210) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDuration:0.3f];
		
		bgView.frame = CGRectMake(0, 0, bgView.frame.size.width, MAINCONTENTHEIGHT);
		bgView.contentSize = CGSizeMake(bgView.frame.size.width, offY + 180);
		
		[UIView commitAnimations];
	}
}


#pragma mark -
#pragma mark ButtonView Delegate

- (void)ButtonViewIsPressed:(ButtonView *)button {
	[super ButtonViewIsPressed:button];
	
	switch (button.tag) {
		case kUpBtnTag:
			upIcon.highlighted		= YES;
			downIcon.highlighted	= NO;
			break;
		case kDownBtnTag:
			upIcon.highlighted		= NO;
			downIcon.highlighted	= YES;
			break;

		default:
			break;
	}
}


#pragma mark -
#pragma mark UITextField & UITextView Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	[self editBeginAction];
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
	[self editEndAction];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    if ([textField isKindOfClass:[CustomTextField class]]) {
        [textField performSelector:@selector(resetTargetKeyboard)];
    }
    return YES;
}


- (void)textViewDidBeginEditing:(UITextView *)textView {
	[self editBeginAction];
	[bgView scrollRectToVisible:CGRectMake(0, offY+8, bgView.frame.size.width, 190) animated:NO];
	
	NSString *str = textView.text;
	
	if ([str isEqualToString:TIP_STR]) {
		textView.text = @"";
		textView.textColor = [UIColor blackColor];
	}
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
	[self editEndAction];
	
	if ([textView.text isEqualToString:@""]) {
		textView.text = TIP_STR;
		textView.textColor = [UIColor grayColor];
	}
}


#pragma mark -
#pragma mark Net Delegate

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData {
	NSDictionary *root = [PublicMethods unCompressData:responseData];
    
	if ([Utils checkJsonIsError:root]) {
		return;
	}
	
	UIAlertView *tipView = [[UIAlertView alloc] initWithTitle:@"提交成功！" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
	[tipView show];
	[tipView release];
    
    //此处是当从酒店订单列表进入点评是，点评完成后需要刷新列表
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshOrderList" object:self];   //通知订单列表页刷新订单列表
}


#pragma mark -
#pragma mark UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	[[CommentHotelRequest shared] clearCommentReqData];
    
    CommentHotelListViewController* CHLVC = nil;
    for (UIViewController* vc in self.navigationController.viewControllers)
    {
        if ([vc isKindOfClass: [CommentHotelListViewController class]])
        {
            CHLVC = [(CommentHotelListViewController*)vc retain];
        }
    }
    
    if (CHLVC) {
        int _result = [CHLVC deleterowofdatasource];
        if (_result) {//如果上一个页面tableview还有内容的话 返回上一个页面
            [CHLVC reloadtableview];
            [self back];
        }
        else//如果上一个页面tableview没有内容的话 返回myelong
        {
            for (MyElongCenter* vc in self.navigationController.viewControllers)
            {
                if ([vc isKindOfClass: [MyElongCenter class]])
                {
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
        }
    }

//	[self back];
}

@end
