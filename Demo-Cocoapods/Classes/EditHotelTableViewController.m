//
//  EditHotelTableViewController.m
//  Demo-Cocoapods
//
//  Created by Jonathan Provo on 25/08/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "EditHotelTableViewController.h"

#import "Hotel.h"
#import "WebServiceClient.h"

#define kEuroSignPrefix @"€ "

@interface EditHotelTableViewController () <UITextFieldDelegate, WebServiceClientDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UITextField *countryTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;

@property (assign, nonatomic, readonly) BOOL editing;

- (BOOL)hasErrors;
- (void)showError;

- (Hotel *)createHotel;
- (Hotel *)updateHotel;
- (void)setDataForHotel:(Hotel *)hotel;

@end

@implementation EditHotelTableViewController

#pragma mark - Lifecycle methods

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.editing) {
        self.nameTextField.text = self.hotel.name;
        self.cityTextField.text = self.hotel.city;
        self.countryTextField.text = self.hotel.country;
        self.priceTextField.text = [kEuroSignPrefix stringByAppendingString:self.hotel.price.stringValue];
        
        self.navigationItem.title = @"Modify hotel";
        
    } else {
        self.navigationItem.title = @"New hotel";
    }
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.priceTextField]) {
        if (![textField.text hasPrefix:kEuroSignPrefix]) {
            textField.text = [kEuroSignPrefix stringByAppendingString:textField.text];
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField isEqual:self.priceTextField]) {
        if ([textField.text isEqualToString:kEuroSignPrefix]) {
            textField.text = @"";
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:self.nameTextField]) {
        [self.cityTextField becomeFirstResponder];
        
    } else if ([textField isEqual:self.cityTextField]) {
        [self.countryTextField becomeFirstResponder];
        
    } else if ([textField isEqual:self.countryTextField]) {
        [self.priceTextField becomeFirstResponder];
    
    } else {
        [textField resignFirstResponder];
    }
    
    return YES;
}

#pragma mark - WebServiceClientDelegate

- (void)webServiceClient:(WebServiceClient *)client finishedCreatingWithSuccess:(BOOL)success
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (success) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self showError];
        }
    });
}

- (void)webServiceClient:(WebServiceClient *)client finishedUpdatingWithSuccess:(BOOL)success
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (success) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self showError];
        }
    });
}

#pragma mark - IBActions

- (IBAction)save:(UIBarButtonItem *)sender
{
    if ([self hasErrors]) {
        [self showError];
        
    } else {
        WebServiceClient *webServiceClient = [WebServiceClient new];
        webServiceClient.delegate = self;
        
        if (self.editing) {
            Hotel *hotel = [self updateHotel];
            [webServiceClient updateHotel:hotel];
            
        } else {
            Hotel *hotel = [self createHotel];
            [webServiceClient createHotel:hotel];
        }
    }
}

#pragma mark - Private methods

- (BOOL)editing
{
    return self.hotel != nil;
}

- (BOOL)hasErrors
{
    BOOL isValid = self.nameTextField.text.length > 0 && self.cityTextField.text.length > 0 && self.countryTextField.text.length > 0 && self.priceTextField.text.length > 0;
    return !isValid;
}

- (void)showError
{
    NSString *title = @"Oops";
    NSString *message = @"Something went wrong... Please try again later.";
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
}

- (Hotel *)createHotel
{
    Hotel *hotel = [Hotel new];
    [self setDataForHotel:hotel];
    
    return hotel;
}

- (Hotel *)updateHotel
{
    [self setDataForHotel:self.hotel];
    return self.hotel;
}

- (void)setDataForHotel:(Hotel *)hotel
{
    hotel.name = self.nameTextField.text;
    hotel.city = self.cityTextField.text;
    hotel.country = self.countryTextField.text;
    hotel.price = @([[self.priceTextField.text stringByReplacingOccurrencesOfString:kEuroSignPrefix withString:@""] floatValue]);
}

@end
