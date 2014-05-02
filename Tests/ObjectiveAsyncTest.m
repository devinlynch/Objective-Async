//
//  QueryChainerTest.m
//
//  Created by Devin Lynch on 2014-04-25.
//  Copyright (c) 2014 Devin Lynch. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ObjectiveAsync.h"

@interface ObjectiveAsyncTest : XCTestCase
{
    ObjectiveAsync *objectiveAsync;
}
@end

@implementation ObjectiveAsyncTest

- (void)setUp
{
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testAsync1
{
    objectiveAsync = [[ObjectiveAsync alloc] init];
    
    NSMutableArray *dataInOrder = [[NSMutableArray alloc] init];
    [objectiveAsync addStepWithBlock:^(objectiveAsyncStepCallback callback) {
        sleep(1);
        callback(nil, @"1");
    } forName:@"first" withCallback:^(NSError *error, id data, NSString *queryName){
        [dataInOrder addObject:data];
    }];
    
    [objectiveAsync addStepWithBlock:^(objectiveAsyncStepCallback callback) {
        callback(nil, @"2");
    } forName:@"second" withCallback:^(NSError *error, id data, NSString *queryName){
        [dataInOrder addObject:data];
    }];
    
    
    [objectiveAsync executeAsync:^(NSError* error, NSDictionary *dic) {
        NSLog(@"Result: %@", dic);
    }];
    
    sleep(2);
    
    XCTAssertEqual([dataInOrder firstObject], @"2");
    XCTAssertEqual([dataInOrder objectAtIndex:1], @"1");
}

- (void)testSeries1
{
    objectiveAsync = [[ObjectiveAsync alloc] init];
    
    NSMutableArray *dataInOrder = [[NSMutableArray alloc] init];
    [objectiveAsync addStepWithBlock:^(objectiveAsyncStepCallback callback) {
        sleep(1);
        callback(nil, @"1");
    } forName:@"first" withCallback:^(NSError *error, id data, NSString *queryName){
        [dataInOrder addObject:data];
    }];
    
    [objectiveAsync addStepWithBlock:^(objectiveAsyncStepCallback callback) {
        callback(nil, @"2");
    } forName:@"second" withCallback:^(NSError *error, id data, NSString *queryName){
        [dataInOrder addObject:data];
    }];
    
    
    [objectiveAsync executeSeries:^(NSError* error, NSDictionary *dic) {
        NSLog(@"Result: %@", dic);
    }];
    
    sleep(2);
    
    XCTAssertEqual([dataInOrder firstObject], @"1");
    XCTAssertEqual([dataInOrder objectAtIndex:1], @"2");
}

@end
