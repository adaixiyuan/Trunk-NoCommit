//
//  LoginDelegate.h
//  ElongClient
//
//  Created by Dawn on 14-6-11.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Login;
@protocol LoginDelegate <NSObject>
@optional
- (void) login:(Login *)login didLogin:(NSDictionary *)dict;
- (void) loginDidLoginNonmember:(Login *)login;
@end
