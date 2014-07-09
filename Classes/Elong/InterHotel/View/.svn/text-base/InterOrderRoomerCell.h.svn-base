//
//  InterOrderRoomerCell.h
//  ElongClient
//
//  Created by Ivan.xu on 13-6-24.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InterOrderRoomerDelegate;
@interface InterOrderRoomerCell : UITableViewCell<UITextFieldDelegate>{
@private
    UIImageView *splitlineView0;
    UIImageView *splitlineView1;
    UIImageView *splitlineView2;
}

@property(nonatomic,assign) id<InterOrderRoomerDelegate> delegate;
@property(nonatomic) int currentBedTypeIndex;
@property(nonatomic,retain) UITextField *lastnameTF;        //姓
@property(nonatomic,retain) UITextField *firstnameTF;   //名
@property(nonatomic,retain) UILabel *bedTypeLB;     //床型

-(void)setCellType:(int)type;       //设置表类型
-(void)showBedTypeOption:(BOOL)flag;        //显示房型
-(void)setRoomDesp:(NSString *)roomDesp andRoomerDesp:(NSString *)roomerDesp;       //设置房间信息和入住人信息

@end

@protocol InterOrderRoomerDelegate <NSObject>

@optional
-(void)selectBedTypeWithCellIndex:(int)index withBedTypeName:(NSString *)typeName;
-(void)keyBoardWillShowWithCellIndex:(int)index;

@end



