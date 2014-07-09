//
//  SepecialNeedOptionView.h
//  ElongClient
//
//  Created by Ivan.xu on 13-6-25.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SepecialNeedOptionDelegate <NSObject>

-(void)postSelectedSepecialNeedOption:(NSDictionary *)sepecialNeed;
- (void)cancelSelectedSepecial;
@end

@interface SepecialNeedOptionView : UIView<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,assign) id<SepecialNeedOptionDelegate> delegate;
-(id)initWithSpecialNeeds:(NSString *)sepecialNeedInfo;

@end
