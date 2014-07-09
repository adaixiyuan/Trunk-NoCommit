//
//  GrouponOrderInfoCell.m
//  ElongClient
//
//  Created by Dawn on 13-7-19.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "GrouponOrderInfoCell.h"
#define GridHeight 45

@implementation GrouponOrderInfoCell
@synthesize delegate;
@synthesize phoneField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // 酒店名
        hotelLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 2 , SCREEN_WIDTH -20, 44 )];
        hotelLbl.backgroundColor = [UIColor clearColor];
        hotelLbl.textColor = [UIColor blackColor];
        hotelLbl.font = [UIFont systemFontOfSize:17.0f];
        hotelLbl.adjustsFontSizeToFitWidth = YES;
        hotelLbl.minimumFontSize = 12.0f;
        hotelLbl.lineBreakMode = UILineBreakModeWordWrap;
        hotelLbl.textAlignment=NSTextAlignmentLeft;
        hotelLbl.numberOfLines = 0;
        [self.contentView addSubview:hotelLbl];
        [hotelLbl release];
        
        //承载的容器
        upContentView=[[UIView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, GridHeight*4)];
        upContentView.backgroundColor=[UIColor whiteColor];
        [self.contentView addSubview:upContentView];
        [upContentView release];
        
        [self addSplitView:0];
        
        // 单价
        UILabel *priceTipsLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 60, GridHeight)];
        priceTipsLbl.textColor = [UIColor blackColor];
        priceTipsLbl.backgroundColor = [UIColor clearColor];
        priceTipsLbl.font = [UIFont systemFontOfSize:16.0f];
        priceTipsLbl.textColor = [UIColor colorWithRed:93.0/255.0f green:93.0/255.0f blue:93.0/255.0f alpha:1];
        [upContentView addSubview:priceTipsLbl];
        [priceTipsLbl release];
        priceTipsLbl.text = @"单价";
        
        priceLbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 10 - 80, 0, 80, GridHeight)];
        priceLbl.textColor = [UIColor blackColor];
        priceLbl.backgroundColor = [UIColor clearColor];
        priceLbl.font = [UIFont systemFontOfSize:16.0f];
        priceLbl.textAlignment = UITextAlignmentRight;
        [upContentView addSubview:priceLbl];
        [priceLbl release];
        
        [self addSplitView:GridHeight];
        
        // 数量
        UILabel *numTipsLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, GridHeight , 60, GridHeight)];
        numTipsLbl.textColor = [UIColor blackColor];
        numTipsLbl.backgroundColor = [UIColor clearColor];
        numTipsLbl.font = [UIFont systemFontOfSize:16.0f];
        numTipsLbl.textColor = [UIColor colorWithRed:93.0/255.0f green:93.0/255.0f blue:93.0/255.0f alpha:1];
        [upContentView addSubview:numTipsLbl];
        [numTipsLbl release];
        numTipsLbl.text = @"数量";
        
        //减去
        subButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [subButton setImage:[UIImage noCacheImageNamed:@"minus_icon.png"] forState:UIControlStateNormal];
        [subButton setImage:[UIImage noCacheImageNamed:@"minus_icon_press.png"] forState:UIControlStateHighlighted];
        subButton.frame						= CGRectMake(SCREEN_WIDTH-10-89-5, GridHeight-8, 61, 61);
        subButton.enabled					= NO;
        subButton.imageEdgeInsets = UIEdgeInsetsMake(18, 18, 18, 18);
        [subButton addTarget:self action:@selector(subNumerOfPurchase) forControlEvents:UIControlEventTouchUpInside];
        [upContentView addSubview:subButton];
        
        //数字
        numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-10-53-3, GridHeight, 39, GridHeight)];
        numberLabel.text				= @"1";
        numberLabel.font				= [UIFont systemFontOfSize:16.0f];
        numberLabel.backgroundColor	= [UIColor clearColor];
        numberLabel.textColor			= [UIColor blackColor];
        numberLabel.textAlignment		= UITextAlignmentCenter;
        [upContentView addSubview:numberLabel];
        [numberLabel release];
        
