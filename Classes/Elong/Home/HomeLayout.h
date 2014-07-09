//
//  HomeLayout.h
//  Home
//
//  Created by Dawn on 13-12-4.
//  Copyright (c) 2013年 Dawn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeLayout : NSObject
@property (nonatomic,retain) NSMutableArray *items;
- (id) initWithFileName:(NSString *)fileName;
- (id) initWithDefaultFileName:(NSString *)fileName;
- (void) save;
@end
