//
//  SelectRent.m
//  ElongClient
//
//  Created by nieyun on 14-4-16.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "SelectRent.h"

//RentCar
#define Title_RentCar  @"选择乘车人"
#define Tip_RentCar @"请选择真实乘车人，以保证正确为您派车"
#define NoChoose_RentCar @"您尚未选择乘车人"
#define More_RentCar @"每辆车只需选择一位乘车人"
#define Tip_b_RentCar @"每辆车只需选择一位乘车人"

//ScenicTickets
#define Title_ScenicTickets  @"选择购票人"
#define Tip_ScenicTickets @"请选择真实购票人，以保证正确为您出票"
#define NoChoose_ScenicTickets @"您尚未选择购票人"
#define More_ScenicTickets @"每张票只能选择一位购票人"
#define Tip_b_ScenicTickets @"每张票只能选择一位购票人"


@interface SelectRent ()

@end

@implementation SelectRent

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
}

- (id) initRentRequested:(BOOL)requested peopleCount:(NSInteger)count andType:(SelectType )atype
{
            if (self = [super init])
            {
                self.type = atype;
                if (self=[super initWithTopImagePath:nil andTitle:(self.type == SelectType_RentCar)?Title_RentCar:Title_ScenicTickets style:_NavOnlyBackBtnStyle_])
             {
                [super  setTingAll:requested roomCount:count  tip:(self.type == SelectType_RentCar)?Tip_RentCar:Tip_ScenicTickets andType:self.type];
                
             }
        return self;
       
    }
     return self;
}

- (void)clickConfirm
{
    BOOL haveSelected = NO;
    for (NSDictionary *dict in [SelectRoomer  allRoomers]) {
        if ([[dict safeObjectForKey:@"Checked"] boolValue]) {
            haveSelected = YES;
        }
    }
    if (!haveSelected) {
        [PublicMethods showAlertTitle:(self.type == SelectType_RentCar)?NoChoose_RentCar:NoChoose_ScenicTickets Message:nil];
        return;
    }
    
    NSInteger count = 0;
    BOOL canBack = YES;
    for (NSMutableDictionary *dict in [SelectRoomer  allRoomers]) {
        if ([[dict safeObjectForKey:@"Checked"] boolValue]) {
            if (count>=roomCount) {
                [Utils alert:(self.type == SelectType_RentCar)?More_RentCar:More_ScenicTickets];
                canBack = NO;
                break;
            }else{
                count++;
            }
        }
    }
    
    if (canBack) {
        if ([delegate respondsToSelector:@selector(selectRoomer:didSelectedArray:)]) {
            [delegate selectRoomer:self didSelectedArray:[SelectRoomer allRoomers]];
        }
        
        if (IOSVersion_7) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self dismissModalViewControllerAnimated:YES];
        }
    }

}

- (void)didSelectAlert
{
     [Utils alertQuiet:(self.type == SelectType_RentCar)?Tip_b_RentCar:Tip_b_ScenicTickets];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
