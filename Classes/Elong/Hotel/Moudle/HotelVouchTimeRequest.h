//
//  HotelVouchTimeRequest.h
//  ElongClient
//
//  Created by 赵 海波 on 12-6-1.
//  Copyright 2012 elong. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HotelVouchTimeRequest : NSObject {
@private
	NSMutableDictionary *contents;
}

+ (id)shared;

- (void)clearData;
- (void)rebuildData;
- (NSString *)requestForVouchTime;

@end
