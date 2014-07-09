//
//  PublicMethods.h
//  ElongClient
//
//  Created by Haibo Zhao on 11-8-12.
//  Copyright 2011年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CommonCrypto/CommonDigest.h>

@protocol NavigationDelegate;
@interface PublicMethods : NSObject

// 根据证件名字返回其在api端对应的枚举置
+ (NSNumber *)getIdTypeFromTypeName:(NSString *)name;

// 返回mac地址
+ (NSString *)macaddress;

// 获取url链接的图片，没有图片时返回默认图片(同步方式)
+ (UIImage *)getImageWithURL:(NSString *)urlPath;

// 处理压缩数据
+ (NSDictionary *)unCompressData:(NSData *)data;

// 获取用户卡号
+ (NSString *)getUserElongCardNO;

// 根据传入分钟数得出HH：mm这样格式的时间
+ (NSString *)getHHmmTimeFromMinutes:(NSInteger)minutes;

// 弹出一个带标题或信息警告框
+ (void)showAlertTitle:(NSString *)title Message:(NSString *)message;

// 显示当前还有多少内存可用
+ (void)showAvailableMemory;

// 芝麻关门
+ (void)closeSesameInView:(UIView *)nowView;

// 获取passbook数据
+ (NSData *)getPassDateByType:(NSString *)type
                      orderID:(NSString *)orderId
                      cardNum:(NSString *)num
                          lat:(NSString *)latitude
                          lon:(NSString *)longitude;

+ (NSString *)getPassUrlByType:(NSString *)type orderID:(NSString *)orderId cardNum:(NSString *)num lat:(NSString *)latitude lon:(NSString *)longitude;



// 获取一个GUID字符串
+ (NSString*)GUIDString;

// 是否登录
+ (BOOL)  adjustIsLogin;


// 进入系统自带map进行导航
+ (void)pushToMapWithDestName:(NSString *)destination;
+ (void)pushToMapWithDesLat:(double)latitude Lon:(double)longitude;
+ (void) openMapListToDestination:(CLLocationCoordinate2D)destination title:(NSString *)title;

+ (BOOL)passHotelOn;                    // 后台控制酒店passbook的开关
+ (BOOL)passGrouponOn;                  // 后台控制团购passbook的开关

// 获取今天以后（之前）x月的日期
+ (NSDate *)getPreviousDateWithMonth:(NSInteger)month;

// 获取今天还是明天的日期
+ (NSString *)descriptionFromDate:(NSDate *)date;

// 计算时间差
+ (NSString *)intervalSinceNow: (NSString *) theDate;

// 判断是否同一天
+ (BOOL)twoDateIsSameDay:(NSDate *)fistDate
                  second:(NSDate *)secondDate;

// 获取龙萃会员信息
+ (void)getLongVIPInfo;

// 按照秒数获取x天x小时x分x秒的时间，format使用"DD-HH-mm-ss"决定输出哪些单位的时间
+ (NSString *)getNormalTimeWithSeconds:(NSInteger)currentTime Format:(NSString *)format;

// 存储酒店搜索关键词及其对应城市(国际城市适用)
+ (void) saveSearchKey:(NSString *)key forCity:(NSString *)city;

+ (void) saveSearchKey:(NSString *)key type:(NSNumber *)type propertiesId:(NSNumber *)pid lat:(NSNumber *)lat lng:(NSNumber *)lng forCity:(NSString *)city;

// 获取指定城市下所有的关键词
+ (NSArray *) allSearchKeysForCity:(NSString *)city;

// 清除指定城市下所有的关键词
+ (void) clearSearchKeyforCity:(NSString *)city;

//下单后发送订单号以及坐标等信息给服务器
+(void)saveHotelOrderGpsWithOrderNo:(NSString *)orderNo HotelLat:(float)hotelLat HotelLon:(float)hotelLon;

// 拼装请求Url(GET)
+ (NSString *)composeNetSearchUrl:(NSString *)business forService:(NSString *)service andParam:(NSString *)param;

// 拼装请求Url(POST)
+ (NSString *)composeNetSearchUrl:(NSString *)business forService:(NSString *)service;

// .net服务请求串拼接
+ (NSString *)requesString:(NSString *)actionName andIsCompress:(BOOL)iscompress andParam:(NSString *)param;

// 纠偏算法 WGS84->CGJ_02
+ (void) wgs84ToGCJ_02WithLatitude:(double *)lat longitude:(double *)lon;

// 判断国内酒店地标是否需要纠偏
+ (BOOL) needSwitchWgs84ToGCJ_02;

// 判断国际酒店地标是否需要纠偏
+ (BOOL) needSwitchWgs84ToGCJ_02Abroad;

// 判断国内团购地标是否需要纠偏
+ (BOOL) needSwitchWgs84ToGCJ_02Groupon;

// 获取酒店星级
+ (NSString *) getStar:(NSInteger)level;

