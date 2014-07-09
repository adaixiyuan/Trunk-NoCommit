//
//  XGBaseTableViewCell.h
//  ElongClient
//
//  Created by guorendong on 14-4-17.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
//获取某种类型的Cell
#define xgGetCellForNibName(name,type) (type *)[XGBaseTableViewCell getCellByNibName:name ctype:[type class]]

@interface XGBaseTableViewCell : UITableViewCell
@property(nonatomic,strong)id tagObject;
+(id)getCellByNibName:(NSString *)name ctype:(Class)ctype;

@end