//        //下划线
//        UIImageView *downLine = [[UIImageView alloc] initWithImage:[UIImage noCacheImageNamed:@"dashed.png"]];
//        downLine.frame = CGRectMake(SCREEN_WIDTH-10-42, GridHeight+32, 16, 1);
//        downLine.contentMode=UIViewContentModeScaleToFill;
//        [upContentView addSubview:downLine];
//        [downLine release];
 
        //加
        addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [addButton setImage:[UIImage noCacheImageNamed:@"plus_icon.png"] forState:UIControlStateNormal];
        [addButton setImage:[UIImage noCacheImageNamed:@"plus_icon_press.png"] forState:UIControlStateHighlighted];
        addButton.frame						= CGRectMake(SCREEN_WIDTH-10-40, GridHeight-8, 61, 61);
        addButton.imageEdgeInsets = UIEdgeInsetsMake(18, 18, 18, 18);
        [addButton addTarget:self action:@selector(addNumerOfPurchase) forControlEvents:UIControlEventTouchUpInside];
        [upContentView addSubview:addButton];
        ///
        
        [self addSplitView:GridHeight*2];
        
        // 总价
        UILabel *totalPriceTipsLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, GridHeight*2, 60, GridHeight)];
        totalPriceTipsLbl.textColor = [UIColor blackColor];
        totalPriceTipsLbl.backgroundColor = [UIColor clearColor];
        totalPriceTipsLbl.textColor = [UIColor colorWithRed:93.0/255.0f green:93.0/255.0f blue:93.0/255.0f alpha:1];
        totalPriceTipsLbl.font = [UIFont systemFontOfSize:16.0f];
        [upContentView addSubview:totalPriceTipsLbl];
        [totalPriceTipsLbl release];
        totalPriceTipsLbl.text = @"总价";
         
        totalPriceLbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH- 10 - 80, GridHeight*2, 80, GridHeight)];
        totalPriceLbl.textColor = [UIColor colorWithRed:250.0/255.0 green:70.0/255.0f blue:54.0/255.0f alpha:1];
        totalPriceLbl.backgroundColor = [UIColor clearColor];
        totalPriceLbl.font = [UIFont systemFontOfSize:16.0f];
        totalPriceLbl.textAlignment = UITextAlignmentRight;
        [upContentView addSubview:totalPriceLbl];
        [totalPriceLbl release];
        
       
        [self addSplitView:GridHeight*3];
        
        // 手机号
        UILabel *phoneLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, GridHeight*3, 60, GridHeight)];
        phoneLbl.textColor = [UIColor blackColor];
        phoneLbl.backgroundColor = [UIColor clearColor];
        phoneLbl.font = [UIFont systemFontOfSize:16.0f];
        [upContentView addSubview:phoneLbl];
        [phoneLbl release];
        phoneLbl.textColor = [UIColor colorWithRed:93.0/255.0f green:93.0/255.0f blue:93.0/255.0f alpha:1];
        phoneLbl.text = @"手机号";
        
        
        phoneField = [[CustomTextField alloc] initWithFrame:CGRectMake(10, GridHeight*3, SCREEN_WIDTH- 10 - 55, GridHeight)];
        phoneField.placeholder	= @"用于接受团购券信息";
        phoneField.borderStyle = UITextBorderStyleNone;
        phoneField.textAlignment = UITextAlignmentRight;
        phoneField.clearButtonMode = UITextFieldViewModeWhileEditing;
        phoneField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        phoneField.font = [UIFont systemFontOfSize:16.0f];
        phoneField.numberOfCharacter = 11;
        [upContentView addSubview:phoneField];
        [phoneField release];
        
        // 电话按钮
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addBtn.frame = CGRectMake(SCREEN_WIDTH - 40, GridHeight*3, 40, GridHeight);
        [addBtn setImage:[UIImage noCacheImageNamed:@"groupon_order_add.png"] forState:UIControlStateNormal];
        [addBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        addBtn.titleLabel.font = [UIFont systemFontOfSize:9.0f];
        [addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [upContentView addSubview:addBtn];
        
        // 竖分割线
        UIImageView *vSplitView = [[UIImageView alloc] initWithFrame:CGRectMake(275, GridHeight*3, 0.55, GridHeight)];
        vSplitView.image = [UIImage noCacheImageNamed:@"groupon_detail_cell_split.png"];
        [upContentView addSubview:vSplitView];
        [vSplitView release];
        
        // 分割线
        [self addSplitView:GridHeight*4];

    }
    return self;
}

