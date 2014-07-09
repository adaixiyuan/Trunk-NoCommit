//
//  IFlyMSCViewController.m
//  ElongClient
//
//  Created by Dawn on 14-3-11.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "IFlyMSCViewController.h"
#import "JSONKit.h"
#import <AVFoundation/AVFoundation.h>
#import "IFlyTipsView.h"
#import "PulsingHaloLayer.h"
#import "LightCycleLayer.h"


@interface IFlyMSCViewController (){
    UIButton *_startBtn;                    // 主功能按钮
    IFlyTipsView *_tipsView;                // 提示控件
    BOOL _haveReturn;                       // 是否已经识别结束
    PulsingHaloLayer *_plusingSuper;        // 脉冲光圈快
    PulsingHaloLayer *_plusingFast;         // 脉冲光圈中
    PulsingHaloLayer *_plusingSlow;         // 脉冲光圈慢
    LightCycleLayer *_lightCycle;           // 识别光圈
    BOOL _touchUp;                          // 是否已经抬起手指
    BOOL _isRecogniseing;                   // 是否正在识别
    NSInteger _totalVolume;                 // 用于检测使用者是否说话
    IFlyDataAnalyzer *analyzer;             // 科大讯飞识别结果分析器
}

@property (nonatomic,retain) NSMutableArray         *allresult;
@property (nonatomic,retain) NSArray                *defaultTips;
@property (nonatomic,retain) NSArray                *emptyTips;
@property (nonatomic,retain) NSArray                *nomacTips;
@property (nonatomic,retain) NSArray                *novolumes;
@property (nonatomic,retain) NSArray                *failedTips;
@property (nonatomic,retain) NSDate                 *startDate;

@end

@implementation IFlyMSCViewController

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void) dealloc{
    IFlySpeechRecognizer *iflySpeechRecognizer = [IFlySpeechRecognizer getRecognizer];
    if (iflySpeechRecognizer) {
        [iflySpeechRecognizer cancel];
        iflySpeechRecognizer.delegate = nil;
    }
    [analyzer      release];
    self.delegate     = nil;
    self.allresult    = nil;
    self.defaultTips  = nil;
    self.emptyTips    = nil;
    self.nomacTips    = nil;
    self.novolumes    = nil;
    self.startDate    = nil;
    self.failedTips   = nil;
    [super dealloc];
}

