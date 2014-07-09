//
//  GrouponPriceFilterController.m
//  ElongClient
//
//  Created by 赵 岩 on 13-9-1.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "GrouponPriceFilterController.h"

@interface GrouponPriceFilterController ()

@end

@implementation GrouponPriceFilterController

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
    
    self.minPriceTextField.numberOfCharacter = 7;
    [self.minPriceTextField showNumKeyboard];
    self.minPriceTextField.delegate = self;
    self.minPriceTextField.textFont = FONT_16;
    self.minPriceTextField.placeholder =  @"0";
    self.minPriceTextField.textField.clearButtonMode = UITextFieldViewModeNever;
    
    self.maxPriceTextField.numberOfCharacter = 7;
    [self.maxPriceTextField showNumKeyboard];
    self.maxPriceTextField.delegate = self;
    self.maxPriceTextField.textFont = FONT_16;
    self.maxPriceTextField.placeholder =  @"不限";
    self.maxPriceTextField.textField.clearButtonMode = UITextFieldViewModeNever;
    
    UITapGestureRecognizer *tapRecognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)] autorelease];
    tapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapRecognizer];
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
    
    [self.delegate grouponPriceFilter:self priceRangeChangedWithMinPrice:self.minPrice withMaxPrice:self.maxPrice];
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
