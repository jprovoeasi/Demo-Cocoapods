//
//  Review.h
//  Demo-Cocoapods
//
//  Created by Jonathan Provo on 25/08/15.
//  Copyright (c) 2015. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Review : NSObject

@property (strong, nonatomic) NSNumber *hotelIdentifier;
@property (strong, nonatomic) NSNumber *identifier;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSNumber *score;

@end
