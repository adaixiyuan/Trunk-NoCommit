//
//  InterHotelOrderConfirmationLetterController.m
//  ElongClient
//
//  Created by 赵岩 on 13-7-1.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "InterHotelOrderConfirmationLetterController.h"
#import "StarsView.h"

@interface InterHotelOrderConfirmationLetterController ()

@end

@implementation InterHotelOrderConfirmationLetterController

- (void)dealloc
{
    [_orderNumber release];
    [_hotelName release];
    [_starLevel release];
    [_hotelAddress release];
    [_hotelTelephoneNumber release];
    [_checkInDate release];
    [_checkOutDate release];
    [_orderDetails release];
    [_roomType release];
    [_roomDetails release];
    [_guestsList release];
    [_price release];
    [_tax release];
    [_total release];
    [_payer release];
    [_cardNumber release];
    [_additionalInfomation release];
    [_specialRequirements release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *image = [UIImage noCacheImageNamed:@"interHotelConfirmLetterSide@2x.png"];
    UIColor *backgroundColor = [UIColor colorWithPatternImage:image];  
    
    UIImageView *left = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 2.5, self.view.frame.size.height)] autorelease];
    left.backgroundColor = backgroundColor;
    [self.view addSubview:left];
    
    UIImageView *right = [[[UIImageView alloc] initWithFrame:CGRectMake(320 - 2.5, 0, 2.5, self.view.frame.size.height)] autorelease];
    right.backgroundColor = backgroundColor;
    [self.view addSubview:right];
    
    UIButton *save = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [save setImage:[UIImage imageNamed:@"interHotelOrderConfirmationLetterSave.png"] forState:UIControlStateNormal];
    [save addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:save];
    
    UIButton *back = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50, 0, 50, 50)];
    [back setImage:[UIImage imageNamed:@"closeRoundButton.png"] forState:UIControlStateNormal];
    [back addTarget:_orderDetailController action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    if (UMENG) {
        //国际酒店确认函
        [MobClick event:Event_InterConfirmationLetter];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    self.tableView.frame = self.view.bounds;
    
    NSString *message;
    NSString *title;
    if (!error)
	{
        title = nil;
        message = NSLocalizedString(@"订单已经保存到相册", @"");
    } else {
        title = NSLocalizedString(@"保存失败", @"");
        message = @"为允许访问相册，请在设置中打开！";
	}
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"知道了", @"")
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    //    orderBtn.enabled = NO;

    self.view.userInteractionEnabled = YES;
    
}

- (IBAction)save:(id)sender
{
    self.view.userInteractionEnabled = NO;
    
    CGRect frame = self.tableView.frame;
    frame.size = self.tableView.contentSize;
    self.tableView.frame = frame;
    CGSize size = self.tableView.contentSize;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0) {
        if(UIGraphicsBeginImageContextWithOptions != NULL)
        {
            UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
        } else {
            UIGraphicsBeginImageContext(size);
        }
    }
    else
    {
        UIGraphicsBeginImageContext(size);
    }
	CGContextRef ctx = UIGraphicsGetCurrentContext();
    self.tableView.layer.masksToBounds = YES;
	[self.tableView.layer renderInContext:ctx];
    
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    
    UIImageWriteToSavedPhotosAlbum(newImage,
                                   self,
                                   @selector(imageSavedToPhotosAlbum:
                                             didFinishSavingWithError:
                                             contextInfo:),
                                   nil);
}

- (IBAction)back:(id)sender
{
    if (IOSVersion_7) {
        [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.parentViewController dismissModalViewControllerAnimated:YES];
    }
}

- (CGFloat)calculateHeightForOrderNumber
{
    return 100;
}

