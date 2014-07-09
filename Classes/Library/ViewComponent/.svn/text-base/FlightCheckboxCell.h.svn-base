//
//  FlightCheckboxCell.h
//  ElongClient
//
//  Created by chenggong on 13-12-19.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FlightCheckboxCellDelegate;

@interface FlightCheckboxCell : UITableViewCell

@property (nonatomic, retain) UIButton *checkBoxButton;
@property (nonatomic, retain) UILabel *cellTextLabel;
@property (nonatomic, retain) UIImageView *airlineImageView;
@property (nonatomic, assign) id<FlightCheckboxCellDelegate> delegate;

// 指定高度、风格、选中样式的cell
- (id)initWithIdentifier:(NSString *)identifierString height:(CGFloat)cellHeight selected:(BOOL)selected;
- (void)setCheckBoxButtonSelected:(BOOL)selected;
- (void)buttonClicked:(id)sender;
- (void)setAirlineImageViewImage:(UIImage *)image;

@end

@protocol FlightCheckboxCellDelegate <NSObject>

- (void)tableViewCell:(UITableViewCell *)cell selected:(BOOL)selected;

@end
