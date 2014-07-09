//
//  SelectBedTypeView.m
//  Demo
//
//  Created by 李程 on 14-5-28.
//  Copyright (c) 2014年 李程. All rights reserved.
//

#import "XGSelectBedTypeView.h"

@implementation XGSelectBedTypeView



- (id)initWithFrame:(CGRect)frame withDefault:(int)myindex
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView:myindex];
    }
    return self;
}


-(void)createView:(int)myindex{

    self.layer.masksToBounds = YES;
//    self.layer.borderWidth = 1;
//    self.layer.backgroundColor = [UIColor colorWithWhite:212/255.0 alpha:1].CGColor;
    self.backgroundColor = [UIColor colorWithRed:246/255.0 green:249/255.0 blue:247/255.0 alpha:1];
    
    UIView *bg=[[UIView alloc]initWithFrame:CGRectMake(17.5, 5, 95*3-2, 30)];
    bg.layer.masksToBounds = YES;
    bg.layer.borderWidth = 1;
    bg.layer.borderColor = [UIColor colorWithWhite:212/255.0 alpha:1].CGColor;
    bg.layer.cornerRadius = 5;
    [self addSubview:bg];
    
    self.btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn1.backgroundColor = [UIColor colorWithRed:246/255.0 green:249/255.0 blue:247/255.0 alpha:1];
    self.btn1.layer.borderWidth = 1;
    self.btn1.layer.borderColor = [UIColor colorWithWhite:212/255.0 alpha:1].CGColor;
    self.btn1.tag  = 1000;
    [self.btn1 setTitle:@"床型不限" forState:UIControlStateNormal];
    self.btn1.titleLabel.font = [UIFont systemFontOfSize:12];
    self.btn1.frame = CGRectMake(0, 0, 95, 30);
    [self.btn1 addTarget:self action:@selector(selectBTN:) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:self.btn1];
    
    self.btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn2.backgroundColor = [UIColor colorWithRed:246/255.0 green:249/255.0 blue:247/255.0 alpha:1];
    self.btn2.tag  = 1001;
    self.btn2.frame = CGRectMake(95-1, 0, 95, 30);
    self.btn2.layer.borderWidth = 1;
    self.btn2.layer.borderColor = [UIColor colorWithWhite:212/255.0 alpha:1].CGColor;
    [self.btn2 setTitle:@"大床" forState:UIControlStateNormal];
    self.btn2.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.btn2 addTarget:self action:@selector(selectBTN:) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:self.btn2];
    
    self.btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn3.backgroundColor = [UIColor colorWithRed:246/255.0 green:249/255.0 blue:247/255.0 alpha:1];
    self.btn3.tag  = 1002;
    self.btn3.frame = CGRectMake(95*2-2, 0, 95, 30);
    self.btn3.layer.borderWidth = 1;
    self.btn3.layer.borderColor = [UIColor colorWithWhite:212/255.0 alpha:1].CGColor;
    [self.btn3 setTitle:@"双床" forState:UIControlStateNormal];
    self.btn3.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.btn3 addTarget:self action:@selector(selectBTN:) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:self.btn3];
    
    
     self.arrBTN  = [NSArray arrayWithObjects:self.btn1,self.btn2,self.btn3,nil];
    
    
    if (myindex<[self.arrBTN count]) {
        [self unSelectallBtn];
        [self selectmyBtn:[self.arrBTN objectAtIndex:myindex]];
    }
}

-(void)selectBTN:(UIButton *)sender{
    
    int btnindex = (int)sender.tag;
//     NSLog(@"执行了么=%d",btnindex);
    btnindex = btnindex-1000;
    if (btnindex<[self.arrBTN count]) {
        
        self.bedindexBlock(btnindex);  //block
        
        [self unSelectallBtn];
        [self selectmyBtn:[self.arrBTN objectAtIndex:btnindex]];
    }
}

-(void)selectmyBtn:(UIButton *)sender{
    
    
    sender.backgroundColor = [UIColor colorWithRed:27/255.0 green:88/255.0 blue:210/255.0 alpha:1];
    sender.layer.borderColor = [UIColor colorWithWhite:212/255.0 alpha:1].CGColor;
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}


-(void)unSelectallBtn{
    
    for (UIButton *btn in self.arrBTN ) {
        btn.backgroundColor = [UIColor colorWithRed:246/255.0 green:249/255.0 blue:247/255.0 alpha:1];
        btn.layer.borderColor = [UIColor colorWithWhite:212/255.0 alpha:1].CGColor;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }

}



@end