- (UITableViewCell *)generateCellForOrderNumber
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CellForOrderNumber"];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellForOrderNumber"] autorelease];
        
        UILabel *noticeLabel = [[[UILabel alloc] initWithFrame:CGRectMake(15, 52, 200, 14)] autorelease];
        [cell.contentView addSubview:noticeLabel];
        noticeLabel.text = @"您的国际酒店订单已确认";
        noticeLabel.font = [UIFont systemFontOfSize:13];
        noticeLabel.textColor = [UIColor colorWithRed:0.2941 green:0.2941 blue:0.2941 alpha:1.0];
        
        UILabel *titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 13, 320, 17)] autorelease];
        [cell.contentView addSubview:titleLabel];
        titleLabel.text = @"确认函";
        titleLabel.font = [UIFont systemFontOfSize:17];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = UITextAlignmentCenter;
        
        UILabel *orderNumberTitleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(15, 71, 68, 17)] autorelease];
        [cell.contentView addSubview:orderNumberTitleLabel];
        orderNumberTitleLabel.text = @"订单号：";
        orderNumberTitleLabel.font = [UIFont systemFontOfSize:17];
        orderNumberTitleLabel.textColor = [UIColor blackColor];
        
        UILabel *orderNumberLabel = [[[UILabel alloc] initWithFrame:CGRectMake(83, 71, 160, 17)] autorelease];
        [cell.contentView addSubview:orderNumberLabel];
        orderNumberLabel.text = self.orderNumber;
        orderNumberLabel.font = [UIFont systemFontOfSize:17];
        orderNumberLabel.textColor = [UIColor colorWithRed:0.8314 green:0 blue:0 alpha:1.0];
        
        UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(15, 99, 290, 1)] autorelease];
        imageView.image = [UIImage noCacheImageNamed:@"dashed.png"];
        [cell.contentView addSubview:imageView];
    }
    
    return cell;
}

- (CGFloat)calculateHeightForHotelDetail
{
    CGSize nameSize = [self.hotelName sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(290, NSUIntegerMax) lineBreakMode:NSLineBreakByWordWrapping];
    CGSize addressSize = [self.hotelAddress sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(290, NSUIntegerMax) lineBreakMode:NSLineBreakByWordWrapping];
    CGSize telephontSize = [self.hotelTelephoneNumber sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(290, NSUIntegerMax) lineBreakMode:NSLineBreakByWordWrapping];
    return 100 + nameSize.height + addressSize.height + telephontSize.height;
}

