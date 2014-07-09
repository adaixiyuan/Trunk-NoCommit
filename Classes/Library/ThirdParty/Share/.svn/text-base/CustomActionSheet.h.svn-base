//
//  CustomActionSheet.h
//  ElongClient
//
//  Created by Ivan.xu on 12-9-25.
//  Copyright 2012 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareBtnView.h"

typedef enum {
    ShareEMail,
    ShareMessage,
    ShareTencentWeibo,
    ShareSinaWeibo,
    ShareWeixin,
    ShareWeixinFriend
}SharePlatType;

@protocol CustomActionSheetDelegate <UIActionSheetDelegate>

-(void)clickActionSheet:(int)tag;
-(void)clickShareCancel;

@end


@interface CustomActionSheet : UIActionSheet<ShareBtnViewDelegate> {
	id<CustomActionSheetDelegate> delegate;
    HttpUtil *sinaRequest;
    ShareBtnView  *sinaBtn;
}

-(void)clickCancel;
- (id)initWithFrame:(CGRect)frame platforms:(NSArray *)platforms;
@property (nonatomic,assign) id<CustomActionSheetDelegate> delegate;

NSString *CurrentMachineName(void);
NSString *CurrentPlatformName(void);

@end
