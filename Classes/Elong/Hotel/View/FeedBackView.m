//
//  FeedBackView.m
//  ElongClient
//
//  Created by nieyun on 14-6-4.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "FeedBackView.h"
#import "FullHouseRequest.h"

@implementation FeedBackView
- (void)dealloc
{
    [placehoder release];
    [bgview  removeFromSuperview];
    [bgview release];
    [cancelBt removeFromSuperview];
    [cancelBt release];
    [self  removeFromSuperview];
    [commitStr  release];
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame OrderDic:(NSDictionary *)dic  addInView:(UIView *) view
{
    self = [super initWithFrame:frame];
    if (self) {
        self.hidden = YES;
        self.alpha = 0;
        self.delegate = self;
        self.contentSize = CGSizeMake(self.width, self.height + 1);
        commitStr = [[NSMutableString  alloc]init];
        defautLenth = 100;
        
        firstTop = frame.origin.y;
       
        bgview = [[UIView  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT )];
        bgview.hidden = YES;
        bgview.alpha = 0;
        bgview.backgroundColor = [UIColor  blackColor];
    
        UIWindow *window = ((ElongClientAppDelegate *)[UIApplication sharedApplication].delegate).window;
        
        [window addSubview:bgview];
        
        self.backgroundColor = RGBACOLOR(245, 245, 245, 1);
        // Initialization code
        _feedBackTextView = [[UITextView  alloc]initWithFrame:CGRectMake(10, 60, self.width - 20, self.height - 120)];
        _feedBackTextView.layer.borderWidth = 0.5;
        
        _feedBackTextView.layer.borderColor = [UIColor  lightGrayColor].CGColor;
        _feedBackTextView.backgroundColor = [UIColor  whiteColor];
        _feedBackTextView.delegate = self;
        [self  addSubview:_feedBackTextView];
        [_feedBackTextView release];
        
        UILabel  *label = [[UILabel  alloc]initWithFrame:CGRectMake((self.width-100)/2, 10, 100, [PublicMethods labelHeightWithString:@"反馈信息" Width:100 font:[UIFont  boldSystemFontOfSize:16]])];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"反馈信息";
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont  boldSystemFontOfSize:16];
        label.textColor = [UIColor  blackColor];
        [self addSubview:label];
        [label release];
        
        UIImageView *topSplitView = [[UIImageView alloc] initWithFrame:CGRectMake(0, label.bottom+10, self.width, SCREEN_SCALE)];
        topSplitView.image = [UIImage noCacheImageNamed:@"dashed.png"];
        [self addSubview:topSplitView];
        [topSplitView release];
        
        
        placehoder = [[UILabel  alloc]initWithFrame:CGRectMake(5, 3, 150, 20)];
        placehoder.backgroundColor = [UIColor  clearColor];
        placehoder.text = [NSString  stringWithFormat:@"最多输入%d字",defautLenth];
        placehoder.font = [UIFont systemFontOfSize:12];
        placehoder.enabled  = NO;
        [_feedBackTextView  addSubview:placehoder];

        
        UIButton  *commitBt = [UIButton  yellowWhitebuttonWithTitle:@"提交" Target:self Action:@selector(commitAction)  Frame:CGRectMake(_feedBackTextView.left + 20, _feedBackTextView.bottom + 15, _feedBackTextView.width - 40,self.height - 15-_feedBackTextView.bottom - 15) ];
        commitBt.tag = 315;
        commitBt.enabled = NO;
        commitBt.adjustsImageWhenDisabled = YES;
        [self  addSubview:commitBt];
  
        

        houseRequest = [[FullHouseRequest alloc]initWithOrder:dic];
        houseRequest.fullDelegate  = self;
        
        
        cancelBt = [[UIButton alloc]initWithFrame:CGRectMake(self.right-30,self.top - 30, 60, 60)];
        cancelBt.backgroundColor = [UIColor  clearColor];
        cancelBt.alpha = 0;
        cancelBt.hidden = YES;
        [cancelBt  setImage:[UIImage  noCacheImageNamed:@"closeRoundButton.png"] forState:UIControlStateNormal];
        [cancelBt  addTarget:self action:@selector(btcancelAction) forControlEvents:UIControlEventTouchUpInside];
        
       // [delegate.window insertSubview:cancelBt atIndex:0];
       
        [view.window addSubview:self];
        [view.window  addSubview:cancelBt];
       
    }
    return self;
}
- (void)textViewDidChange:(UITextView *)textView
{
    UIButton  *button = (UIButton *)[self  viewWithTag:315];
    button.enabled = [self  checkSpaceText:textView.text];
       
    if (textView.text.length > 0) {
         placehoder.text = @"";
    }else
    {
        placehoder.text = [NSString  stringWithFormat:@"最多输入%d字",defautLenth] ;
    }
    
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [textView  resignFirstResponder];
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [self  keyboardFrameChage:YES];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if (range.location >=  defautLenth)
    {
        textView.text = [textView.text  substringToIndex:defautLenth];
        return NO;
    }
    return YES;
}
- (void)btcancelAction
{
    [self  checkIsfForgive];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)awakeFromNib
{
    [super awakeFromNib];

    
}


