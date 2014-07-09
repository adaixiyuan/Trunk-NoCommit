//
//  GrouponOrderWebToAppLogic.h
//  ElongClient
//
//  Created by Dawn on 14-6-3.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "WebToAppBaseLogic.h"

@interface GrouponOrderWebToAppLogic : WebToAppBaseLogic<HttpUtilDelegate>{
@private
    HttpUtil *grouponDetailHttpUtil;
}

@property (nonatomic,copy) NSString *ref;
@property (nonatomic,copy) NSString *prodid;
@property (nonatomic,copy) NSString *app;
@end
