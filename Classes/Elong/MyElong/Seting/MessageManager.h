//
//  MessageManager.h
//  ElongClient
//
//  Created by 赵岩 on 13-5-24.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMessage.h"

@interface MessageManager : NSObject

+ (id)sharedInstance;

- (void)addMessage:(EMessage *)message;
- (BOOL)removeMessage:(EMessage *)message;
- (EMessage *)getMessageByIndex:(NSUInteger)index;
- (NSUInteger)messageCount;
- (NSUInteger)unreadMessageCount;        //未读消息
- (void)save;

@end
