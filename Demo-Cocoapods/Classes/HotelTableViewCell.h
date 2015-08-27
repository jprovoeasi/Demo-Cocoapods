//
//  HotelTableViewCell.h
//  Demo-Cocoapods
//
//  Created by Jonathan Provo on 25/08/15.
//  Copyright (c) 2015. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Hotel.h"

@interface HotelTableViewCell : UITableViewCell

- (void)configureForHotel:(Hotel *)hotel;

@end
