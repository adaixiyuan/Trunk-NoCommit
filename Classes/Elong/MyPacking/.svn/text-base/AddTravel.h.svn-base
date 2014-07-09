//
//  AddTravel.h
//  ElongClient
//
//  Created by Jian.Zhao on 13-12-31.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "DPNav.h"

@class PackingCategory;
@interface AddTravel : DPNav<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    
    UITableView *_tableView;
    UITextField *nameField;
    
    NSString *_color;//显示的颜色
    NSString *_type;
    NSString *_colorIndex;//颜色的枚举
    
    NSMutableArray *_templateType;
    NSMutableArray *_categoryList;//新建清单的CategoryList
    
    NSMutableArray *_dataSource;//所有旅程的List
}
@property (nonatomic,retain) NSString *color;
@property (nonatomic,retain) NSString *type;
@property (nonatomic,retain) NSString *colorIndex;
@property (nonatomic,retain) NSMutableArray *dataSource;

-(void)setTemplateType:(NSMutableArray *)aTempateType;
-(NSMutableArray *)templateType;

@end
