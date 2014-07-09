//
//  AboutUsViewController.h
//  ElongClient
//
//  Created by Will Lucky on 12-11-21.
//  Copyright (c) 2012年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMengUFPViewController.h"

@interface AboutUsViewController : DPNav <UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UMengUFPViewControllerDelegate>{
    UMengUFPViewController *umengUFPVC;
    UITableView *tableview;
}
@end
