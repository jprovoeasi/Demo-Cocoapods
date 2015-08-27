//
//  WebServiceClient.m
//  Demo-Cocoapods
//
//  Created by Jonathan Provo on 13/08/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WebServiceClient.h"

#define kAPIBase            @"http://localhost:3000"
#define kAPIPathToHotels    @"hotels"
#define kAPIPathToReviews   @"reviews"

@interface WebServiceClient ()

@property (strong, nonatomic) NSArray *hotels;
@property (strong, nonatomic) NSArray *reviews;

- (NSString *)pathToHotel:(Hotel *)hotel;
- (NSString *)pathToHotels;
- (NSString *)pathToReviewsForHotel:(Hotel *)hotel;
- (NSString *)pathToReviews;

- (NSString *)absolutePathForRelativePath:(NSString *)relativePath;
- (NSDictionary *)parametersForHotel:(Hotel *)hotel;
- (NSDictionary *)parametersForReview:(Review *)review forHotel:(Hotel *)hotel;

- (void)parseHotels:(id)response;
- (void)parseReviews:(id)response;

@end

@implementation WebServiceClient

#pragma mark - Public methods

- (void)fetchHotels
{
    NSString *path = [self pathToHotels];
    
    [self GET:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self parseHotels:responseObject];
        [self.delegate webServiceClient:self finishedFetchingWithSuccess:YES];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.delegate webServiceClient:self finishedFetchingWithSuccess:NO];
    }];
}

- (void)createHotel:(Hotel *)hotel
{
    NSString *path = [self pathToHotels];
    NSDictionary *parameters = [self parametersForHotel:hotel];
    
    [self POST:path parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.delegate webServiceClient:self finishedCreatingWithSuccess:YES];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.delegate webServiceClient:self finishedCreatingWithSuccess:NO];
    }];
}

- (void)updateHotel:(Hotel *)hotel
{
    NSString *path = [self pathToHotel:hotel];
    NSDictionary *parameters = [self parametersForHotel:hotel];
    
    [self PUT:path parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.delegate webServiceClient:self finishedUpdatingWithSuccess:YES];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.delegate webServiceClient:self finishedUpdatingWithSuccess:NO];
    }];
}

- (void)deleteHotel:(Hotel *)hotel
{
    NSString *path = [self pathToHotel:hotel];
    
    [self DELETE:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.delegate webServiceClient:self finishedDeletingWithSuccess:YES];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.delegate webServiceClient:self finishedDeletingWithSuccess:NO];
    }];
}

- (void)fetchReviewsForHotel:(Hotel *)hotel
{
    NSString *path = [self pathToReviewsForHotel:hotel];
    
    [self GET:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self parseReviews:responseObject];
        [self.delegate webServiceClient:self finishedFetchingWithSuccess:YES];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.delegate webServiceClient:self finishedFetchingWithSuccess:NO];
    }];
}

- (void)createReview:(Review *)review forHotel:(Hotel *)hotel
{
    NSString *path = [self pathToReviews];
    NSDictionary *parameters = [self parametersForReview:review forHotel:hotel];
    
    [self POST:path parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.delegate webServiceClient:self finishedCreatingWithSuccess:YES];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.delegate webServiceClient:self finishedCreatingWithSuccess:YES];
    }];
}

#pragma mark - Private methods

#pragma mark - API

- (NSString *)pathToHotel:(Hotel *)hotel
{
    return [[self pathToHotels] stringByAppendingPathComponent:hotel.identifier.stringValue];
}

- (NSString *)pathToHotels
{
    return [self absolutePathForRelativePath:kAPIPathToHotels];
}

- (NSString *)pathToReviewsForHotel:(Hotel *)hotel
{
    return [[self pathToHotel:hotel] stringByAppendingPathComponent:kAPIPathToReviews];
}

- (NSString *)pathToReviews
{
    return [self absolutePathForRelativePath:kAPIPathToReviews];
}

- (NSString *)absolutePathForRelativePath:(NSString *)relativePath
{
    return [kAPIBase stringByAppendingPathComponent:relativePath];
}

- (NSDictionary *)parametersForHotel:(Hotel *)hotel
{
    return @{
             @"name" : hotel.name,
             @"country" : hotel.country,
             @"city" : hotel.city,
             @"price" : hotel.price
             };
}

- (NSDictionary *)parametersForReview:(Review *)review forHotel:(Hotel *)hotel
{
    return @{
             @"hotelId" : hotel.identifier,
             @"message" : review.message,
             @"score" : review.score
             };
}

#pragma mark - Parsing

- (void)parseHotels:(id)response
{
    NSMutableArray *results = [NSMutableArray array];
    
    if ([response isKindOfClass:[NSArray class]]) {
        for (id object in response) {
            if ([object isKindOfClass:[NSDictionary class]]) {
                
                Hotel *hotel = [Hotel new];
                hotel.identifier = object[@"id"];
                hotel.name = object[@"name"];
                hotel.country = object[@"country"];
                hotel.city = object[@"city"];
                hotel.price = object[@"price"];
                hotel.imageURL = object[@"imageURL"];
                
                [results addObject:hotel];
            }
        }
    }
    
    self.hotels = results;
}

- (void)parseReviews:(id)response
{
    NSMutableArray *results = [NSMutableArray array];
    
    if ([response isKindOfClass:[NSArray class]]) {
        for (id object in response) {
            if ([object isKindOfClass:[NSDictionary class]]) {
                
                Review *review = [Review new];
                review.identifier = object[@"id"];
                review.hotelIdentifier = object[@"hotelId"];
                review.message = object[@"message"];
                review.score = object[@"score"];
                
                [results addObject:review];
            }
        }
    }
    
    self.reviews = results;
}

@end