- (UITableViewCell *)generateCellForHotelDetail
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CellForHotelDetail"];
    
    if (cell == nil) {
        NSUInteger posY = 15;
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellForHotelDetail"] autorelease];
        
        UILabel *hotelNameTitleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(posY, 13, 200, 13)] autorelease];
        [cell.contentView addSubview:hotelNameTitleLabel];
        hotelNameTitleLabel.text = @"酒店名称/Names：";
        hotelNameTitleLabel.font = [UIFont systemFontOfSize:13];
        hotelNameTitleLabel.textColor = [UIColor colorWithRed:0.2941 green:0.2941 blue:0.2941 alpha:1.0];
        
        posY += 13;
        posY += 5;
        
        CGSize nameSize = [self.hotelName sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(290, NSUIntegerMax) lineBreakMode:NSLineBreakByWordWrapping];
        UILabel *hotelNameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(15, posY, 290, nameSize.height)] autorelease];
        [cell.contentView addSubview:hotelNameLabel];
        hotelNameLabel.numberOfLines = 0;
        hotelNameLabel.font = [UIFont systemFontOfSize:13];
        hotelNameLabel.textColor = [UIColor blackColor];
        hotelNameLabel.lineBreakMode = UILineBreakModeWordWrap;
        hotelNameLabel.text = self.hotelName;
        
        posY += nameSize.height;
        posY += 0;
        
        StarsView *starView = [[StarsView alloc] initWithFrame:CGRectMake(15, posY, 110, 16)];
        [starView setStarNumber:[NSString stringWithFormat:@"%d", [self.starLevel integerValue]]];
        [cell.contentView addSubview:starView];
        [starView release];
        
        posY += 5;
        posY += 13;
        
        UILabel *hotelAddressTitleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(15, posY, 200, 13)] autorelease];
        [cell.contentView addSubview:hotelAddressTitleLabel];
        hotelAddressTitleLabel.text = @"酒店地址/Address：";
        hotelAddressTitleLabel.font = [UIFont systemFontOfSize:13];
        hotelAddressTitleLabel.textColor = [UIColor colorWithRed:0.2941 green:0.2941 blue:0.2941 alpha:1.0];
        
        posY += 13;
        posY += 5;
        
        CGSize addressSize = [self.hotelAddress sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(290, NSUIntegerMax) lineBreakMode:NSLineBreakByWordWrapping];
        UILabel *addressLabel = [[[UILabel alloc] initWithFrame:CGRectMake(15, posY, 290, addressSize.height)] autorelease];
        [cell.contentView addSubview:addressLabel];
        addressLabel.numberOfLines = 0;
        addressLabel.font = [UIFont systemFontOfSize:13];
        addressLabel.textColor = [UIColor blackColor];
        addressLabel.lineBreakMode = UILineBreakModeWordWrap;
        addressLabel.text = self.hotelAddress;
        
        posY += addressSize.height;
        posY += 5;
        
        UILabel *hotelTelephontNumberTitleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(15, posY, 200, 13)] autorelease];
        [cell.contentView addSubview:hotelTelephontNumberTitleLabel];
        hotelTelephontNumberTitleLabel.text = @"酒店号码/Telephone：";
        hotelTelephontNumberTitleLabel.font = [UIFont systemFontOfSize:13];
        hotelTelephontNumberTitleLabel.textColor = [UIColor colorWithRed:0.2941 green:0.2941 blue:0.2941 alpha:1.0];
        
        posY += 13;
        posY += 5;
        
        CGSize telephoneSize = [self.hotelTelephoneNumber sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(290, NSUIntegerMax) lineBreakMode:NSLineBreakByWordWrapping];
        UILabel *hotelTelephontNumberLabel = [[[UILabel alloc] initWithFrame:CGRectMake(15, posY, 290, telephoneSize.height)] autorelease];
        [cell.contentView addSubview:hotelTelephontNumberLabel];
        hotelTelephontNumberLabel.numberOfLines = 0;
        hotelTelephontNumberLabel.font = [UIFont systemFontOfSize:13];
        hotelTelephontNumberLabel.textColor = [UIColor blackColor];
        hotelTelephontNumberLabel.lineBreakMode = UILineBreakModeWordWrap;
        hotelTelephontNumberLabel.text = self.hotelTelephoneNumber;
        
        CGFloat height = [self calculateHeightForHotelDetail];
        UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(15, height - 1, 290, 1)] autorelease];
        imageView.image = [UIImage noCacheImageNamed:@"dashed.png"];
        [cell.contentView addSubview:imageView];
    }
    
    return cell;
}

- (CGFloat)calculateHeightForOrderDetail
{
    NSString *text = [NSString stringWithFormat:@"%@, %@", self.roomType, self.bedType];
    CGSize typeSize = [text sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(290, NSUIntegerMax) lineBreakMode:NSLineBreakByWordWrapping];
    CGSize detailSize = [self.roomDetails sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(290, NSUIntegerMax) lineBreakMode:NSLineBreakByWordWrapping];
    CGSize specialSize = [self.specialRequirements sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(290, NSUIntegerMax) lineBreakMode:NSLineBreakByWordWrapping];
    
    return 240 + typeSize.height + detailSize.height + specialSize.height;
}

