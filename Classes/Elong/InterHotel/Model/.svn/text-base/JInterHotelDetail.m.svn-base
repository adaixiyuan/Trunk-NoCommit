//
//  JInterHotelDetail.m
//  ElongClient
//
//  Created by Ivan.xu on 13-6-19.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "JInterHotelDetail.h"
#import "Utils.h"
#import "PostHeader.h"
#import "DefineCommon.h"
#import "InterHotelDefine.h"

@interface JInterHotelDetail ()

@property(nonatomic,retain) NSMutableDictionary *contents;

@end

@implementation JInterHotelDetail
@synthesize contents;

- (void)dealloc
{
    [contents release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        if(!contents){
            contents = [[NSMutableDictionary alloc] initWithCapacity:1];
        }
        [self.contents removeAllObjects];
        [self buildPostData:YES];
    }
    return self;
}

//是否重置数据
- (void)buildPostData:(BOOL)clearDetailPost{
    if(clearDetailPost){
        [self.contents safeSetObject:[PostHeader header] forKey:Resq_Header];
        [self.contents safeSetObject:@"" forKey:Req_InterHotelId];
    }
}

//获取对象
-(id)getObjectForKey:(NSString *)key{
    id obj = [self.contents safeObjectForKey:key];
    
    return obj;
}

//设置酒店ID
-(void)setInterHotelId:(NSString *)hotelId{
    [self.contents safeSetObject:hotelId forKey:Req_InterHotelId];
}


//请求Content
- (NSString *)requestString:(BOOL)iscompress{
    return [NSString stringWithFormat:@"action=GetGlobaHotelDetailsResp&compress=%@&req=%@",[NSString stringWithFormat:@"%@",iscompress?@"true":@"false"],[self.contents JSONRepresentationWithURLEncoding]];
}

@end
