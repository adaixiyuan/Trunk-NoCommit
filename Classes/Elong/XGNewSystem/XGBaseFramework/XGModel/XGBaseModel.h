//
//  XGBaseModel.h
//  ElongClient
//
//  Created by guorendong on 14-4-21.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "BaseModel.h"
#define ModelErrorPropertys  @property(nonatomic,strong)NSString *errorCode;\
@property(nonatomic,strong)NSString *errorMessage;\
@property(nonatomic,strong)NSNumber *isError;

#define ModelErrorPropertysImplement @synthesize errorCode=_errorCode;\
@synthesize errorMessage=_errorMessage;\
@synthesize isError=_isError;

@interface XGBaseModel : BaseModel

@property(nonatomic,strong)NSMutableDictionary *jsonDict;

@end
