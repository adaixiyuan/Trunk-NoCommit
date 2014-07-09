//
//  CredtCardPayCtrl.h
//  ElongClient
//
//  Created by nieyun on 14-4-4.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CredtCardPayCtrl : UIViewController
{
    HttpUtil  *createCardHttpUtil;
}

- (void)creditPayAction;
@end
