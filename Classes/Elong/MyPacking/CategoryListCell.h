//
//  CategoryListCell.h
//  ElongClient
//
//  Created by Jian.Zhao on 14-1-2.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol refreshTheTable <NSObject>
-(void)refreshTheTableOnSectionNum;

@end

typedef enum {

    CELL_CategoryList = 0,
    CELL_QuickAdd

}CELL_TARGET;

@class PackingItem;
@interface CategoryListCell : UITableViewCell{

    BOOL _isChecked;
    UIButton *button;
    PackingItem *_item;
    
    id<refreshTheTable>_delegate;
    
    CELL_TARGET _type;
}
@property (nonatomic,assign)   BOOL isChecked;
@property (nonatomic,assign)    id<refreshTheTable>delegate;
@property (nonatomic,assign)    CELL_TARGET type;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier Type:(CELL_TARGET)aType;

-(void)bingThePackingModel:(PackingItem  *)item;


@end
