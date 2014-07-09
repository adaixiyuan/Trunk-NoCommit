//
//  SelecteColor.m
//  ElongClient
//
//  Created by Jian.Zhao on 13-12-31.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "SelecteColor.h"
#import "PackingDefine.h"

@interface SelecteColor ()

@end

@implementation SelecteColor

-(id)initWithDefaultColor:(int )Color delegate:(id)_delegate titles:(NSArray *)array Type:(LIST)aType{

    if (self = [super init]) {
        delegate = _delegate;
        defaultIndex  = Color;
        _titles = [[NSArray alloc] initWithArray:array];
        self.type = aType;
    }
    return self;
}

-(void)dealloc{
    SFRelease(_titles);
    SFRelease(_tableView);
    [super dealloc];
}

-(void)cancelPresent{

    if (IOSVersion_7) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem navBarLeftButtonItemWithTitle:@"取消" Target:self Action:@selector(cancelPresent)];

    UILabel *label = [[UILabel    alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    if (self.type == List_Color) {
        label.text = @"颜色";
    }else if (self.type == List_Type){
        label.text = @"清单类型";
    }
    label.font				= FONT_B18;
    label.textColor			= COLOR_NAV_TITLE;
    self.navigationItem.titleView  = label;
    [label release];
    
    _tableView  = [[UITableView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, SCREEN_HEIGHT-20-44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark
#pragma  mark UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.titles count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 49;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UILabel *label = nil;
    UILabel *title = nil;
    UIImageView *tip = nil;
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        if (indexPath.row == 0) {
            [self addLineOnView:cell WithPositionIsUp:YES];
        }
        [self addLineOnView:cell WithPositionIsUp:NO];
        
        //
        
        if (self.type == List_Color) {
            if (!label) {
                label  = [[UILabel alloc] initWithFrame:CGRectMake(20, 11, 20, 20)];
                label.backgroundColor = [UIColor clearColor];
                label.layer.cornerRadius = 10;
                label.layer.masksToBounds = YES;
                [cell addSubview:label];
                [label release];
            }
            
            if (!title) {
                title  = [[UILabel alloc] initWithFrame:CGRectMake(60, 11, 100, 20)];
                title.textColor = RGBACOLOR(52, 52, 52, 1);
                title.backgroundColor = [UIColor clearColor];
                title.font = [UIFont systemFontOfSize:16.0f];
                [cell addSubview:title];
                [title release];
            }
        }
        
        if (!tip) {
            tip = [[UIImageView alloc] initWithFrame:CGRectMake(270, 12, 19, 19)];
            tip.tag = 1000;
            [cell addSubview:tip];
            [tip release];
        }
        
    }
    
    //Confige The Cell
    
    if (self.type == List_Color) {
        switch (indexPath.row) {
            case 0:
                label.backgroundColor = PACKING_RED;
                break;
            case 1:
                label.backgroundColor = PACKING_ORANGE;
                
                break;
            case 2:
                label.backgroundColor = PACKING_GREEN;
                
                break;
            case 3:
                label.backgroundColor = PACKING_BLUE;
                
                break;
            case 4:
                label.backgroundColor = PACKING_GRAY;
                
                break;
            default:
                break;
        }

        title.text = [self.titles objectAtIndex:indexPath.row];
        
    }else if (self.type == List_Type){
        cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
        cell.textLabel.textColor = RGBACOLOR(52, 52, 52, 1);
        cell.textLabel.text = [NSString stringWithFormat:@"    %@",[self.titles objectAtIndex:indexPath.row]];
    }
    
    if (indexPath.row == defaultIndex) {
        tip.image = [UIImage imageNamed:@"btn_checkbox_checked.png"];
    }else{
        tip.image = [UIImage imageNamed:@"btn_checkbox.png"];
    }
    
    
    return cell;
}
-(void)addLineOnView:(UIView *)view WithPositionIsUp:(BOOL)isUp{
    
    float y;
    float x = 0.0f;
    if (isUp) {
        y = CGRectGetMinY(view.frame);
    }else{
        x = 25.0f;
        y = CGRectGetMaxY(view.frame)-0.5f;
    }
    UIView *topLineView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, 320-x, 0.5f)];
    topLineView.backgroundColor = [UIColor colorWithRed:188.0f / 255 green:188.0f / 255 blue:188.0f / 255 alpha:1.0f];
    [view addSubview:topLineView];
    [topLineView release];
}

#pragma mark
#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIImageView *v = (UIImageView *)[cell viewWithTag:1000];
    if (v.image == [UIImage imageNamed:@"btn_checkbox.png"]) {
        v.image = [UIImage imageNamed:@"btn_checkbox_checked.png"];
    }
    
    if (self.type == List_Color) {
        
        if (delegate && [delegate respondsToSelector:@selector(getTheSelectedColor:)]) {
            [delegate getTheSelectedColor:[NSString stringWithFormat:@"%d",indexPath.row]];
        }
        
    }else{
        if (delegate && [delegate respondsToSelector:@selector(getTheSelectedType:)]) {
            [delegate getTheSelectedType:[self.titles objectAtIndex:indexPath.row]];
        }
    }
    

    [self cancelPresent];
}
@end