//增加指定高度的分割线
-(void) addSplitView:(double) height
{
    UIImageView *splitView = [[UIImageView alloc] initWithImage:[UIImage noCacheImageNamed:@"dashed.png"]];
    splitView.frame = CGRectMake(0, height - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE);
    splitView.contentMode=UIViewContentModeScaleToFill;
    [upContentView addSubview:splitView];
    [splitView release];
}


- (void)subNumerOfPurchase {
	// 减少购买数量
	purchaseNum --;
	numberLabel.text = [NSString stringWithFormat:@"%d",purchaseNum];
	
	if (purchaseNum <= 1) {
		// 最小数量限制
		subButton.enabled = NO;
	}
    if (purchaseNum >= 99) {
        //最大数量限制
		addButton.enabled = NO;
	}else{
        // 恢复加号按钮
		addButton.enabled = YES;
    }
    [self setPrice:price num:purchaseNum];
    if ([delegate respondsToSelector:@selector(orderInfoCell:grouponNumChanged:)]) {
        [delegate orderInfoCell:self grouponNumChanged:purchaseNum];
    }
}


- (void)addNumerOfPurchase {
	// 增加购买数量
	purchaseNum ++;
	numberLabel.text = [NSString stringWithFormat:@"%d", purchaseNum];
	
	if (purchaseNum >= 99) {
		// 最大数量限制
		addButton.enabled = NO;
	}
    
    if (purchaseNum <= 1) {
		// 最小数量限制
		subButton.enabled = NO;
	}else{
        // 恢复减号按钮
        subButton.enabled = YES;
    }
    [self setPrice:price num:purchaseNum];
    if ([delegate respondsToSelector:@selector(orderInfoCell:grouponNumChanged:)]) {
        [delegate orderInfoCell:self grouponNumChanged:purchaseNum];
    }
}


- (void) setPrice:(float)price_ num:(NSInteger)num{
    price = price_;
    priceLbl.text = [NSString stringWithFormat:@"¥%.f",price];
    totalPriceLbl.text = [NSString stringWithFormat:@"¥%.f",price * num];
    purchaseNum = num;
}

- (void) addBtnClick:(id)sender{
    if([delegate respondsToSelector:@selector(orderInfoCellAddPhone:)]){
        [delegate orderInfoCellAddPhone:self];
    }
}

- (void) setHotelName:(NSString *)hotel{
//    hotel=@"哈哈哈哈哈哈哈";
    hotelLbl.text = hotel;
    CGSize size = CGSizeMake(hotelLbl.frame.size.width, 1000);
    CGSize newSize = [hotelLbl.text sizeWithFont:hotelLbl.font constrainedToSize:size lineBreakMode:UILineBreakModeCharacterWrap];
    
    if (newSize.height < 30) {
        newSize.height = 30;
    }

    hotelLbl.frame=CGRectMake(hotelLbl.frame.origin.x, hotelLbl.frame.origin.y, hotelLbl.frame.size.width, newSize.height+24);
    
    upContentView.frame=CGRectMake(upContentView.frame.origin.x, newSize.height+24, upContentView.frame.size.width, upContentView.frame.size.height);
}



@end