- (UITableViewCell *)generateCellForOrderDetail
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CellForOrderDetail"];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellForOrderDetail"] autorelease];
        
        UILabel *checkInDateTitlabel = [[[UILabel alloc] initWithFrame:CGRectMake(15, 15, 200, 13)] autorelease];
        [cell.contentView addSubview:checkInDateTitlabel];
        checkInDateTitlabel.font = [UIFont systemFontOfSize:13];
        checkInDateTitlabel.textColor = [UIColor colorWithRed:0.2941 green:0.2941 blue:0.2941 alpha:1.0];
        checkInDateTitlabel.text = @"入住日期/Check-in：";
        
        UILabel *checkInDateLabel = [[[UILabel alloc] initWithFrame:CGRectMake(15, 34, 290, 13)] autorelease];
        [cell.contentView addSubview:checkInDateLabel];
        checkInDateLabel.font = [UIFont systemFontOfSize:13];
        checkInDateLabel.textColor = [UIColor blackColor];
        checkInDateLabel.text = self.checkInDate;
        
        UILabel *checkOutDateTitlabel = [[[UILabel alloc] initWithFrame:CGRectMake(15, 56, 200, 13)] autorelease];
        [cell.contentView addSubview:checkOutDateTitlabel];
        checkOutDateTitlabel.font = [UIFont systemFontOfSize:13];
        checkOutDateTitlabel.textColor = [UIColor colorWithRed:0.2941 green:0.2941 blue:0.2941 alpha:1.0];
        checkOutDateTitlabel.text = @"离店日期/Check-out：";
        
        UILabel *checkOutDateLabel = [[[UILabel alloc] initWithFrame:CGRectMake(15, 75, 290, 13)] autorelease];
        [cell.contentView addSubview:checkOutDateLabel];
        checkOutDateLabel.font = [UIFont systemFontOfSize:13];
        checkOutDateLabel.textColor = [UIColor blackColor];
        checkOutDateLabel.text = self.checkOutDate;
        
        UILabel *orderDetailTitlabel = [[[UILabel alloc] initWithFrame:CGRectMake(15, 99, 200, 13)] autorelease];
        [cell.contentView addSubview:orderDetailTitlabel];
        orderDetailTitlabel.font = [UIFont systemFontOfSize:13];
        orderDetailTitlabel.textColor = [UIColor colorWithRed:0.2941 green:0.2941 blue:0.2941 alpha:1.0];
        orderDetailTitlabel.text = @"间夜/Room nights：";
        
        UILabel *orderDetailLabel = [[[UILabel alloc] initWithFrame:CGRectMake(15, 118, 290, 13)] autorelease];
        [cell.contentView addSubview:orderDetailLabel];
        orderDetailLabel.font = [UIFont systemFontOfSize:13];
        orderDetailLabel.textColor = [UIColor blackColor];
        orderDetailLabel.text = self.orderDetails;
        
        UILabel *roomTypeTitlabel = [[[UILabel alloc] initWithFrame:CGRectMake(15, 143, 200, 13)] autorelease];
        [cell.contentView addSubview:roomTypeTitlabel];
        roomTypeTitlabel.font = [UIFont systemFontOfSize:13];
        roomTypeTitlabel.textColor = [UIColor colorWithRed:0.2941 green:0.2941 blue:0.2941 alpha:1.0];
        roomTypeTitlabel.text = @"房型/Room type：";
        
        NSString *text = [NSString stringWithFormat:@"%@, %@", self.roomType, self.bedType];
        CGSize typeSize = [text sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(290, NSUIntegerMax) lineBreakMode:NSLineBreakByWordWrapping];
        UILabel *roomTypeLabel = [[[UILabel alloc] initWithFrame:CGRectMake(15, 162, 290, typeSize.height)] autorelease];
        [cell.contentView addSubview:roomTypeLabel];
        roomTypeLabel.numberOfLines = 0;
        roomTypeLabel.lineBreakMode = UILineBreakModeWordWrap;
        roomTypeLabel.font = [UIFont systemFontOfSize:13];
        roomTypeLabel.textColor = [UIColor blackColor];
        roomTypeLabel.text = text;
        
        NSUInteger posY = 162 + typeSize.height;
        posY += 10;
        
        UILabel *roomDetailTitleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(15, posY, 200, 13)] autorelease];
        [cell.contentView addSubview:roomDetailTitleLabel];
        roomDetailTitleLabel.font = [UIFont systemFontOfSize:13];
        roomDetailTitleLabel.textColor = [UIColor colorWithRed:0.2941 green:0.2941 blue:0.2941 alpha:1.0];
        roomDetailTitleLabel.text = @"房型信息/Room details：";
        
        posY += 13;
        posY += 10;
        
        CGSize detailSize = [self.roomDetails sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(290, NSUIntegerMax) lineBreakMode:NSLineBreakByWordWrapping];;
        
        UILabel *roomDetailLabel = [[[UILabel alloc] initWithFrame:CGRectMake(15, posY, 290, detailSize.height)] autorelease];
        [cell.contentView addSubview:roomDetailLabel];
        roomDetailLabel.numberOfLines = 0;
        roomDetailLabel.lineBreakMode = UILineBreakModeWordWrap;
        roomDetailLabel.font = [UIFont systemFontOfSize:13];
        roomDetailLabel.textColor = [UIColor blackColor];
        roomDetailLabel.text = self.roomDetails;
        
        posY += detailSize.height;
        posY += 10;
        
        UILabel *specialTitle = [[[UILabel alloc] initWithFrame:CGRectMake(15, posY, 200, 13)] autorelease];
        [cell.contentView addSubview:specialTitle];
        specialTitle.font = [UIFont systemFontOfSize:13];
        specialTitle.textColor = [UIColor colorWithRed:0.2941 green:0.2941 blue:0.2941 alpha:1.0];
        specialTitle.text = @"特殊要求/Special requirements：";
        
        posY += 13;
        posY += 10;
        
        CGSize textSize = [self.specialRequirements sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(290, NSUIntegerMax) lineBreakMode:NSLineBreakByWordWrapping];
        
        UILabel *special = [[[UILabel alloc] initWithFrame:CGRectMake(15, posY, 290, textSize.height)] autorelease];
        [cell.contentView addSubview:special];
        special.font = [UIFont systemFontOfSize:13];
        special.textColor = [UIColor blackColor];
        special.text = self.specialRequirements;
        
        NSUInteger h = [self calculateHeightForOrderDetail];
        
        UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(15, h - 1, 290, 1)] autorelease];
        imageView.image = [UIImage noCacheImageNamed:@"dashed.png"];
        [cell.contentView addSubview:imageView];
    }
    
    return cell;
}

