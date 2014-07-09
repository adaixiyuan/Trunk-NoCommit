//
//  UICopyLabel.h
//  ElongClient
//
//  Created by Wang Shuguang on 13-5-28.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICopyLabel : UILabel{
    
}

// 保存真实的数据，用于copy
@property (nonatomic,copy) NSString *realText;
@end
