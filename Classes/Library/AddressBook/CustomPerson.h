//
//  CustomPerson.h
//  ElongClient
//  个人信息页
//
//  Created by 赵 海波 on 12-8-9.
//  Copyright 2012 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ButtonView.h"


@interface CustomPerson : ABPersonViewController <ButtonViewDelegate> {
	NSString *navTitle;
}

- (id)initWithTitle:(NSString *)titleStr;

@end