- (void)show
{
    self.hidden  = NO;
    bgview.hidden = NO;
    cancelBt.hidden = NO;
    [UIView  animateWithDuration:0.35 animations:^{
        self.alpha = 1;
        bgview.alpha = 0.8;
        cancelBt.alpha = 1;
    }];
}

- (void)checkIsfForgive
{
    if (_feedBackTextView.text.length  > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您确定要放弃本次输入?"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"否"
                                              otherButtonTitles:@"是",nil];
        [alert show];
        [alert release];
    }else
    {
        [self dismiss];
    }
  
}
- (void)dismiss
{
    //[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
       self.hidden =YES;
    bgview.hidden = YES;
    cancelBt.hidden = YES;
    [UIView  animateWithDuration:0.35 animations:^{
        self.alpha = 0;
        self.alpha =0;
        cancelBt.alpha = 0;
    }];
    [_feedBackTextView  resignFirstResponder];
}
- (void)commitAction
{
//           NSString  *str = [NSMutableString  stringWithString:_feedBackTextView.text];
//        //过滤掉两边的空格
//        str = [str  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
   
    [commitStr   setString:_feedBackTextView.text];
    [self checkSpaceText:commitStr];
     [self checkMuchText:commitStr];
       // NSMutableString  *mutableStr =[NSMutableString  stringWithString:str];
    //[commitStr appendString:mutableStr];
        NSDateFormatter  *dateFormatter= [[NSDateFormatter  alloc]init];
        
        [dateFormatter  setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSString  *datestr= [dateFormatter  stringFromDate:[NSDate  date]];
        
        [commitStr  insertString:[NSString  stringWithFormat:@"客人说：%@",datestr] atIndex:0];
        
        
        [houseRequest  requestFeedBack:commitStr];
   
    
    [dateFormatter release];
  
}

- (BOOL)checkSpaceText:(NSString *)message
{
    message = [message  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    [commitStr  setString:message];
    if (message.length<= 0)
    {
      
        return NO;
    }
   
       return YES;
    
}

- (BOOL)checkMuchText:(NSString  *)message
{
    if (message.length  > defautLenth)
    {
        
        [Utils  alert:[NSString  stringWithFormat:@"您输入的字符超过%d个字",defautLenth]];
          return   NO;
    }
    return YES;
}

#pragma mark -feedbackRequestdelegate
- (void)finishFeedBack:(NSDictionary *)result
{
    
    [self dismiss];
    if ([self.feeddDelegate  respondsToSelector:@selector(finishiCommit:)]) {
        [self.feeddDelegate  finishiCommit:self];
    }
}


#pragma mark - keyboardnotification
- (void)keyboardFrameChage:(BOOL) isShow
{
    
    if (isShow) {
        [UIView  animateWithDuration:0.35 animations:^{
            self.bottom =SCREEN_HEIGHT - 236;
            cancelBt.top = self.top - 30;
        }];
    }else
    {
        [UIView  animateWithDuration:0.35 animations:^{
            self.top =firstTop;
            cancelBt.top = self.top - 30;
        }];
    }
    
}

#pragma mark -alertdelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self  dismiss];
    }
}
#pragma mark - scrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
     [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch  *touch = [touches  anyObject];
//    if ([touch.view  isKindOfClass:[FeedBackView  class]]) {
//        [_feedBackTextView  resignFirstResponder];
//    }
//    [self  keyboardFrameChage:NO];
//    
//}
@end
