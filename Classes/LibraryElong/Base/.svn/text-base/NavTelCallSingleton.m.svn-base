//
//  NavTelCallSingleton.m
//  ElongClient
//
//  Created by Ivan.xu on 14-1-16.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "NavTelCallSingleton.h"
#import "SynthesizeSingletonCopy.h"
#import "HotelDetailController.h"

@implementation NavTelCallSingleton

SYNTHESIZE_SINGLETON_FOR_CLASS(NavTelCallSingleton)

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (actionSheet.tag == DPNAVSHEET) {
        ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
        if ([NSStringFromClass([delegate.navigationController.visibleViewController class]) isEqualToString:@"HotelDetailController"]||[NSStringFromClass([delegate.navigationController.visibleViewController class]) isEqualToString:@"XGSpecialProductDetailViewController"]) {
            NSString *currentHotelPhone = [[HotelDetailController hoteldetail] safeObjectForKey:@"Phone"];
            // 有多个电话，处理第一个电话
            NSArray *phoneArray = [currentHotelPhone componentsSeparatedByString:@"、"];
            NSString *firstPhone = @"";
            if (phoneArray && [phoneArray count] > 0) {
                firstPhone = [phoneArray safeObjectAtIndex:0];
            }
            
            // 有分机拨号，去掉分机拨号
            NSArray *disposeExtensionArray;
            if ([firstPhone length] > 0) {
                disposeExtensionArray = [firstPhone componentsSeparatedByString:@"-"];
                if (disposeExtensionArray && [disposeExtensionArray count] > 1) {
                    currentHotelPhone = [NSString stringWithFormat:@"%@-%@", [disposeExtensionArray safeObjectAtIndex:0], [disposeExtensionArray safeObjectAtIndex:1]];
                }
            }
            else {
                disposeExtensionArray = [currentHotelPhone componentsSeparatedByString:@"-"];
                if (disposeExtensionArray && [disposeExtensionArray count] > 1) {
                    currentHotelPhone = [NSString stringWithFormat:@"%@-%@", [disposeExtensionArray safeObjectAtIndex:0], [disposeExtensionArray safeObjectAtIndex:1]];
                }
            }
            
            if (buttonIndex == 0)
            {
                NSString *telephone = [NSString stringWithFormat:@"tel://%@", currentHotelPhone]; ;
                
                if (![[UIApplication sharedApplication] newOpenURL:[NSURL URLWithString:telephone]]) {
                    
                    [PublicMethods showAlertTitle:CANT_TEL_TIP Message:nil];
                }
            }else if(buttonIndex == 1 && actionSheet.cancelButtonIndex != 1){
                NSString *telephone = @"tel://400-666-1166";
                // 列车客服电话
                if ([NSStringFromClass([delegate.navigationController.visibleViewController class]) isEqualToString:@"TrainHomeVC"])
                {
                    telephone = @"tel://400-689-9617";
                }
                
                if (![[UIApplication sharedApplication] newOpenURL:[NSURL URLWithString:telephone]]) {
                    
                    [PublicMethods showAlertTitle:CANT_TEL_TIP Message:nil];
                }
            }
        }
        else {
            if (buttonIndex == 0)
            {
                ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
                NSString *telephone = @"tel://400-666-1166";
                // 列车客服电话
                if ([NSStringFromClass([delegate.navigationController.visibleViewController class]) isEqualToString:@"TrainHomeVC"]||[NSStringFromClass([delegate.navigationController.visibleViewController class]) isEqualToString:@"RentCarDetailViewController"]||[NSStringFromClass([delegate.navigationController.visibleViewController class]) isEqualToString:@"RentCarDetailedBillViewController"])
                {
                    telephone = @"tel://400-689-9617";
                }
                
                if (![[UIApplication sharedApplication] newOpenURL:[NSURL URLWithString:telephone]]) {
                    
                    [PublicMethods showAlertTitle:CANT_TEL_TIP Message:nil];
                }
            }else if(buttonIndex == 1 && actionSheet.cancelButtonIndex != 1){
                if (![[UIApplication sharedApplication] newOpenURL:[NSURL URLWithString:@"tel://+861064329999"]]) {
                    [PublicMethods showAlertTitle:CANT_TEL_TIP Message:nil];
                }
            }
        }
	}
}

@end
