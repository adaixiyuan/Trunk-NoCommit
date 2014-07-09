//
//  ShareKit.h
//  TencentWeiboTest
//
//  Created by Ivan.xu on 12-10-18.
//  Copyright (c) 2012年 Ivan.xu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBBase64.h"
#import "NSData+AES.h"

@interface ShareKit : NSObject{
    
}

+(ShareKit *) instance;

-(void)loginTencentWithType:(NSString *)type;
-(void)loginSinaWithType:(NSString *)type;
-(void)prensentTencentSendPage;
-(void)presentSinaSendPage;

-(void)sendTencentContent:(NSString *)text;
-(void)sendSinaContent:(NSString *)text;
-(void)sendTencentContent:(NSString *)text  withImage:(UIImage *)image  lon:(float)lon lat:(float)lat;
-(void)sendSinaContent:(NSString *)text  withImage:(UIImage *)image  lon:(float)lon lat:(float)lat;
-(void)shareTencent;
-(void)shareSina;
-(void)postSinaWeiBoAPI;
-(void)postTXWeiBoAPI;
-(void)showMessage:(NSString*)text;

-(NSString *)getStringFromUrl:(NSString *)urlString forNeedKey:(NSString *)needKey;
-(NSString*)encryption:(NSString*)password text:(NSString*)Text;
-(NSString*)Decrypt:(NSString*)password text:(NSString*)Text;
- (BOOL)startSinaAccessWithVerifier_V2:(NSString *)_ver;

-(NSString*)countDateTime:(NSTimeInterval)time;
-(Boolean)checkTime:(NSString *)date;

-(void)saveSinaAuthInfo:(NSDictionary *)dict;
-(void)saveTencentAuthInfo:(NSDictionary *)dict;
-(void)deleteSinaAuthInfo;
-(void)deleteTencentAuthInfo;

@end
