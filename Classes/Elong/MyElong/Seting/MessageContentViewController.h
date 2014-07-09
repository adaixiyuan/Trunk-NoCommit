//
//  MessageContentViewController.h
//  ElongClient
//
//  Created by Ivan.xu on 14-1-13.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "HomeAdWebViewController.h"
#import "EMessage.h"


@interface MessageContentViewController : ElongBaseViewController{
    UILabel *_titleLabel;
    UILabel *_timeLabel;
}

-(id)initWithEMessage:(EMessage *)message;

@end
