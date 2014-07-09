//
//  IFlyMSCViewController.h
//  ElongClient
//
//  语音识别模块
//
//  Created by Dawn on 14-3-11.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ElongBaseViewController.h"
#import "iflyMSC/IFlySpeechRecognizer.h"
#import "iflyMSC/IFlySpeechUser.h"
#import "iflyMSC/IFlySetting.h"
#import "IFlyConfig.h"
#import "IFlyDataAnalyzer.h"

typedef enum {
    IFlyMSCTypeHotelSemantics = 0,      // 酒店语义解析
    IFlyMSCTypeRecognition          // 语音识别
}IFlyMSCType;

@protocol IFlyMSCViewControllerDelegate;
@interface IFlyMSCViewController : ElongBaseViewController<IFlySpeechRecognizerDelegate,IFlyDataAnalyzerDelegate>{
    
}
@property (nonatomic,assign) id<IFlyMSCViewControllerDelegate> delegate;
@property (nonatomic,assign) IFlyMSCType iflyMSCType;
@end


@protocol IFlyMSCViewControllerDelegate <NSObject>
@optional
- (void) iflyMSCVCSearch:(IFlyMSCViewController *)iflyMSCVC;
- (void) iflyMSCVCSearch:(IFlyMSCViewController *)iflyMSCVC result:(NSString *)result;
@end