//得到评论描述
+(NSString *) getCommentDespLogic:(int) goodComment badComment:(int) badComment comentPoint:(float) commentPoint;

//得到评论描述(老)
+(NSString *) getCommentDespOldLogic:(int) goodComment badComment:(int) badComment;

// 获取公寓星级
+ (NSString *) getHouseStar:(NSInteger)level;

// 返回首页每个模块的标识
+ (NSInteger) getHomeItemType:(NSInteger)tag;
+ (NSString *) getHomeItemName:(NSInteger)tag;

// 返回城市ID通过城市名
+ (NSString *)getCityIDWithCity:(NSString *)cityName;

// 通过城市名判断是否为热门城市
+ (BOOL) isHotCity:(NSString *)cityName;

// 通过价格返回Level
+ (NSInteger) getMaxPriceLevel:(NSInteger)price;
+ (NSInteger) getMinPriceLevel:(NSInteger)price;

// 通过Level返回价格
+ (NSInteger) getMinPriceByLevel:(NSInteger)level;
+ (NSInteger) getMaxPriceByLevel:(NSInteger)level;


//是否可以支付宝app支付
+(BOOL) couldPayByAlipayApp;

//支付宝app支付
+(void) payByAlipayApp:(NSString *) alipayUrl;


//根据字体获得高度
+(float)labelHeightWithString:(NSString *)text Width:(int)width font:(UIFont *)font;
//屏蔽掉一行字符串中的空格、换行、回车
+(NSString *)dealWithStringForRemoveSpaces:(NSString *)aStr;

@end


@interface  NSObject (Public)

- (NSUInteger)safeCount;                // 封装数组和字典的count方法，当null对象执行时，返回0
- (NSString *)JSONRepresentation;
- (NSString *)JSONRepresentationWithURLEncoding;

@end


@interface UIApplication (Public)

- (BOOL)newOpenURL:(NSURL*)url;            // 替代系统openURL的方法，可由配置控制是否跳出程序

@end


@interface UIImage (Elong)

// 无缓存读取图片
+ (UIImage *)noCacheImageNamed:(NSString *)name;

// 返回对称拉伸的图片
+ (UIImage *)stretchableImageWithPath:(NSString *)path;

// 根据传入的size来生成相应大小的压缩图片
- (id)compressImageWithSize:(CGSize)size;

- (UIImage *) imageWithTintColor:(UIColor *)tintColor;

- (UIImage *) imageWithGradientTintColor:(UIColor *)tintColor;

- (UIImage *) imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode;

@end


@interface UIColor(Public)

// 转换16进制数为rgb色值的方法
+ (UIColor *)colorWithHexStr:(NSString *)stringToConvert;

@end


@interface UIImageView (Elong)

// 返回白底圆角的view
+ (UIImageView *)roundCornerViewWithFrame:(CGRect)rect;

// 返回华丽丽而又忧郁的灰色分割线
+ (UIImageView *)graySeparatorWithFrame:(CGRect)rect;

// 细分割线
+ (UIImageView *)dashedHalfLineWithFrame:(CGRect)rect;

// 返回低调的纵向分割线
+ (UIImageView *)verticalSeparatorWithFrame:(CGRect)rect;

// 返回清新的纵向分割线
+ (UIImageView *)bottomSeparatorWithFrame:(CGRect)rect;

// 分割线
+ (UIImageView *)separatorWithFrame:(CGRect)rect;
@end


@interface UIView (Public)

// 生成一个透明的view
+ (id)clearViewWithFrame:(CGRect)rect;

// 隐藏提示框
- (void)removeTipMessage;

// 在view中间显示提示框
- (void)showTipMessage:(NSString *)tips;

// 加入loading动画
- (void)startLoadingByStyle:(UIActivityIndicatorViewStyle)style;
- (void)startLoadingByStyle:(UIActivityIndicatorViewStyle)style AtPoint:(CGPoint)activityCenter;

- (void)startUniformLoading;            // 黑底圆角的loading框

// 结束loading动画
- (void)endLoading;
- (void)endUniformLoading;

//将试图转换为Image
- (UIImage *) imageByRenderingViewWithSize:(CGSize) size;

// 显示页面实时提醒的方法
- (void)alertMessage:(NSString *)tipString;
- (void)alertMessage:(NSString *)tipString InRect:(CGRect)rect;
- (void)alertMessage:(NSString *)tipString InRect:(CGRect)rect arrowStartPoint:(CGPoint)point;
- (void)removeAlert;

@end


@interface UIViewController (Public)

- (void)addTopShadow;

@end


typedef enum {
	ArrowOrientationRight,
	ArrowOrientationDown,
	PlusSign
}ArrowOrientation;			// 按钮后箭头方向

@interface UIButton (Public)

// 返回验证码按钮，需要传入图片地址
+ (UIButton *)checkcodeButtonWithTarget:(id)target
                                 Action:(SEL)selector
                                  Frame:(CGRect)rect;

