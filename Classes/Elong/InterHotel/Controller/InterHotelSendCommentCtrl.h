//
//  InterHotelSendCommentCtrl.h
//  ElongClient
//
//  Created by nieyun on 14-6-5.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ElongBaseViewController.h"
#import "GradeView.h"
#import "LineCell.h"
#define DefaultCommentText @"  为了给其他用户提供更有价值的意见，请您发表20字以上的点评。"
#define INTER_TEXTVIEWHEIGHT 149
@interface InterHotelSendCommentCtrl : ElongBaseViewController<UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,HttpUtilDelegate,gradeDelegate,UITextFieldDelegate,UIAlertViewDelegate>

{
    UITableView  *commentTable;
    UITextView   *commentTextView;
    NSMutableDictionary  *contents;
    UILabel  *plahoderLabel;
    float  score;
    HttpUtil  *util;
    BOOL  keyBoardScroll;
}
@property (retain, nonatomic) IBOutlet UIView *nickView;
@property (retain, nonatomic) IBOutlet UITextField *nickField;

@property (retain, nonatomic) IBOutlet GradeView *scoreView;
- (void)commitComment;
@end
