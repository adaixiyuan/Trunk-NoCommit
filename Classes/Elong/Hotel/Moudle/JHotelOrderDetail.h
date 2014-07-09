//
//  JHotelOrderDetail.h
//  ElongClient
//
//  Created by Dawn on 14-1-13.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHotelOrderDetail : NSObject{
@private
    NSMutableDictionary *contents;
}

@property (nonatomic,copy) NSString *cardNo;
@property (nonatomic,assign) NSInteger orderNo;

-(NSString *)requesString:(BOOL)iscompress;
@end
