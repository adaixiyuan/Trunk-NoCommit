//
//  SegmentView.m
//  QuickHotel
//
//  Created by Dawn on 13-7-28.
//  Copyright (c) 2013年 Xu Wenchao. All rights reserved.
//

#define SEGMENT_BUTTON_TAG 3011

#import "SegmentView.h"

@interface SegmentView()
@property (nonatomic,assign) float cellWidth;
@property (nonatomic,retain) NSArray *cellArray;
@end

@implementation SegmentView
@synthesize cellWidth;
@synthesize selectedIndex = _selectedIndex;
@synthesize cellArray;
@synthesize delegate;

- (void) dealloc{
    self.cellArray = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame cells:(NSArray *)cells{
    self = [super initWithFrame:frame];
    if (self) {
        _selectedIndex = -1;
        self.cellArray = cells;
        
        // 背景色
        bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        bgView.image = [UIImage stretchableImageWithPath:@"segment_bg.png"];
        [self addSubview:bgView];
        bgView.userInteractionEnabled = YES;
        [bgView release];
        
        //
        self.cellWidth = frame.size.width / cells.count;
        
        for (int i = 0; i < cells.count; i++) {
            UIButton *cellBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            cellBtn.tag = SEGMENT_BUTTON_TAG + i;
            cellBtn.adjustsImageWhenDisabled = NO;
            cellBtn.adjustsImageWhenHighlighted = NO;
            cellBtn.frame = CGRectMake(i * self.cellWidth, 0, self.cellWidth, frame.size.height);
            [cellBtn setTitle:[self.cellArray safeObjectAtIndex:i] forState:UIControlStateNormal];
            cellBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12.0];
            [bgView addSubview:cellBtn];
            [cellBtn addTarget:self action:@selector(cellBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            if (i != 0) {
                UIImageView *splitView = [[UIImageView alloc] initWithFrame:CGRectMake(i * self.cellWidth, 0, .55, frame.size.height)];
                splitView.image = [UIImage stretchableImageWithPath:@"segment_split_line.png"];
                [bgView addSubview:splitView];
                [splitView release];
            }
        }
        
        self.selectedIndex = 0;
        
    }
    return self;
}

- (void) setSelectedIndex:(NSInteger)selectedIndex{
    UIButton *cellBtn = (UIButton *)[bgView viewWithTag:selectedIndex + SEGMENT_BUTTON_TAG];
    if (selectedIndex != _selectedIndex) {
        [cellBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        if (selectedIndex == 0) {
            [cellBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_segleft_selected2.png"] forState:UIControlStateNormal];
        }else if(selectedIndex == self.cellArray.count - 1){
            [cellBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_segright_selected2.png"] forState:UIControlStateNormal];
        }else{
            [cellBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_defaultmid_selected2.png"] forState:UIControlStateNormal];
        }
        
        for (NSInteger i = 0; i < self.cellArray.count; i++) {
            if (i != selectedIndex) {
                cellBtn = (UIButton *)[bgView viewWithTag:i + SEGMENT_BUTTON_TAG];
                [cellBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [cellBtn setBackgroundImage:nil forState:UIControlStateNormal];
            }
        }
    }
    
    _selectedIndex = selectedIndex;
}

- (void) cellBtnClick:(id)sender{
    UIButton *cellBtn = (UIButton *)sender;
    NSInteger index = cellBtn.tag - SEGMENT_BUTTON_TAG;
    
    self.selectedIndex = index;

    if([delegate respondsToSelector:@selector(segmentView:didSelectedIndex:)]){
        [delegate segmentView:self didSelectedIndex:index];
    }
}

//改变选项卡的标题
-(void)changeTitleSet:(NSArray *)titles{
    for (int i = 0; i < titles.count; i++) {
        UIButton *cellBtn = (UIButton *)[bgView viewWithTag:SEGMENT_BUTTON_TAG+i];
        [cellBtn setTitle:[titles safeObjectAtIndex:i] forState:UIControlStateNormal];
    }
}


@end