- (CGFloat)calculateHeightForGuestDetail
{
    return 80 * self.guestsList.count;
}

-(UITableViewCell *)generateCellForGuestDetail
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CellForGuestDetail"];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellForGuestDetail"] autorelease];
        
        NSUInteger posY = 0;
        NSUInteger guestNumber = 1;
        for (NSDictionary *guest in self.guestsList) {
            posY += 18;
            NSString *title = [NSString stringWithFormat:@"房间%d/Room %d", guestNumber, guestNumber];
            
            UILabel *room = [[[UILabel alloc] initWithFrame:CGRectMake(15, posY, 250, 16)] autorelease];
            [cell.contentView addSubview:room];
            room.font = [UIFont systemFontOfSize:15];
            room.textColor = [UIColor blackColor];
            room.text = title;
            room.backgroundColor = [UIColor colorWithRed:0.8784 green:0.8784 blue:0.8784 alpha:1.0];
            
            posY += 16;
            posY += 5;
            
            UILabel *nameTitleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(15, 65, 290, 13)] autorelease];
            [cell.contentView addSubview:nameTitleLabel];
            nameTitleLabel.font = [UIFont systemFontOfSize:13];
            nameTitleLabel.textColor = [UIColor colorWithRed:0.2941 green:0.2941 blue:0.2941 alpha:1.0];
            nameTitleLabel.text = @"入住人姓名/Guest Name：";
            
            posY += 13;
            posY += 5;
            
            UILabel *nameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(15, 65, 100, 13)] autorelease];
            [cell.contentView addSubview:nameLabel];
            nameLabel.font = [UIFont systemFontOfSize:13];
            nameLabel.textColor = [UIColor blackColor];
            nameLabel.text = [guest safeObjectForKey:@"CustomerName"];
            
            UILabel *guestNumberLabel = [[[UILabel alloc] initWithFrame:CGRectMake(155, 65, 150, 13)] autorelease];
            [cell.contentView addSubview:guestNumberLabel];
            guestNumberLabel.textAlignment = UITextAlignmentRight;
            guestNumberLabel.font = [UIFont systemFontOfSize:13];
            guestNumberLabel.textColor = [UIColor blackColor];
            guestNumberLabel.text = [NSString stringWithFormat:@"%@成人/Adult(s)，%@儿童/Child(ren)", [[guest safeObjectForKey:@"AdultNum"] stringValue], [[guest safeObjectForKey:@"ChildNum"] stringValue]];
            
            posY += 13;
            
            ++guestNumber;
        }
        
        CGFloat height = [self calculateHeightForGuestDetail];
        
        UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(15, height - 1, 290, 1)] autorelease];
        imageView.image = [UIImage noCacheImageNamed:@"dashed.png"];
        [cell.contentView addSubview:imageView];
    }
    
    return cell;
}

