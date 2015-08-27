//
//  ReviewTableViewCell.m
//  Demo-Cocoapods
//
//  Created by Jonathan Provo on 25/08/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "ReviewTableViewCell.h"

@interface ReviewTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;

- (UIColor *)colorForScoreOfReview:(Review *)review;

@end

@implementation ReviewTableViewCell

#pragma mark - Public methods

- (void)configureForReview:(Review *)review withPadding:(CGFloat)padding
{
    self.scoreLabel.text = review.score.stringValue;
    self.scoreLabel.textColor = [self colorForScoreOfReview:review];
    self.textView.text = review.message;
    self.textView.textContainerInset = UIEdgeInsetsMake(padding, padding, padding, padding);
}

#pragma mark - Private methods

- (UIColor *)colorForScoreOfReview:(Review *)review
{
    if (review.score.integerValue < 3) {
        return [UIColor colorWithRed:221.0f/255.0f green:0.0f blue:0.0f alpha:1.0f];;
        
    } else if (review.score.integerValue > 3) {
        return [UIColor colorWithRed:0.0f green:151.0f/255.0f blue:0.0f alpha:1.0f];
        
    } else {
        return [UIColor orangeColor];
    }
}

@end
