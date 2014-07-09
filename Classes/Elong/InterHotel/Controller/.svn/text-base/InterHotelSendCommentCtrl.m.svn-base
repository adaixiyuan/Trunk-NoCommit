//
//  InterHotelSendCommentCtrl.m
//  ElongClient
//
//  Created by nieyun on 14-6-5.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "InterHotelSendCommentCtrl.h"
#import "AccountManager.h"
#import "InterHotelDetailCtrl.h"
#import "ElongURL.h"

@interface InterHotelSendCommentCtrl ()

@end

@implementation InterHotelSendCommentCtrl
- (void)dealloc
{
    [commentTable release];
    [commentTextView release];
    [contents release];
    [plahoderLabel release];
    [_nickView release];
    [_scoreView release];
    [_nickField release];
    if (util) {
        [util cancel];
        SFRelease(util);
    }
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = RGBACOLOR(248, 248, 248, 1);
    score = 5.0;
    
    contents = [[NSMutableDictionary  alloc]init];
    
   
    
    commentTable = [[UITableView  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT) style:UITableViewStylePlain];
    commentTable.backgroundColor = [UIColor clearColor];
    commentTable.backgroundView.backgroundColor = [UIColor clearColor];
    commentTable.delegate = self;
    commentTable.dataSource = self;
    commentTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    //commentTable.alwaysBounceHorizontal = NO;
    [self.view  addSubview:commentTable];
    
    plahoderLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    plahoderLabel.numberOfLines = 0;
    plahoderLabel.textColor = RGBACOLOR(175, 175, 175, 1);
    plahoderLabel.enabled  = NO;
    plahoderLabel.backgroundColor = [UIColor clearColor];
    plahoderLabel.font = [UIFont systemFontOfSize:15];
    plahoderLabel.text = DefaultCommentText;
    
    self.nickField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [self  makeCommitButton];
    
    [self  makeBackButton];
    // Do any additional setup after loading the view from its nib.
}

- (void)makeBackButton
{
    self.navigationItem.leftBarButtonItem = nil;
    UIButton *backbtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 48, 34)];
    [backbtn  setImage: [UIImage imageNamed:@"btn_navback_normal.png"] forState:UIControlStateNormal] ;
    [backbtn  addTarget:self action:@selector(upperPage) forControlEvents:UIControlEventTouchUpInside];
     UIBarButtonItem *backbarbuttonitem = [[UIBarButtonItem alloc] initWithCustomView:backbtn];
    
    self.navigationItem.leftBarButtonItem = backbarbuttonitem;
    [backbtn release];
    [backbarbuttonitem release];
}
- (void)addLineInView:(UIView *)  inView frame:(CGRect)frame
{
    UIImageView *topSplitView = [[UIImageView alloc] initWithFrame:frame];
    topSplitView.image = [UIImage noCacheImageNamed:@"dashed.png"];
    [inView addSubview:topSplitView];
    [topSplitView release];

}

