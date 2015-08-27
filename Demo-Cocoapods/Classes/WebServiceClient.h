//
//  WebServiceClient.h
//  Demo-Cocoapods
//
//  Created by Jonathan Provo on 13/08/15.
//  Copyright (c) 2015. All rights reserved.
//

#import <AFNetworking/AFHTTPSessionManager.h>

#import "Hotel.h"
#import "Review.h"

@class WebServiceClient;

@protocol WebServiceClientDelegate

@optional
- (void)webServiceClient:(WebServiceClient *)client finishedFetchingWithSuccess:(BOOL)success;
- (void)webServiceClient:(WebServiceClient *)client finishedCreatingWithSuccess:(BOOL)success;
- (void)webServiceClient:(WebServiceClient *)client finishedUpdatingWithSuccess:(BOOL)success;
- (void)webServiceClient:(WebServiceClient *)client finishedDeletingWithSuccess:(BOOL)success;

@end

@interface WebServiceClient : AFHTTPSessionManager

@property (weak, nonatomic) id<WebServiceClientDelegate> delegate;
@property (strong, nonatomic, readonly) NSArray *hotels;
@property (strong, nonatomic, readonly) NSArray *reviews;

- (void)fetchHotels;
- (void)createHotel:(Hotel *)hotel;
- (void)updateHotel:(Hotel *)hotel;
- (void)deleteHotel:(Hotel *)hotel;

- (void)fetchReviewsForHotel:(Hotel *)hotel;
- (void)createReview:(Review *)review forHotel:(Hotel *)hotel;

@end