- (CGFloat)calculateHeightForPriceDetail
{
    return 125;
}

- (UITableViewCell *)generateCellForPriceDetail
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CellForPriceDetail"];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellForPriceDetail"] autorelease];
        
        UILabel *priceDetailTitleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(15, 15, 250, 15)] autorelease];
        [cell.contentView addSubview:priceDetailTitleLabel];
        priceDetailTitleLabel.font = [UIFont systemFontOfSize:14];
        priceDetailTitleLabel.textColor = [UIColor colorWithRed:0.2941 green:0.2941 blue:0.2941 alpha:1.0];;
        priceDetailTitleLabel.text = @"价格信息/Room charges";
        priceDetailTitleLabel.backgroundColor = [UIColor colorWithRed:0.8784 green:0.8784 blue:0.8784 alpha:1.0];
        
        UILabel *totalTitleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(15, 40, 200, 13)] autorelease];
        [cell.contentView addSubview:totalTitleLabel];
        totalTitleLabel.font = [UIFont systemFontOfSize:13];
        totalTitleLabel.textColor = [UIColor colorWithRed:0.2941 green:0.2941 blue:0.2941 alpha:1.0];
        totalTitleLabel.text = @"实收总计/Total：";
        
        UILabel *total = [[[UILabel alloc] initWithFrame:CGRectMake(155, 38, 150, 17)] autorelease];
        [cell.contentView addSubview:total];
        total.textAlignment = UITextAlignmentRight;
        total.font = [UIFont italicSystemFontOfSize:17];
        total.text = self.total;
        
        UILabel *noticeLabel = [[[UILabel alloc] initWithFrame:CGRectMake(15, 75, 290, 40)] autorelease];
        [cell.contentView addSubview:noticeLabel];
        noticeLabel.numberOfLines = 0;
        noticeLabel.font = [UIFont italicSystemFontOfSize:10];
        noticeLabel.textColor = [UIColor colorWithRed:0.8314 green:0 blue:0 alpha:1.0];
        noticeLabel.text = @"艺龙从您的信用卡中扣除全额房费\neLong.com has charged your card for the full payment of this reservation.";
        
        UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(15, 124, 290, 1)] autorelease];
        imageView.image = [UIImage noCacheImageNamed:@"dashed.png"];
        [cell.contentView addSubview:imageView];
    }
    
    return cell;
}

- (CGFloat)calculateHeightForPayerDetail
{
    return 127;
}

- (UITableViewCell *)generateCellForPayerDetail
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CellForPayerDetail"];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellForPayerDetail"] autorelease];
        
        UILabel *priceDetailTitleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(15, 15, 250, 16)] autorelease];
        [cell.contentView addSubview:priceDetailTitleLabel];
        priceDetailTitleLabel.font = [UIFont systemFontOfSize:14];
        priceDetailTitleLabel.textColor = [UIColor colorWithRed:0.2941 green:0.2941 blue:0.2941 alpha:1.0];;
        priceDetailTitleLabel.text = @"付款详细信息/Billing information";
        priceDetailTitleLabel.backgroundColor = [UIColor colorWithRed:0.8784 green:0.8784 blue:0.8784 alpha:1.0];
        
        UILabel *priceTitleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(15, 43, 200, 13)] autorelease];
        [cell.contentView addSubview:priceTitleLabel];
        priceTitleLabel.font = [UIFont systemFontOfSize:13];
        priceTitleLabel.textColor = [UIColor colorWithRed:0.2941 green:0.2941 blue:0.2941 alpha:1.0];
        priceTitleLabel.text = @"持卡人姓名/Billing name：";
        
        UILabel *nameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(15, 62, 290, 13)] autorelease];
        [cell.contentView addSubview:nameLabel];
        nameLabel.font = [UIFont systemFontOfSize:13];
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.text = self.payer;
        
        UILabel *taxTitleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(15, 89, 200, 13)] autorelease];
        [cell.contentView addSubview:taxTitleLabel];
        taxTitleLabel.font = [UIFont systemFontOfSize:13];
        taxTitleLabel.textColor = [UIColor colorWithRed:0.2941 green:0.2941 blue:0.2941 alpha:1.0];
        taxTitleLabel.text = @"信用卡号/Card number：";
        
        UILabel *cardLabel = [[[UILabel alloc] initWithFrame:CGRectMake(15, 107, 290, 13)] autorelease];
        [cell.contentView addSubview:cardLabel];
        cardLabel.font = [UIFont systemFontOfSize:13];
        cardLabel.textColor = [UIColor blackColor];
        cardLabel.text = self.cardNumber;
        
        UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(15, 126, 290, 1)] autorelease];
        imageView.image = [UIImage noCacheImageNamed:@"dashed.png"];
        [cell.contentView addSubview:imageView];
    }
    
    return cell;
}

