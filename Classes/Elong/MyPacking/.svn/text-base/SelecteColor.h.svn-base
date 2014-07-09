//
//  SelecteColor.h
//  ElongClient
//
//  Created by Jian.Zhao on 13-12-31.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "DPNav.h"

typedef enum {
    
    List_Color = 0,
    List_Type

}LIST;

@protocol SelectedColorDelegate <NSObject>

-(void)getTheSelectedColor:(NSString *)color;

-(void)getTheSelectedType:(NSString *)aType;

@end

@interface SelecteColor : DPNav<UITableViewDataSource,UITableViewDelegate>{

    id<SelectedColorDelegate>delegate;
    
    UITableView *_tableView;
    NSArray *_titles;
    int defaultIndex;
    LIST _type;
}

@property (nonatomic,retain) NSArray *titles;
@property (nonatomic,assign) LIST type;

-(id)initWithDefaultColor:(int )Color delegate:(id)_delegate titles:(NSArray *)array Type:(LIST)aType;

@end