- (id) initWithTitle:(NSString *)titleStr style:(NavBarBtnStyle)style {
    if (self = [super initWithTitle:titleStr style:style]) {
        
        // 初始化数据
        _haveReturn       = YES;
        analyzer = [[IFlyDataAnalyzer alloc] init];
        analyzer.delegate = self;
        
        self.emptyTips   = [NSArray arrayWithObjects:@"",@"",@"",@"", nil];
        self.defaultTips = [NSArray arrayWithObjects:@"您可以试试",@"我附近的酒店",@"国贸地铁附近的酒店",@"300块钱的酒店", nil];
        self.nomacTips   = [NSArray arrayWithObjects:@"无法录音！",@"请到“设置-隐私-麦克风”选项中",@"设置允许使用麦克风", nil];
        self.novolumes   = [NSArray arrayWithObjects:@"没有说话",nil];
        self.failedTips  = [NSArray arrayWithObjects:@"无法识别", nil];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    CGPoint center = CGPointMake(SCREEN_WIDTH/2, MAINCONTENTHEIGHT - 105/2 - 73);
    // 动画层
    _plusingSuper = [[PulsingHaloLayer alloc] init];
    _plusingSuper.position = center;
    _plusingSuper.toRadius = 200;
    _plusingSuper.fromRadius = 50;
    _plusingSuper.animationDuration = 1.6;
    _plusingSuper.backgroundColor = RGBACOLOR(200, 221, 249, 1).CGColor;
    [self.view.layer addSublayer:_plusingSuper];
    [_plusingSuper release];
    
    _plusingFast = [[PulsingHaloLayer alloc] init];
    _plusingFast.position = center;
    _plusingFast.toRadius = 160;
    _plusingFast.fromRadius = 50;
    _plusingFast.animationDuration = 1.6;
    _plusingFast.backgroundColor = RGBACOLOR(153, 192, 244, 1).CGColor;
    [self.view.layer addSublayer:_plusingFast];
    [_plusingFast release];
    
    _plusingSlow = [[PulsingHaloLayer alloc] init];
    _plusingSlow.position = center;
    _plusingSlow.toRadius = 120;
    _plusingSlow.fromRadius = 50;
    _plusingSlow.animationDuration = 1.6;
    _plusingSlow.backgroundColor = RGBACOLOR(106, 163, 239, 1).CGColor;
    [self.view.layer addSublayer:_plusingSlow];
    [_plusingSlow release];
    
    
    // 启动按钮
    _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _startBtn.frame = CGRectMake(0, 0, 105,105);
    _startBtn.center = center;
    [_startBtn setImage:[UIImage noCacheImageNamed:@"ifly_btn.png"] forState:UIControlStateNormal];
    //[_startBtn setImage:[UIImage noCacheImageNamed:@"ifly_btn_disabled.png"] forState:UIControlStateDisabled];
    _startBtn.adjustsImageWhenHighlighted = NO;
    _startBtn.adjustsImageWhenDisabled = NO;
    [self.view addSubview:_startBtn];
    [_startBtn addTarget:self action:@selector(startBtnTouchDown:) forControlEvents:UIControlEventTouchDown];
    [_startBtn addTarget:self action:@selector(startBtnTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [_startBtn addTarget:self action:@selector(startBtnTouchUp:) forControlEvents:UIControlEventTouchUpOutside];
    [_startBtn addTarget:self action:@selector(startBtnTouchCancel:) forControlEvents:UIControlEventTouchCancel];
    
    // 加载符
    _lightCycle = [[LightCycleLayer alloc] init];
    _lightCycle.position = center;
    _lightCycle.radius = 111/2.0;
    _lightCycle.animationDuration = 2;
    [self.view.layer addSublayer:_lightCycle];
    [_lightCycle release];
    
    // 提示文字
    UILabel *tipsLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, MAINCONTENTHEIGHT - 60, SCREEN_WIDTH, 30)];
    tipsLbl.font = [UIFont systemFontOfSize:14.0f];
    tipsLbl.textColor = RGBACOLOR(153, 153, 153, 1);
    tipsLbl.backgroundColor = [UIColor clearColor];
    tipsLbl.textAlignment = UITextAlignmentCenter;
    tipsLbl.text = @"请长按说话";
    [self.view addSubview:tipsLbl];
    [tipsLbl release];
    
    
    // 关闭按钮
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *cancelBarItem = [UIBarButtonItem navBarLeftButtonItemWithTitle:@"取消" Target:self Action:@selector(closeBtnClick:)];
    self.navigationItem.leftBarButtonItem = cancelBarItem;
    
    
    // 提示文字
    _tipsView = [[IFlyTipsView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT - _startBtn.frame.size.height  - 73)
                                             items:self.emptyTips];
    
    [self.view addSubview:_tipsView];
    [_tipsView release];
    
    if (IOSVersion_7) {
        // 检测麦克风的使用权限
        if([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]){
            [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
                if (!granted) {
                    // 无法获取权限
                    _startBtn.enabled = NO;
                    tipsLbl.hidden = YES;
                    [_startBtn setImage:[UIImage noCacheImageNamed:@"ifly_btn_disabled.png"] forState:UIControlStateNormal];
                    
                    _tipsView.timeFront = 0;
                    [_tipsView reloadItems:self.nomacTips];
                    _tipsView.timeFront = 0.4;
                }
            }];
        }
    }
    
    if (_startBtn.enabled) {
        _tipsView.timeFront = 0;
        [_tipsView reloadItems:self.defaultTips];
        _tipsView.timeFront = 0.4;
    }
}

#pragma mark -
#pragma mark TouchDown & TouchUp

- (void)startBtnTouchDown:(id)sender{
    
    IFlySpeechRecognizer *iflySpeechRecognizer = [IFlySpeechRecognizer getRecognizer];
    if (!iflySpeechRecognizer) {
        // 创建语义识别对象
        // TODO:修改服务器地址
        // server_url=http://dev.voicecloud.cn:80/msp.do
        NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",EIFLY_APPID];
        iflySpeechRecognizer = [IFlySpeechRecognizer createRecognizer:initString delegate:self];
        
        //设置识别参数
        [iflySpeechRecognizer setParameter:@"domain" value:@"iat"];         // 普通听写服务
        [iflySpeechRecognizer setParameter:@"sample_rate" value:@"16000"];  // 录音采样率为16k
        [iflySpeechRecognizer setParameter:@"vad_bos" value:@"1800"];       // 前端点检测时间
        [iflySpeechRecognizer setParameter:@"vad_eos" value:@"6000"];       // 后端点检测时间
        [iflySpeechRecognizer setParameter:@"asr_sch" value:@"1"];          // 开启语义处理
        [iflySpeechRecognizer setParameter:@"plain_result" value:@"1"];     // 解析识别内容
        [iflySpeechRecognizer setParameter:@"params" value:@"rst=json,nlp_version = 2.0"];
        [initString release];
        
        //
        NSLog(@"科大讯飞语音识别版本：%@",[IFlySetting getVersion]);
        
        // 是否记录日志文件
        [IFlySetting setLogFile:LVL_NONE];
        
        // 控制台是否打印日志
        [IFlySetting showLogcat:NO];
    }
    
    [_startBtn setImage:[UIImage noCacheImageNamed:@"ifly_btn_h.png"] forState:UIControlStateNormal];
    [self startAnimation];
    
    self.allresult = nil;
    
    _touchUp = NO;
    _haveReturn = NO;
    
    if (!self.allresult) {
        self.allresult = [NSMutableArray array];
    }
    [self.allresult removeAllObjects];
    
    //启动识别服务
    iflySpeechRecognizer.delegate = self;
    [iflySpeechRecognizer startListening];
    
    
}

