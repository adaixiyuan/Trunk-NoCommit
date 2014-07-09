//
//  NavTelCallSingleton.h
//  ElongClient
//
//  Created by Ivan.xu on 14-1-16.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NavTelCallSingleton : NSObject<UIActionSheetDelegate>

+(NavTelCallSingleton *)sharedInstance;

@end
