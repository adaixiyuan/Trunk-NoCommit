//
//  PackingItem.h
//  ElongClient
//
//  Created by Jian.Zhao on 13-12-31.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PackingItem : NSObject<NSMutableCopying,NSCopying,NSCoding>{

    NSString *_name;//名称
    NSString *_isChecked;//是否完成
}
@property (nonatomic,retain)    NSString *name;//名称
@property (nonatomic,retain)    NSString *isChecked;//是否完成

@end
