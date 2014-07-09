//
//  CustomPicker.h
//  TableTest
//
//  Created by Jian.Zhao on 14-3-12.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PickerDelegate <NSObject>

-(void)dismissTheActionSheet;
-(void)doneTheActionWithResult:(NSString *)string;

@end


@interface CustomPicker : UIView<UIPickerViewDelegate,UIPickerViewDataSource>
{

    NSMutableArray * _date;
    NSMutableArray * _hours;
    NSMutableArray * _mins;
 
    id<PickerDelegate>_delegate;
    
}

@property (nonatomic,copy)NSString *original;
@property(nonatomic,copy) NSString *selectedString;
@property (nonatomic,copy) NSString *default_Date;
@property (nonatomic,copy) NSString *default_Hours;
@property (nonatomic,copy) NSString *default_Mins;

- (id)initWithFrame:(CGRect)frame Delegate:(id)aDelegate andOriginalDate:(NSString *)aDate;

@end
