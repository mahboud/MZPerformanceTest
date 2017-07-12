//
//  MZPerformanceTest.h
//  PerformanceTests
//
//  Created by mahboud on 7/12/17.
//  Copyright © 2017 Optimized. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MZPerformanceTest : NSObject

- (void)addTestNamed:(NSString *)name block:(void(^)(void))block;
- (void)clearResults;
- (void)removeAllTests;
- (void)runTestsInRandomOrder:(int)runs;
- (void)runTestsSequentially:(int)runs;
- (void)runTestsSequentiallyInReverse:(int)runs;
- (void)runTestsIndividually:(int)runs;
- (void)runTestsIndividuallyInReverse:(int)runs;
- (NSString *)results;
- (void)log;

@end
