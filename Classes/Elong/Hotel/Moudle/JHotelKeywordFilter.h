//
//  JHotelFilter.h
//  ElongClient
//
//  Created by Dawn on 14-3-6.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHotelKeywordFilter : NSObject

@property (nonatomic,assign) HotelKeywordType keywordType;
@property (nonatomic,copy) NSString *keyword;
@property (nonatomic,copy) NSString *poi;
@property (nonatomic,assign) float lat;
@property (nonatomic,assign) float lng;
@property (nonatomic,assign) NSInteger pid;

- (void)copyDataFrom:(JHotelKeywordFilter *)dataFrom;
@end
