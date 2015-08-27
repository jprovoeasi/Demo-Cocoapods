//
//  ReviewTableViewCell.h
//  Demo-Cocoapods
//
//  Created by Jonathan Provo on 25/08/15.
//  Copyright (c) 2015. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Review.h"

@interface ReviewTableViewCell : UITableViewCell

- (void)configureForReview:(Review *)review withPadding:(CGFloat)padding;

@end
