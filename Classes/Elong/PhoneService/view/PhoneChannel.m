//
//  PhoneChannel.m
//  ElongClient
//
//  Created by nieyun on 14-5-30.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "PhoneChannel.h"
#import "LineView.h"
#import "PhoneListCtrl.h"

@implementation PhoneChannel

//- (id)initWithFrame:(CGRect)frame  andAddInView:(UIView *)view
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//       //
//        titileAr = [[NSArray  alloc]initWithObjects:@"国内酒店",@"机票",@"团购",@"国际酒店", nil];
//        table  = [[UITableView  alloc]initWithFrame:CGRectMake(0, 20, self.width, self.height - 20) style:UITableViewStylePlain];
//        [self  addSubview:table];
//        table.delegate = self;
//        table.dataSource= self;
//        
//    }
//    return self;
//
//}

- (void) addInView:(UIView *)inView callType:(PhoneType)type
{
    callType = type;
    bgView.hidden = NO;
    self.hidden = NO;
    [inView.window  addSubview:bgView];
    [inView.window  addSubview:self];
    
    widownView = inView;
    self.transform = CGAffineTransformMakeScale(0.2, 0.2);
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationCurveEaseIn animations:^{
         self.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished) {
       [UIView  animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
           self.transform = CGAffineTransformMakeScale(0.9, 0.9);
       } completion:^(BOOL finished) {
           [UIView  animateWithDuration:0.2 delay:0 options:UIViewAnimationCurveEaseOut animations:^{
               self.transform = CGAffineTransformIdentity;
           } completion:nil];
       }];
    }];
}
- (void)disMiss
{
    if (widownView)
    {
        self.hidden = YES;
        bgView.hidden = YES;
       [bgView  removeFromSuperview];
       [self  removeFromSuperview];
        
    }
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor  clearColor];
        bgView = [[UIView  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        bgView.backgroundColor = [UIColor  blackColor];
        bgView.alpha = 0.6;
        
        imageAr = [[NSArray  alloc]initWithObjects:@"custom_hotel.png",@"custom_fly.png",@"custom_tuan.png",@"custom_internl.png", nil];
        nameAr = [[NSArray  alloc]initWithObjects:@"国内酒店",@"机票",@"团购",@"国际酒店", nil];
        
        UIButton *canclebt = [[UIButton  alloc]initWithFrame:CGRectMake(self.width - 20, 0, 20, 20)];
        [canclebt addTarget:self action:@selector(disMiss) forControlEvents:UIControlEventTouchUpInside];
        canclebt.backgroundColor = [UIColor  clearColor];
        [canclebt  setImage:[UIImage noCacheImageNamed:@"closeRoundButton.png"] forState:UIControlStateNormal];
        [self addSubview:canclebt];
        
        self.clipsToBounds = YES;
        [canclebt  release];

        titileAr = [[NSArray  alloc]initWithObjects:@"国内酒店",@"机票",@"团购",@"国际酒店", nil];
        
        table  = [[UITableView  alloc]initWithFrame:CGRectMake(0, 20, self.width, self.height - 20) style:UITableViewStylePlain];
        table.backgroundView = nil;
        table.backgroundColor  = [UIColor clearColor];
        table.backgroundColor = RGBACOLOR(248, 248, 248, 1);
        table.separatorStyle =UITableViewCellSeparatorStyleNone;
        [self  addSubview:table];
        table.delegate = self;
        table.dataSource= self;
        [self  footTableViewMake];
    }
    return self;
}
#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString  *str =@"cell";
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell)
    {
        cell = [[[UITableViewCell  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)
                 ]autorelease];
       
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //cell.selectionStyle =UITableViewCellSelectionStyleNone;
        
        [cell.contentView  addSubview:[self cellViewMake:[imageAr  safeObjectAtIndex:indexPath.section] labelName:[nameAr  safeObjectAtIndex:indexPath.section]]];
        

        
        cell.textLabel.text = [titileAr  safeObjectAtIndex:[titileAr  safeObjectAtIndex:indexPath.row]];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
  
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self  disMiss];
 
    PhoneListCtrl  *ctrl = [[PhoneListCtrl  alloc]initWithTitle:@"国内酒店订单" style:NavBarBtnStyleOnlyBackBtn phoneType:callType chanelType:indexPath.row];
    
    ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.navigationController  pushViewController:ctrl animated:YES];
    [ctrl release];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView  *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    return [view autorelease];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{    if (section == 0)
    return 20;
    
    return 10;
}

#pragma mark -
- (void )footTableViewMake
{
    UIView  *foot = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, table.width, 20)] autorelease];
    foot.backgroundColor = RGBACOLOR(248, 248, 248, 1);
    table.tableFooterView = foot;
}
- (UIView  *)cellViewMake :(NSString *)imagePath  labelName:(NSString  *)name
{
    UIView  *cellView = [[LineView alloc]initWithFrame:CGRectMake(10,0 , table.width - 20, 44)];
    
    cellView.backgroundColor = [UIColor  whiteColor];
    
    UIImageView  *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(85, 8, 22, 22)];
    imageView.image = [UIImage noCacheImageNamed:imagePath];
    [cellView  addSubview:imageView];
    [imageView release];
    
    UILabel  *label = [[UILabel alloc]initWithFrame:CGRectMake(imageView.right + 20, imageView.top, 80, 22)];
    label.text = name;
    label.backgroundColor = [UIColor clearColor];
    [cellView addSubview:label];
    [label release];
    
    return [cellView  autorelease];
    
}
- (void)dealloc
{
    [table release];
    [imageAr release];
    [nameAr release];
    [titileAr release];
    [bgView  release];
    [super dealloc];
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
