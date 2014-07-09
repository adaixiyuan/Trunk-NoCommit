//
//  TrainOrderStudentTicketRuleVC.m
//  ElongClient
//
//  Created by cglw on 14-6-9.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "TrainOrderStudentTicketRuleVC.h"

static NSString *studentTicketRule = @"1、  学生票说明：\n（1）     C/D/G：只能购买二等座；Z/T/K/其他:  只能购买硬座、硬卧；\n（2）     学生票由于12306各车次折扣价不同，票价需依据12306最终出票后为准；\n（3）     购票后、开车前，须办理换票手续方可进站乘车。换票时，请携带乘车人学生证和身份证原件或其他相关证明。\n（4）     同一订单里学生证优惠区间信息必须保持一致。非同一优惠区间、成人票与学生票，都请分开下单；\n2、  购买学生票应同时符合以下条件：\n（1）     学生票乘车时间限为每年的暑假6月1日至9月30日、寒假12月1日至3月31日。\n（2）     在国家教育主管部门批准有学历教育资格的普通大、专院校（含民办大学、军事院校），中等专业学校、技工学校和中、小学就读，没有工资收入的学生、研究生。\n（3）     家庭居住地（父亲或母亲之中任何一方居住地）和学校所在地不在同一城市。\n（4）     大中专学生凭附有加盖院校公章的减价优待凭证、火车票电子优惠卡和经学校注册的学生证，新生凭学校录取通知书，毕业生凭学校书面证明；小学生凭学校书面证明。\n（5）     在优惠乘车区间之内，且优惠乘车区间限于家庭至院校（实习地点）之间。\n（6）     每年乘车次数限于四次单程。当年未使用的次数，不能留至下年使用。\n\n下列情况不能发售学生票：\n（1）学校所在地有学生父或母其中一方时；\n（2）学生因休学、复学、转学、退学时；\n（3）学生往返于学校与实习地点时；\n（4）学生证未按时办理学校注册的；\n（5）学生证优惠乘车区间更改但未加盖学校公章的；\n（6）没有“学生火车票优惠卡”、“学生火车票优惠卡”不能识别或者与学生证记载不一致的。\n（7）学生票时应以近径路或换乘次数少的列车发售。";

@interface TrainOrderStudentTicketRuleVC ()

@property (nonatomic, retain) UITextView *ruleTextView;

@end

@implementation TrainOrderStudentTicketRuleVC

- (void)dealloc
{
    self.ruleTextView = nil;
    
    [super dealloc];
}

- (id)init
{
    if (self = [super initWithTopImagePath:@"" andTitle:@"学生票规则" style:_NavOnlyBackBtnStyle_])
    {
    }
    
    return self;
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
    // Do any additional setup after loading the view.
    
    UITextView *tempTextView = [[UITextView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, MAINCONTENTHEIGHT)];
    tempTextView.backgroundColor = [UIColor clearColor];
    tempTextView.textColor = [UIColor blackColor];
    tempTextView.delegate = self;
    tempTextView.editable = YES;
    tempTextView.scrollEnabled = YES;
    tempTextView.text = studentTicketRule;
    self.ruleTextView = tempTextView;
    [tempTextView release];
    [self.view addSubview:_ruleTextView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
