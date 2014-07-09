//
//  Message.m
//  ElongClient
//
//  Created by 赵岩 on 13-5-24.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "EMessage.h"

@implementation EMessage

+ (BOOL)supportsSecureCoding
{
    return YES;
}

- (void)dealloc
{
    [_time release];
    [_body release];
    [_url release];
    [super dealloc];
}

- (id)init
{
    if (self = [super init]) {
        
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_body forKey:@"body"];
    [aCoder encodeObject:_url forKey:@"url"];
    [aCoder encodeObject:_time forKey:@"time"];
    [aCoder encodeBool:_hasRead forKey:@"hasRead"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.body = [aDecoder decodeObjectForKey:@"body"];
        self.url = [aDecoder decodeObjectForKey:@"url"];
        self.time = [aDecoder decodeObjectForKey:@"time"];
        self.hasRead = [aDecoder decodeBoolForKey:@"hasRead"];
    }
                
    return self;
}

@end
