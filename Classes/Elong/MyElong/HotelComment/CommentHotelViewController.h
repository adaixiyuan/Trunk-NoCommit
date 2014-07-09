//
//  CommentHotelViewController.h
//  ElongClient
//  酒店评论页面
//
//  Created by 赵 海波 on 12-4-12.
//  Copyright 2012 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ButtonView.h"
#import "DPNav.h"

typedef enum {
    HOTEL,
    GROUPON
}CommentType;

@class EmbedTextField;
@interface CommentHotelViewController : DPNav <ButtonViewDelegate, UITextFieldDelegate, UITextViewDelegate> {
@private
	NSDictionary *dataDic;
	
	UIImageView *upIcon;			// 推荐
	UIImageView *downIcon;			// 不推荐
	EmbedTextField *nickNameField;
	UITextView *contentView;
	UIScrollView *bgView;
	float offY;						// 内容总高度
    CommentType _currentCommentType;
}

- (id)initWithDatas:(NSDictionary *)dic commentType:(CommentType)type;

@end
