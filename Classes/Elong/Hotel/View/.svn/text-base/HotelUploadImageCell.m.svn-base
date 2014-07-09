//
//  HotelUploadImageCell.m
//  ElongClient
//
//  Created by chenggong on 14-3-31.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "HotelUploadImageCell.h"
#import <QuartzCore/QuartzCore.h>

@interface HotelUploadImageCell()

@property (nonatomic, copy) NSString *uploadImageName;

@end

@implementation HotelUploadImageCell

- (void)dealloc
{
    self.imageTypeButton = nil;
    self.imageName = nil;
    self.statusLabel = nil;
    self.loadingView = nil;
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage noCacheImageNamed:@"ico_uploaddownarrow.png"] forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(0.0f, 170.0f, 0.0f, 10.0f);
//        button.contentEdgeInsets = UIEdgeInsetsMake(0.0f, -30.0f, 0.0f, 0.0f);
        CALayer *buttonLayer = [button layer];
        buttonLayer.borderColor = RGBACOLOR(102, 102, 102, 1).CGColor;
        buttonLayer.borderWidth = 0.51f;
        button.frame = CGRectMake(100.0f, 25.0f, 175.0f, 28.f);
        button.titleLabel.textColor = RGBACOLOR(52, 52, 52, 1);
        [button setTitleColor:RGBACOLOR(52, 52, 52, 1) forState:UIControlStateNormal];
        button.titleLabel.textAlignment = UITextAlignmentCenter;
        button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:@"" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
//        button.titleEdgeInsets = UIEdgeInsetsMake(5.0f, 0.0f, 5.0f, 40.0f);
        [self.contentView addSubview:button];
        self.imageTypeButton = button;
        
        UITextField *imageNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(100.0f, 36.0f, 150.0f, 28.f)];
        self.imageName = imageNameTextField;
        CALayer *imageNameTextFieldLayer = [imageNameTextField layer];
        imageNameTextFieldLayer.borderColor = RGBACOLOR(52, 52, 52, 1).CGColor;
        imageNameTextFieldLayer.borderWidth = 1.0f;
        imageNameTextField.delegate = self;
        imageNameTextField.font = [UIFont systemFontOfSize:14.0f];
        [imageNameTextField setBorderStyle:UITextBorderStyleLine];
        imageNameTextField.placeholder = @"图片名称";
        [self.contentView addSubview:imageNameTextField];
        [imageNameTextField release];
        
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(260.0f, 10.0f, 50.0f, 56.0f)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(112.0f, 65.0f, 150.0f, 18.0f)];
        self.statusLabel = label;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = RGBACOLOR(52, 52, 52, 1);
        label.font = [UIFont systemFontOfSize:12];
        label.numberOfLines = 0;
        [self.contentView addSubview:label];
        [label release];
        
        UIActivityIndicatorView *tempLoadingView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(165.0f, 65.0f, 18.0f, 18.0f)];
        tempLoadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        self.loadingView = tempLoadingView;
        [self.contentView addSubview:tempLoadingView];
        [tempLoadingView release];
    }
    return self;
}

#pragma mark - buttonClicked
- (void)buttonClicked:(id)sender
{
    [self.imageName resignFirstResponder];
    [self.imageTypeButton becomeFirstResponder];
    
    if (_delegate && [_delegate respondsToSelector:@selector(imageTypeButtonClicked:)]) {
        [_delegate imageTypeButtonClicked:self.tag];
    }
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    // Makes imageView get placed in the corner
    self.imageView.frame = CGRectMake( 0, 0, 88, 88 );
}

#pragma mark -
#pragma mark UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    NSLog(@"%@ %@ %@", textField.text, NSStringFromRange(range), string);
    NSUInteger textLength = [textField.text length];
    if (range.location == textLength) {
        self.uploadImageName = [NSString stringWithFormat:@"%@%@", textField.text, string];
    }
    else if (STRINGHASVALUE(string)){
        self.uploadImageName = string;
    }
    
//    NSLog(@"%@", _uploadImageName);
    if (_delegate && [_delegate respondsToSelector:@selector(imageNameTextFieldReturn:tag:)]) {
        [_delegate imageNameTextFieldReturn:_uploadImageName tag:self.tag];
    }
    
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
    
    if (_delegate && [_delegate respondsToSelector:@selector(imageNameTextFieldReturn:tag:)]) {
        [_delegate imageNameTextFieldReturn:_uploadImageName tag:self.tag];
    }
    
	return YES;
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    if (_delegate && [_delegate respondsToSelector:@selector(imageNameTextFieldBeginEdit:)]) {
        [_delegate imageNameTextFieldBeginEdit:self.tag];
    }
    return YES;
}

@end
