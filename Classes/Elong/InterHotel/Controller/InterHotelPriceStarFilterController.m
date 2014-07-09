//
//  InterHotelPriceStarFilterController.m
//  ElongClient
//
//  Created by 赵岩 on 13-6-24.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "InterHotelPriceStarFilterController.h"

@interface InterHotelPriceStarFilterController ()

@end

@implementation InterHotelPriceStarFilterController

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

    [self updatePrice];
    [self updateStarButtons];
    
    self.minPriceTextField.numberOfCharacter = 7;
    [self.minPriceTextField showNumKeyboard];
    self.minPriceTextField.delegate = self;
    self.minPriceTextField.textFont = FONT_16;
    self.minPriceTextField.placeholder =  @"0";
    self.minPriceTextField.textField.frame=CGRectMake(8, self.minPriceTextField.textField.frame.origin.y, self.minPriceTextField.textField.frame.size.width , 31);
    self.minPriceTextField.textField.textAlignment=NSTextAlignmentCenter;
    self.minPriceTextField.textField.clearButtonMode = UITextFieldViewModeNever;
    UIImageView *minImageView =[[UIImageView alloc] initWithFrame:self.minPriceTextField.bounds];
    minImageView.contentMode=UIViewContentModeScaleToFill;
    minImageView.image=[UIImage noCacheImageNamed:@"inter_price_input_bg.png"];
    [self.minPriceTextField addSubview:minImageView];
    [minImageView release];
    
    
    self.maxPriceTextField.numberOfCharacter = 7;
    [self.maxPriceTextField showNumKeyboard];
    self.maxPriceTextField.delegate = self;
    self.maxPriceTextField.textFont = FONT_16;
    self.maxPriceTextField.placeholder =  @"不限";
    self.maxPriceTextField.textField.frame=CGRectMake(8, self.maxPriceTextField.textField.frame.origin.y, self.maxPriceTextField.textField.frame.size.width , 31);
    self.maxPriceTextField.textField.clearButtonMode = UITextFieldViewModeNever;
    self.maxPriceTextField.textField.textAlignment=NSTextAlignmentCenter;
    UIImageView *maxImageView =[[UIImageView alloc] initWithFrame:self.minPriceTextField.bounds];
    maxImageView.image=[UIImage noCacheImageNamed:@"inter_price_input_bg.png"];
    maxImageView.contentMode=UIViewContentModeScaleToFill;
    [self.maxPriceTextField addSubview:maxImageView];
    [maxImageView release];

    UITapGestureRecognizer *tapRecognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)] autorelease];
    tapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapRecognizer];
    
    self.view.backgroundColor=[UIColor whiteColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setMinPrice:(NSUInteger)minPrice
{
    _minPrice = minPrice;
    [self updatePrice];
}

- (void)setMaxPrice:(NSUInteger)maxPrice
{
    _maxPrice = maxPrice;
    [self updatePrice];
}

- (void)setStarLevle:(NSInteger)starLevle
{
    _starLevle = starLevle;
    [self updateStarButtons];
}

- (void)updatePrice
{
    if (self.minPrice > 0) {
        self.minPriceTextField.text = [NSString stringWithFormat:@"%d", self.minPrice];
    }
    else if (self.maxPrice == NSUIntegerMax) {
        self.minPriceTextField.text = nil;
    }
    else {
        self.minPriceTextField.text = [NSString stringWithFormat:@"%d", self.minPrice];
    }
    
    if (self.maxPrice != NSUIntegerMax) {
        self.maxPriceTextField.text = [NSString stringWithFormat:@"%d", self.maxPrice];
    }
    else {
        self.maxPriceTextField.text = nil;
    }
}

- (void)updateStarButtons
{
    self.unlimitedButton.selected = NO;
    self.unlimitedLabel.highlighted = NO;
    self.inexpensiveButton.selected = NO;
    self.inexpensiveLabel.highlighted = NO;
    self.threeStarButton.selected = NO;
    self.threeStarLabel.highlighted = NO;
    self.fourStarButton.selected = NO;
    self.fourStarLabel.highlighted = NO;
    self.fiveStarButton.selected = NO;
    self.fiveStarLabel.highlighted = NO;
    
    switch (self.starLevle) {
        case 0:
            self.unlimitedButton.selected = YES;
            self.unlimitedLabel.highlighted = YES;
            break;
        case 1:
            self.inexpensiveButton.selected = YES;
            self.inexpensiveLabel.highlighted = YES;
            break;
        case 2:
            self.threeStarButton.selected = YES;
            self.threeStarLabel.highlighted = YES;
            break;
        case 3:
            self.fourStarButton.selected = YES;
            self.fourStarLabel.highlighted = YES;
            break;
        case 4:
            self.fiveStarButton.selected = YES;
            self.fiveStarLabel.highlighted = YES;
            break;
        default:
            break;
    }
}

- (IBAction)starButtonTapped:(id)sender
{
    if (sender == self.unlimitedButton) {
        self.starLevle = 0;
    }
    else if (sender == self.inexpensiveButton) {
        self.starLevle = 1;
    }
    else if (sender == self.threeStarButton) {
        self.starLevle = 2;
    }
    else if (sender == self.fourStarButton) {
        self.starLevle = 3;
    }
    else {
        self.starLevle = 4;
    }
    
    [self updateStarButtons];
    
    [self.delegate interHotelPriceStarFilter:self starLevelChanged:self.starLevle];
}

- (void)viewTapped:(id)sender
{
    [self.minPriceTextField resignFirstResponder];
    [self.maxPriceTextField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    if ([textField isKindOfClass:[CustomTextField class]]) {
        [textField performSelector:@selector(resetTargetKeyboard)];
    }
    
    if(textField == self.minPriceTextField.textField){
        self.minPriceTextField.numberOfCharacter = 7;
        self.minPriceTextField.abcEnabled = NO;
        [self.minPriceTextField showNumKeyboard];
    }else if(textField == self.maxPriceTextField.textField){
        self.maxPriceTextField.numberOfCharacter = 7;
        self.maxPriceTextField.abcEnabled = NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.minPriceTextField.textField) {
        self.minPrice = [textField.text integerValue];
    }
    else {
        if (textField.text == nil || textField.text.length == 0) {
            self.maxPrice = NSUIntegerMax;
        }
        else {
            self.maxPrice = [textField.text integerValue];
        }
    }
    
    [self.delegate interHotelPriceStarFilter:self priceRangeChangedWithMinPrice:self.minPrice withMaxPrice:self.maxPrice];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *result = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([result length] == 0) return YES; // Allow delete all character which are entered.
    
    if (textField == self.maxPriceTextField.textField) {
        NSString *regex = @"^[1-9][0-9]*$";
        NSPredicate *prd = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        return [prd evaluateWithObject:result];
    }
    else {
        NSString *regex = @"^[0-9]*$";
        NSPredicate *prd = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        return [prd evaluateWithObject:result];
    }
}

@end
