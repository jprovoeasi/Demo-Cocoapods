//
//  HotelTableViewCell.m
//  Demo-Cocoapods
//
//  Created by Jonathan Provo on 25/08/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "HotelTableViewCell.h"

@interface HotelTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@property (strong, nonatomic) Hotel *hotel;

- (NSString *)formatPrice:(NSNumber *)price;

@end

@implementation HotelTableViewCell

#pragma mark - UITableViewCell

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.thumbnailImageView.image = nil;
    [self.activityIndicatorView startAnimating];
}

#pragma mark - Public methods

- (void)configureForHotel:(Hotel *)hotel
{
    self.hotel = hotel;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *imageURL = [NSURL URLWithString:hotel.imageURL];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage *image = [UIImage imageWithData:imageData];

        dispatch_async(dispatch_get_main_queue(), ^{
            if ([hotel isEqual:self.hotel]) {
                [self.activityIndicatorView stopAnimating];
                self.thumbnailImageView.image = image;
            }
        });
    });
    
    self.nameLabel.text = hotel.name;
    self.locationLabel.text = [NSString stringWithFormat:@"%@, %@", hotel.city, hotel.country];
    self.priceLabel.text = [self formatPrice:hotel.price];
}

#pragma mark - Private methods

- (NSString *)formatPrice:(NSNumber *)price
{
    NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
    numberFormatter.minimumFractionDigits = 2;
    numberFormatter.maximumFractionDigits = 2;

    return [NSString stringWithFormat:@"€ %@", [numberFormatter stringFromNumber:price]];
}

@end
