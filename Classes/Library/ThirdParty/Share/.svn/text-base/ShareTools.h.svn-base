//
//  ShareTools.h
//  Elong_iPad
//
//  Created by Wang Shuguang on 12-8-8.
//  Copyright 2012 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import "CustomActionSheet.h"
#import "DPNavigationBar.h"
#import "ShareKit.h"
typedef enum {
    Sharefromhotelist, // 酒店列表
    SharefromHotelHistory,    // 酒店流程
    SharefromGrouponHistory,   // 机票流程
    SharefromFlightHistory   // 团购流程
}ShareType;

@interface ShareTools : NSObject<UIActionSheetDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,UIAlertViewDelegate,CustomActionSheetDelegate> {
	UIViewController *contentViewController;
	UIView *contentView;
	NSString *message;
	NSString *mailContent;
	NSString *msgContent;
	NSString *weiBoContent;
	UIImage *hotelImage;
	NSString *imageUrl;
	NSString *mailTitle;
	UIImage *mailImage;
	UIView *mailView;
    
    int grouponId;    //团购酒店Id，用于微信追踪查询
	
	CustomActionSheet *customActionSheet;
    BOOL needLoading;
    ShareType sharefrom;
}
@property (nonatomic,assign) ShareType sharefrom;
@property (nonatomic,assign) UIViewController *contentViewController;
@property (nonatomic,assign) UIView *contentView;
@property (nonatomic,retain) NSString *message;
@property (nonatomic,retain) NSString *mailTitle;
@property (nonatomic,retain) UIImage *hotelImage;
@property (nonatomic,copy) NSString *imageUrl;
@property (nonatomic,copy) NSString *mailContent;
@property (nonatomic,copy) NSString *msgContent;
@property (nonatomic,copy) NSString *weiBoContent;
@property (nonatomic,retain) UIImage *mailImage;
@property (nonatomic,retain) UIView *mailView;
@property (nonatomic) float lat;
@property (nonatomic) float lon;
@property (nonatomic,assign) int grouponId;
@property (nonatomic,copy) NSString *hotelId;
@property (nonatomic,assign) BOOL needLoading;

+ (id) shared;
- (void) showItems;

+(void)setShareTypeNameForWX:(NSString *)name;
+(NSString *)shareTypeNameForWX;

@end
