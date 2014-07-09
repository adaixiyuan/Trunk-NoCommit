//
//  UserInfoSettingVC.h
//  ElongClient
//  用户常用信息页（信用卡、地址、姓名）
//
//  Created by 赵 海波 on 13-7-24.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoSettingVC : DPNav <UITableViewDataSource, UITableViewDelegate>
{
    int m_netstate;     // 网络请求类型
}

@end