- (void) startBtnTouchUp:(id)sender{
    IFlySpeechRecognizer *iflySpeechRecognizer = [IFlySpeechRecognizer getRecognizer];
    [iflySpeechRecognizer stopListening];
    _touchUp = YES;
    
    [_startBtn setImage:[UIImage noCacheImageNamed:@"ifly_btn.png"] forState:UIControlStateNormal];
    
    [self stopAnimation];
    _startBtn.enabled = NO;
    [_lightCycle startAnimation];
    _isRecogniseing = YES;
    
    if (_haveReturn) {
        [self recognise];
    }
}

- (void) startBtnTouchCancel:(id)sender{
    IFlySpeechRecognizer *iflySpeechRecognizer = [IFlySpeechRecognizer getRecognizer];
    [iflySpeechRecognizer stopListening];
    _touchUp = YES;
    
    [_startBtn setImage:[UIImage noCacheImageNamed:@"ifly_btn.png"] forState:UIControlStateNormal];
    
    [self stopAnimation];
}

#pragma mark -
#pragma mark Private Methods

// 关闭
- (void) closeBtnClick:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

// 开始音波动画
- (void) startAnimation{
    [_plusingSuper startAnimation];
    [_plusingFast startAnimation];
    [_plusingSlow startAnimation];
}

// 停止音波动画
- (void) stopAnimation{
    [_plusingSuper stopAnimation];
    [_plusingFast stopAnimation];
    [_plusingSlow stopAnimation];
}

// 录入结束开始识别
- (void) recognise{
    _startBtn.enabled = YES;
    [_lightCycle stopAnimation];
    _isRecogniseing = NO;
    
    // 分析结果
    if(self.allresult){
        [analyzer dealWithResult:self.allresult];
        self.allresult = nil;
    }
}

#pragma mark -
#pragma mark IFlyMSCViewControllerDelegate

- (void) iFlyDataAnalyzer:(IFlyDataAnalyzer *)analyzer doneWithContent:(NSDictionary *)content{
    NSMutableArray *items = [NSMutableArray array];
    [items addObject:@"语义解析结果"];
    [items addObject:[content objectForKey:@"Text"]];
    for (NSString *key in content.allKeys) {
        if(![key isEqualToString:@"Text"]){
            [items addObject:[NSString stringWithFormat:@"%@:%@",key,[content objectForKey:key]]];
        }
    }
    
    [_tipsView reloadItems:items];
    
    if ([self.delegate respondsToSelector:@selector(iflyMSCVCSearch:)]) {
        [self.delegate iflyMSCVCSearch:self];
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void) iFlyDataAnalyzerFailed:(IFlyDataAnalyzer *)analyzer errorCode:(IFlyDataAnalyzerErrorCode)errorCode{
    [_tipsView reloadItems:self.failedTips completion:^{
        [_tipsView reloadItems:self.defaultTips];
    }];
}

#pragma mark -
#pragma mark IFlySpeechRecognizerDelegate

/** 识别结果回调 */
- (void) onError:(IFlySpeechError *) errorCode{
    NSLog(@"errorCode:%d errorDes:%@",errorCode.errorCode,errorCode.errorDesc);
    NSLog(@"timeoffset:%f",[[NSDate date] timeIntervalSinceDate:self.startDate]);
    
    if (errorCode.errorCode != 0) {
        [_tipsView reloadItems:self.failedTips completion:^{
            [_tipsView reloadItems:self.defaultTips];
        }];
    }else if(_totalVolume < 3 && _totalVolume > -1){
        [_tipsView reloadItems:self.novolumes completion:^{
            [_tipsView reloadItems:self.defaultTips];
        }];
    }
    
    _haveReturn = YES;
    if (_touchUp) {
        [self recognise];
    }
}

/** 识别结果回调 */
- (void) onResults:(NSArray *) results{
    if (results) {
        if (results.count) {
             _totalVolume = -1;
            //合并结果
            NSDictionary *dic = [results objectAtIndex:0];
            for (NSString *key in dic){
                [self.allresult addObject:key];
                NSLog(@"%@",[[key JSONValue] JSONStringWithOptions:JKSerializeOptionPretty error:NULL]);
            }
        }
    }
    
    _haveReturn = YES;
    if (_touchUp) {
        [self recognise];
    }
}

/** 音量变化回调 */
- (void) onVolumeChanged: (int)volume{
    NSLog(@"volume:%d",volume);
    if (volume) {
         _totalVolume++;
    }
}

/** 开始录音回调 */
- (void) onBeginOfSpeech{
    NSLog(@"begin speech");
    _totalVolume = 0;
}

/** 停止录音回调  */
- (void) onEndOfSpeech{
    NSLog(@"end speech");
    self.startDate = [NSDate date];
}

/** 取消识别回调 */
- (void) onCancel{
    NSLog(@"cancel");
}
@end
