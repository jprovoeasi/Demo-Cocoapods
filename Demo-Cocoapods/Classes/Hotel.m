//
//  Hotel.m
//  Demo-Cocoapods
//
//  Created by Jonathan Provo on 13/08/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "Hotel.h"

@implementation Hotel

#pragma mark - NSObject protocol

- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[Hotel class]]) {
        Hotel *otherHotel = object;
        return self.identifier.integerValue == otherHotel.identifier.integerValue;
        
    } else {
        return [super isEqual:object];
    }
}

@end
