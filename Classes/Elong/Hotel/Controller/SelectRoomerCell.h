//
//  SelectRoomerCell.h
//  ElongClient
//
//  Created by bin xing on 11-1-28.
//  Copyright 2011 shoujimobile. All rights reserved.
//
//  增加一个显示“房间x入住人”的label by 赵海波 on 14-3-21

#import <UIKit/UIKit.h>


@interface SelectRoomerCell : UITableViewCell {
    UIImageView *selectImgView;
    UILabel *nameLabel;
    UILabel *roomIndexLabel;        // 显示“房间x入住人”的label
    UIImageView *splitView0;
    UIImageView *splitView1;
}
@property (nonatomic,assign) NSInteger cellType;
- (void) setName:(NSString *)name;
- (void) setChecked:(BOOL)checked;
- (void)setRoomIndex:(NSInteger)index;          // 设置显示“房间x入住人”
@end
