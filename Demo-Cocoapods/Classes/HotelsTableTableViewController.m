//
//  HotelsTableTableViewController.m
//  Demo-Cocoapods
//
//  Created by Jonathan Provo on 25/08/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "HotelsTableTableViewController.h"

#import "EditHotelTableViewController.h"
#import "HotelTableViewCell.h"
#import "ReviewsTableViewController.h"
#import "WebServiceClient.h"

@interface HotelsTableTableViewController () <WebServiceClientDelegate>

@property (strong, nonatomic) WebServiceClient *webServiceClient;
@property (strong, nonatomic) NSArray *hotels;
@property (strong, nonatomic) Hotel *selectedHotel;

- (id)destinationViewControllerForSegue:(UIStoryboardSegue *)segue;
- (void)deselect;
- (void)deleteSelectedHotel;
- (void)showAlertControllerForOptions;
- (void)showAlertControllerForDeleteConfirmation;

@end

@implementation HotelsTableTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webServiceClient = [WebServiceClient new];
    self.webServiceClient.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.webServiceClient fetchHotels];
    [self deselect];
}

#pragma mark - UIViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    
    id destinationController = [self destinationViewControllerForSegue:segue];
    
    BOOL isDestinationReviews = [destinationController isKindOfClass:[ReviewsTableViewController class]];
    if (self.selectedHotel && isDestinationReviews) {
        ReviewsTableViewController *reviewsTableViewController = destinationController;
        reviewsTableViewController.hotel = self.selectedHotel;
    }
    
    BOOL isDestinationEdit = [destinationController isKindOfClass:[EditHotelTableViewController class]];;
    if (self.selectedHotel && isDestinationEdit) {
        EditHotelTableViewController *editHotelTableViewController = destinationController;
        editHotelTableViewController.hotel = self.selectedHotel;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.hotels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HotelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HotelTableViewCell class]) forIndexPath:indexPath];
    [cell configureForHotel:self.hotels[indexPath.row]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedHotel = nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedHotel = self.hotels[indexPath.row];
    [self showAlertControllerForOptions];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}

#pragma mark - WebServiceClientDelegate

- (void)webServiceClient:(WebServiceClient *)client finishedFetchingWithSuccess:(BOOL)success
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.hotels = client.hotels;
        [self.tableView reloadData];
    });
}

- (void)webServiceClient:(WebServiceClient *)client finishedDeletingWithSuccess:(BOOL)success
{
    [self.webServiceClient fetchHotels];
}

#pragma mark - Private methods

- (id)destinationViewControllerForSegue:(UIStoryboardSegue *)segue
{
    if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = segue.destinationViewController;
        return navigationController.topViewController;
        
    } else {
        return segue.destinationViewController;
    }
}

- (void)deselect
{
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
    self.selectedHotel = nil;
}

- (void)deleteSelectedHotel
{
    [self.webServiceClient deleteHotel:self.selectedHotel];
}

- (void)showAlertControllerForOptions
{
    UIAlertAction *reviewsAction = [UIAlertAction actionWithTitle:@"see its reviews" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self performSegueWithIdentifier:@"Reviews" sender:self];
    }];
    UIAlertAction *editAction = [UIAlertAction actionWithTitle:@"modify this hotel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self performSegueWithIdentifier:@"Edit" sender:self];
    }];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"delete this hotel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [self showAlertControllerForDeleteConfirmation];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self deselect];
    }];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:self.selectedHotel.name message:@"I want to ..." preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:reviewsAction];
    [alertController addAction:editAction];
    [alertController addAction:deleteAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)showAlertControllerForDeleteConfirmation
{
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self deselect];
    }];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [self deleteSelectedHotel];
    }];
    
    NSString *message = [NSString stringWithFormat:@"Are you sure you want to delete '%@' ?", self.selectedHotel.name];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:noAction];
    [alertController addAction:yesAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Navigation

- (IBAction)unwindToHotels:(UIStoryboardSegue *)segue
{
}

@end