- (void)makeCommitButton
{
    UIView  *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 250)];
    
    UIButton  *commitBt = [UIButton yellowWhitebuttonWithTitle:@"提交" Target:self Action:@selector(commitComment) Frame:CGRectMake(22, 44, SCREEN_WIDTH - 44, 39)];
    commitBt.tag = 600;
    commitBt.enabled = NO;
    commitBt.adjustsImageWhenDisabled = YES;
    [footView  addSubview:commitBt];
    //[self.view addSubview:commitBt];
    commentTable.tableFooterView = footView;
    [footView  release];
 
}
#pragma mark - tableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return INTER_TEXTVIEWHEIGHT;
    }
    return 88;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString  *str= @"cell";
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell)
    {
        cell = [[[LineCell  alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str]autorelease];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle  = UITableViewCellSelectionStyleNone;
        if (indexPath.section == 1) {
            commentTextView= [[UITextView  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, INTER_TEXTVIEWHEIGHT)];
            commentTextView.backgroundColor = [UIColor clearColor];
            commentTextView.textColor = [UIColor blackColor];
            commentTextView.font = [UIFont systemFontOfSize:15];
            commentTextView.delegate = self;
            [commentTextView  addSubview:plahoderLabel];
            [cell.contentView addSubview:commentTextView];
        }else
        {
            _nickView .frame = CGRectMake(0, 0, SCREEN_WIDTH, 88);
            [cell.contentView addSubview:_nickView];
            [self  addLineInView:_nickView frame:CGRectMake(0, _nickView.height/2.0-SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)];
            
            [_scoreView  setDefaultScore:5 lightImage:@"interhotelLIghtComment.png" grayImage:@"interhotelGrayComment.png" count:5];
            
            _scoreView.delegate = self;
            NSString  *cardNo = [[AccountManager  instanse]cardNo] ;
            _nickField.text = [cardNo stringByReplaceWithAsteriskFromIndex:cardNo.length - 4];
            _nickField.delegate = self;
           
            
        }
        
    }
    
        return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 52;
    }
    return 33;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    UIView  *headView = [[UIView  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    headView.backgroundColor =RGBACOLOR(248, 248, 248, 1);
    if (section == 0)
    {
        headView.height = 52;
        UILabel  *frontLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, headView.height)];
        frontLabel.text =@" 酒店名:";
        frontLabel.backgroundColor = [UIColor clearColor];
        frontLabel.textColor = RGBACOLOR(52, 52, 52, 1);
        frontLabel.font = [UIFont  systemFontOfSize:14];
        [headView  addSubview:frontLabel];
        [frontLabel release];
        
        UILabel  *label = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, SCREEN_WIDTH-frontLabel.width, headView.height)];
        label.font = [UIFont  systemFontOfSize:14];
        label.backgroundColor = [UIColor  clearColor];
        label.textColor = RGBACOLOR(52, 52, 52, 1);
        NSDictionary *baseInfo = [[InterHotelDetailCtrl detail] safeObjectForKey:@"BasedInfo"];
        NSString *tmpHotelName = [baseInfo safeObjectForKey:@"HotelName"];
        label.numberOfLines = 0;
        label.adjustsFontSizeToFitWidth = YES;
        label.text = [NSString  stringWithFormat:@"%@",tmpHotelName];
        [headView  addSubview:label];
        [label  release];
    }else
    {
        headView.height = 33;
    }
    return [headView autorelease];
}
- (void)commitComment
{
    [contents  removeAllObjects];
    
    
    NSString *cStr = commentTextView.text;
    NSString  *tittle = nil;
    NSArray  *tittleaAr = [cStr  componentsSeparatedByCharactersInSet:[NSCharacterSet  characterSetWithCharactersInString:@",。.\n " ]];
    for (int i = 0; i < tittleaAr.count; i ++) {
        if ([[tittleaAr safeObjectAtIndex:i]length]> 0) {
            tittle = [tittleaAr safeObjectAtIndex:i] ;
            if (tittle.length > 15) {
                tittle = [tittle  substringToIndex:15];
            }
            break;
        }
    }
     //正则中截取字符串含有所有标点符号的
//    //  NSString *charReg = @".*?([^A-Z^a-z^0-9^\u4e00-\u9fa5])";
//    NSArray *charArray = [cStr componentsMatchedByRegex:charReg];
//    if ([charArray count] > 0){
//        NSLog(@"%@",charArray);
//    }

    //contents = commentTextView.text;。
    
    [contents  safeSetObject:[[AccountManager  instanse] cardNo] forKey:@"CardNo"];
    NSLog(@"%@",[[InterHotelDetailCtrl  detail] objectForKey:@"HotelId"]);
    
     NSDictionary *baseInfo = [[InterHotelDetailCtrl detail] safeObjectForKey:@"BasedInfo"];
    [contents  safeSetObject:  [baseInfo objectForKey:@"HotelId"] forKey:@"HotelId"];
    [contents  safeSetObject:[NSNumber  numberWithFloat:score] forKey:@"Score"];
    [contents safeSetObject:tittle forKey:@"Title"];
    [contents  safeSetObject:commentTextView.text forKey:@"Content"];
    [contents safeSetObject:[NSNumber numberWithInt:0] forKey:@"TripPurpose"];
    [contents safeSetObject:_nickField.text forKey:@"Author"];
    if (util) {
        [util cancel];
        SFRelease(util);
    }
    util = [[HttpUtil alloc]init];
    NSString  *str = [contents JSONString];
    NSString  *url1 = [PublicMethods  composeNetSearchUrl:@"globalHotel" forService:@"addIHotelComment" ];
    [util  requestWithURLString:url1 Content:str Delegate:self];
  //  [util connectWithURLString:INTER_SEARCH Content:[self  requesString:YES] Delegate:self];
   
}


- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSData *)responseData
{
   
    NSDictionary *root = [PublicMethods  unCompressData:responseData];
  
    if ([Utils  checkJsonIsError:root])
    {
        return;
    }
    if ([root  objectForKey:@"IsSuccess"] )
    {
        [Utils  alert:@"点评已提交！"];
        commentTextView.text = @"";
        plahoderLabel.text = DefaultCommentText;
        UIButton  *commitBt =(UIButton  *) [commentTable.tableFooterView  viewWithTag:600];
        commitBt.enabled = NO;
        [commentTable  reloadData];
        
    }
  
    
}
#pragma mark - textViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    keyBoardScroll = YES;
    [commentTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    UIButton  *commitBt =(UIButton  *) [commentTable.tableFooterView  viewWithTag:600];
    commitBt.enabled = [self  checkSpaceText:textView.text];
    if (textView.text.length > 0)
    {
        plahoderLabel.text = @"";
    }else
        plahoderLabel.text = DefaultCommentText;

}
#pragma mark - gradexViewDelegate
- (void)didSelectedButton:(int)flag
{
    score = (float)flag + 1.0;
}

#pragma mark -scrollviewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == commentTable)
    {
        CGFloat sectionHeaderHeight;
        
        sectionHeaderHeight = [self tableView:commentTable heightForHeaderInSection:0];
        
        
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0){
            
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y,0, 0, 0);
        }
        else if ( scrollView.contentOffset.y>=sectionHeaderHeight)
        {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }

}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
   
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (IOSVersion_6) {
        [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    }else
   {
        if ([_nickField isFirstResponder]) {
            [_nickField  resignFirstResponder];
        }
        if ([commentTextView  isFirstResponder]) {
            [commentTextView  resignFirstResponder];
        }
    }
    
    
    
}


- (void)checkIsfForgive
{
    if (commentTextView.text.length  > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您确定要放弃本次输入?"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"否"
                                              otherButtonTitles:@"是",nil];
        [alert show];
        [alert release];
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.navigationController  popViewControllerAnimated:YES];
    }
}

- (void)upperPage
{
    [self  checkIsfForgive];
}


- (BOOL)checkSpaceText:(NSString *)message
{
    message = [message  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (message.length<= 0)
    {
        
        return NO;
    }
    
    return YES;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {

    [self setNickView:nil];
    [self setScoreView:nil];
    [self setNickField:nil];
    [super viewDidUnload];
}
@end