// 返回黄底白字的18号大小的按钮
+ (UIButton *)yellowWhitebuttonWithTitle:(NSString *)title 
								  Target:(id)target 
								  Action:(SEL)selector
								   Frame:(CGRect)rect;

// 返回蓝底白字的按钮
+ (UIButton *)blueWhitebuttonWithTitle:(NSString *)title 
								Target:(id)target 
								Action:(SEL)selector
								 Frame:(CGRect)rect;

// 返回带箭头符号的button
+ (UIButton *)arrowButtonWithTitle:(NSString *)title 
							Target:(id)target
							Action:(SEL)selector
							 Frame:(CGRect)rect 
					   Orientation:(ArrowOrientation)Orientation;

// 返回带图标带文字的统一规格的按钮
+ (UIButton *)uniformButtonWithTitle:(NSString *)title 
						   ImagePath:(NSString *)path 
							  Target:(id)target 
							  Action:(SEL)selector
							   Frame:(CGRect)rect;

// 返回在底部bar上统一规格按钮
+ (UIButton *)uniformBottomButtonWithTitle:(NSString *)title 
								 ImagePath:(NSString *)path 
									Target:(id)target 
									Action:(SEL)selector
									 Frame:(CGRect)rect;

// 返回统一的更多按钮
+ (UIButton *)uniformMoreButtonWithTitle:(NSString *)title 
								  Target:(id)target 
								  Action:(SEL)selector
								   Frame:(CGRect)rect;

@end


typedef enum {
    BarButtonStyleCancel,         // 取消风格(白底蓝字)
    BarButtonStyleConfirm         // 确认风格(蓝底白字)
}BarButtonStyle;

@interface UIBarButtonItem (Public)

// 返回新版本设计navigationBar中纯文字左边的buttonItem
+ (id)navBarLeftButtonItemWithTitle:(NSString *)title
                             Target:(id)target
                             Action:(SEL)selector;

// 返回新版本设计navigationBar中纯文字左边的buttonItem
+ (id)navBarRightButtonItemWithTitle:(NSString *)title
                              Target:(id)target
                              Action:(SEL)selector;

// 返回页面右上角有2个按钮的item
+ (id)navBarTwoButtonItemWithTarget:(id)target
                     leftButtonIcon:(NSString *)leftIconPath
                   leftButtonAction:(SEL)leftSelector
                          rightIcon:(NSString *)rightIconPath
                  rightButtonAction:(SEL)rightSelector;

// 返回统一高宽字体的常用barbutton
+ (id)uniformWithTitle:(NSString *)title Style:(BarButtonStyle)style Target:(id)target Selector:(SEL)method; 

@end


@interface UINavigationItem (Public)

@end


@interface UITextView(Public) 
- (void)alertMessage:(NSString *)tipString;
- (void)alertMessage:(NSString *)tipString InRect:(CGRect)rect;
- (void)alertMessage:(NSString *)tipString InRect:(CGRect)rect arrowStartPoint:(CGPoint)point;
- (void)removeAlert;
@end



@interface NSNumber (Public)

// 返回对浮点数四舍五入之后的字符串
- (NSString *)roundNumberToString;

// 加了容错的intValue方法，如果有异常，返回0
- (NSInteger)safeIntValue;

// 加了容错的floatValue、doubleValue方法，如果有异常，返回0.0
- (CGFloat)safeFloatValue;
- (CGFloat)safeDoubleValue;

// 加了容错的boolValue方法，如果有异常，返回FALSE
- (BOOL)safeBoolValue;

@end

@interface NSString (Elong)

- (id)JSONValue;

// 返回一串字符中满足形式的字符串
- (NSString *)stringByPattern:(NSString *)format;

// 将一串字符的前xx位变为"*"号
- (NSString *)stringByReplaceWithAsteriskToIndex:(NSInteger)length;

// 将一串字符的后xx位变为"*"号
- (NSString *)stringByReplaceWithAsteriskFromIndex:(NSInteger)length;

// 信用卡格式的字符串，4位一组
- (NSString *)stringWithCreditFromat;

// 手机号隐藏设置
- (NSString *)stringPhoneCodeHidden;

// 使用md5编码后的字符串
- (NSString *)md5Coding;

// 每x位用指定字符分隔字符串
- (NSString *)stringByInsertingWithFormat:(NSString *)format perDigit:(NSInteger)digit;

// 将字符串中的电话号码加上html标签
- (NSString *)addHtmlPhoneMark;

// 封装成html语句
- (NSString *)htmlStringWithFont:(NSString *)family textSize:(CGFloat)size textColor:(NSString *)color;

// 判断字符串是否为敏感词，如果是敏感词，返回该词，如果不是返回nil
- (NSString *)sensitiveWord;

// 显示'\U...'unicode编码的正确文字
+ (NSString *)replaceUnicode:(NSString *)unicodeStr;
@end

@interface NSData (Elong)

- (NSString *)md5Coding;

@end

