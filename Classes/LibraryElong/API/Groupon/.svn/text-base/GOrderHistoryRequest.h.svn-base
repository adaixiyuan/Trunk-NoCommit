//
//  GOrderHistoryRequest.h
//  ElongClient
//	团购订单列表请求
//
//  Created by haibo on 11-11-28.
//  Copyright 2011 elong. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GOrderHistoryRequest : NSObject {
@private
	NSMutableDictionary *contents;
}

+ (id)shared;
@property (nonatomic,retain) NSMutableDictionary *contents;
- (void)reset;
- (void)refreshData;
// 获取历史订单请求字段
- (NSString *)grouponListOrderCompress:(BOOL)animated;

@end
