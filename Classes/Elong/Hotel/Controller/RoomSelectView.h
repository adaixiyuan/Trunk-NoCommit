//
//  RoomSelectView.h
//  ElongClient
//
//  Created by Wang Shuguang on 13-4-10.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RoomSelectViewDelegate;
@interface RoomSelectView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>{
@private
    UIPickerView *viewPickerView;
    id delegate;
}
@property (nonatomic,assign) id<RoomSelectViewDelegate> delegate;
@property (nonatomic,assign) NSInteger selectedRow;
@property (nonatomic,assign) NSInteger minRows;
@property (nonatomic,assign) NSInteger guaranteeNum;

- (void) dismissInView;
- (id)initWithFrame:(CGRect)frame title:(NSString *)title;
- (void) reloadData;
- (void)showInView;
@end


@protocol RoomSelectViewDelegate <NSObject>

- (void) roomSelectView:(RoomSelectView *)roomSelectView didSelectedRowAtIndex:(NSInteger)index;

@end