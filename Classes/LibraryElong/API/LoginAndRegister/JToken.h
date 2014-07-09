//
//  JToken.h
//  ElongClient
//
//  Created by Dawn on 14-1-7.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PostHeader.h"
@interface JToken : NSObject{
@private
    NSMutableDictionary *contents;
}
-(void)setToken:(NSString *)token;
-(NSString *)requesString:(BOOL)iscompress;
@end
