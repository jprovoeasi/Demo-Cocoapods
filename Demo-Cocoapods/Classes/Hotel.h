//
//  Hotel.h
//  Demo-Cocoapods
//
//  Created by Jonathan Provo on 13/08/15.
//  Copyright (c) 2015. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Hotel : NSObject

@property (strong, nonatomic) NSNumber *identifier;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSNumber *price;
@property (strong, nonatomic) NSString *imageURL;

@end
