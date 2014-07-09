//
//  JHotelOrderDetail.m
//  ElongClient
//
//  Created by Dawn on 14-1-13.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "JHotelOrderDetail.h"
#import "PostHeader.h"

@implementation JHotelOrderDetail

- (void) dealloc{
    self.cardNo = nil;
    [contents release];
    [super dealloc];
}

- (id) init{
    if (self = [super init]) {
        contents = [[NSMutableDictionary alloc] init];
        [contents safeSetObject:[PostHeader header] forKey:Resq_Header];
        
    }
    return self;
}

-(NSString *)requesString:(BOOL)iscompress{
    [contents safeSetObject:self.cardNo forKey:@"CardNo"];
    [contents safeSetObject:[NSNumber numberWithInt:self.orderNo] forKey:@"OrderNo"];
    
    NSLog(@"%@", [contents JSONRepresentation]);
    return [NSString stringWithFormat:@"action=GetHotelOrder&version=1.2&compress=%@&req=%@",[NSString stringWithFormat:@"%@",iscompress?@"true":@"false"],[contents JSONRepresentationWithURLEncoding]];
}

@end