- (CGFloat)calculateHeightForAdditionalInfomation
{
    CGSize textSize = [self.additionalInfomation sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(290, NSUIntegerMax) lineBreakMode:NSLineBreakByWordWrapping];
    return 67 + textSize.height;
}

- (UITableViewCell *)generateCellForAdditionalInfomation
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CellForAdditionalInfomation"];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellForAdditionalInfomation"] autorelease];
        
        UILabel *informationTitleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(15, 15, 250, 16)] autorelease];
        [cell.contentView addSubview:informationTitleLabel];
        informationTitleLabel.font = [UIFont systemFontOfSize:14];
        informationTitleLabel.textColor = [UIColor colorWithRed:0.2941 green:0.2941 blue:0.2941 alpha:1.0];;
        informationTitleLabel.text = @"其他的信息/Additional information";
        informationTitleLabel.backgroundColor = [UIColor colorWithRed:0.8784 green:0.8784 blue:0.8784 alpha:1.0];
        
        UILabel *policyTitleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(15, 43, 200, 13)] autorelease];
        [cell.contentView addSubview:policyTitleLabel];
        policyTitleLabel.font = [UIFont systemFontOfSize:13];
        policyTitleLabel.textColor = [UIColor colorWithRed:0.2941 green:0.2941 blue:0.2941 alpha:1.0];
        policyTitleLabel.text = @"取消政策/Cancellation policy:";
        
        UILabel *policyLabel = [[[UILabel alloc] initWithFrame:CGRectMake(15, 62, 290, 13)] autorelease];
        [cell.contentView addSubview:policyLabel];
        policyLabel.numberOfLines = 0;
        policyLabel.font = [UIFont systemFontOfSize:13];
        policyLabel.textColor = [UIColor blackColor];
        policyLabel.text = self.additionalInfomation;
        policyLabel.frame = CGRectMake(15, 62, 290, [self calculateHeightForAdditionalInfomation]-67);
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = indexPath.row;
    UITableViewCell *cell = nil;
    
    switch (row) {
        case 0:
        {
            cell = [self generateCellForOrderNumber];
        }
            break;
        case 1:
        {
            cell = [self generateCellForHotelDetail];
        }
            break;
        case 2:
        {
            cell = [self generateCellForOrderDetail];
        }
            break;
        case 3:
        {
            cell = [self generateCellForGuestDetail];
        }
            break;
        case 4:
        {
            cell = [self generateCellForPriceDetail];
        }
            break;
        case 5:
        {
            cell = [self generateCellForPayerDetail];
        }
            break;
        case 6:
        {
            cell = [self generateCellForAdditionalInfomation];
        }
            break;
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = indexPath.row;
    CGFloat height = 0;
    
    switch (row) {
        case 0:
        {
            height = [self calculateHeightForOrderNumber];
        }
            break;
        case 1:
        {
            height = [self calculateHeightForHotelDetail];
        }
            break;
        case 2:
        {
            height = [self calculateHeightForOrderDetail];
        }
            break;
        case 3:
        {
            height = [self calculateHeightForGuestDetail];
        }
            break;
        case 4:
        {
            height = [self calculateHeightForPriceDetail];
        }
            break;
        case 5:
        {
            height = [self calculateHeightForPayerDetail];
        }
            break;
        case 6:
        {
            height = [self calculateHeightForAdditionalInfomation];
        }
            break;
        default:
            break;
    }
    
    return height;

}

@end
