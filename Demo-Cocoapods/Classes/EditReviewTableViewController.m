//
//  EditReviewTableViewController.m
//  Demo-Cocoapods
//
//  Created by Jonathan Provo on 27/08/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "EditReviewTableViewController.h"

#import "WebServiceClient.h"

@interface EditReviewTableViewController () <UITextFieldDelegate, WebServiceClientDelegate>

@property (weak, nonatomic) IBOutlet UITextField *scoreTextField;
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;

- (BOOL)hasErrors;
- (void)showError;

@end

@implementation EditReviewTableViewController

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 44.0f;
    } else {
        return 250.0f;
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSArray *allowedCharacters = @[ @"0", @"1", @"2", @"3", @"4", @"5" ];
    
    BOOL isValidCharacter = [allowedCharacters containsObject:string];
    BOOL isValidLength = textField.text.length < 1;
    BOOL isDeletion = string.length == 0;
    
    return (isValidCharacter && isValidLength) || isDeletion;
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

#pragma mark - IBActions

- (IBAction)save:(UIBarButtonItem *)sender
{
    if ([self hasErrors]) {
        [self showError];
        
    } else {
        Review *review = [Review new];
        review.message = self.messageTextView.text;
        review.score = @(self.scoreTextField.text.integerValue);
        
        WebServiceClient *webServiceClient = [WebServiceClient new];
        webServiceClient.delegate = self;
        [webServiceClient createReview:review forHotel:self.hotel];
    }
}

#pragma mark - Private methods

- (BOOL)hasErrors
{
    BOOL isValid = self.scoreTextField.text.length > 0 && self.messageTextView.text.length > 0;
    return !isValid;
}

- (void)showError
{
    NSString *title = @"Oops";
    NSString *message = @"Something went wrong... Please try again later.";
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
}

@end
