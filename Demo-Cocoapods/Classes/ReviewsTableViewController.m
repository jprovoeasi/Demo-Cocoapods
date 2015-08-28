//
//  ReviewsTableViewController.m
//  Demo-Cocoapods
//
//  Created by Jonathan Provo on 25/08/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "ReviewsTableViewController.h"

#import "EditReviewTableViewController.h"
#import "ReviewTableViewCell.h"
#import "WebServiceClient.h"

#define kScoreHeight 30.0f
#define kTextViewPadding 10.0f

@interface ReviewsTableViewController () <WebServiceClientDelegate>

@property (strong, nonatomic) WebServiceClient *webServiceClient;
@property (strong, nonatomic) NSArray *reviews;

- (id)destinationViewControllerForSegue:(UIStoryboardSegue *)segue;

@end

@implementation ReviewsTableViewController

#pragma mark - Lifecycle methods

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.webServiceClient fetchReviewsForHotel:self.hotel];
}

#pragma mark - UIViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    
    id destinationController = [self destinationViewControllerForSegue:segue];
    BOOL isDestinationEditReview = [destinationController isKindOfClass:[EditReviewTableViewController class]];
    
    if (isDestinationEditReview) {
        EditReviewTableViewController *editReviewTableViewController = destinationController;
        editReviewTableViewController.hotel = self.hotel;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.reviews.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ReviewTableViewCell class]) forIndexPath:indexPath];
    [cell configureForReview:self.reviews[indexPath.row] withPadding:kTextViewPadding];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Review *review = self.reviews[indexPath.row];
    
    NSDictionary *attributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:17.0f] };
    CGSize maxSize = CGSizeMake(CGRectGetWidth(tableView.frame) - (2 * kTextViewPadding), NSIntegerMax);
    CGRect boundingRect = [review.message boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    
    return kScoreHeight + boundingRect.size.height + (2 * kTextViewPadding) + 1.0f;
}

#pragma mark - WebServiceClientDelegate

- (void)webServiceClient:(WebServiceClient *)client finishedFetchingWithSuccess:(BOOL)success
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.reviews = client.reviews;
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
    });
}

#pragma mark - Private methods

- (WebServiceClient *)webServiceClient
{
    if (!_webServiceClient) {
        _webServiceClient = [WebServiceClient new];
        _webServiceClient.delegate = self;
    }
    
    return _webServiceClient;
}

- (id)destinationViewControllerForSegue:(UIStoryboardSegue *)segue
{
    if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = segue.destinationViewController;
        return navigationController.topViewController;
        
    } else {
        return segue.destinationViewController;
    }
}

#pragma mark - IBAction

- (IBAction)refresh:(UIRefreshControl *)sender
{
    [self.webServiceClient fetchReviewsForHotel:self.hotel];
}

#pragma mark - Navigation

- (IBAction)unwindToReviews:(UIStoryboardSegue *)segue
{
}

@end
