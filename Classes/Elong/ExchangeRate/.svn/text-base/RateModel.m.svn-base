 //
//  RateModel.m
//  ElongClient
//
//  Created by Jian.zhao on 13-12-25.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "RateModel.h"

@implementation RateModel

-(id)init{

    if (self = [super init]) {
        _simplyName = @"";
        _name = @"";
        _rate = 0.0f;
        _pinyin = @"";
    }
    return self;
}


-(id)initWithDictionary:(NSDictionary *)dictionary{

    if (self = [super init]) {
        //
        NSArray *array = [dictionary allKeys];
        
        for (NSString *key in array) {
            id value = [dictionary objectForKey:key];
            if (!value && [value isKindOfClass:[NSString class]]) {
                [self setValue:@"" forKey:key];
            }else if (!value && ![value isKindOfClass:[NSString class]]){
                [self setValue:[NSNumber numberWithFloat:0.0f] forKey:key];
            }else{
                [self setValue:[dictionary objectForKey:key] forKey:key];
            }
        }
    }
    return self;
}

- (id) initWithCoder: (NSCoder *)coder
{
    if (self = [super init])
    {
        self.simplyName = [coder decodeObjectForKey:@"simplyName"];
        self.name = [coder decodeObjectForKey:@"name"];
        self.rate = [coder decodeDoubleForKey:@"rate"];
        self.pinyin = [coder decodeObjectForKey:@"pinyin"];
    }
    return self;
}
- (void) encodeWithCoder: (NSCoder *)coder
{
    [coder encodeObject:self.simplyName forKey:@"simplyName"];
    [coder encodeObject:self.name  forKey:@"name"];
    [coder encodeDouble:self.rate forKey:@"rate"];
    [coder encodeObject:self.pinyin forKey:@"pinyin"];
}


-(void)dealloc{
    self.pinyin = nil;
    self.simplyName = nil;
    self.name = nil;
    [super dealloc];
}

@end
