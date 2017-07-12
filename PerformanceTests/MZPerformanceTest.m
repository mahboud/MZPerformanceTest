//
//  MZPerformanceTest.m
//  PerformanceTests
//
//  Created by mahboud on 7/12/17.
//  Copyright © 2017 Optimized. All rights reserved.
//

#import "MZPerformanceTest.h"

@interface MZPerformanceTestUnit : NSObject
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) void(^block)(void);
@property (assign, nonatomic, readonly) uint64_t bestTotalIterationTime;
@property (assign, nonatomic, readonly) uint64_t averageTotalIterationTime;
@property (assign, nonatomic, readonly) int countOfRuns;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithName:(NSString *)name block:(void(^)(void))block NS_DESIGNATED_INITIALIZER;
- (void)addToTotalIterationTime:(uint64_t)time;
@end

@implementation MZPerformanceTestUnit {
  uint64_t _totalIterationTime;
}

- (instancetype)initWithName:(NSString *)name block:(void(^)(void))block {
  self = [super init];
  if (self) {
    _name = name;
    _block = block;
    _bestTotalIterationTime = UINT64_MAX;
  }
  return self;
}

- (void)addToTotalIterationTime:(uint64_t)time {
  if (time < _bestTotalIterationTime)
    _bestTotalIterationTime = time;
  _totalIterationTime += time;
  _countOfRuns++;
}

- (void)clearCounts {
  _totalIterationTime = 0;
  _bestTotalIterationTime = UINT64_MAX;
  _countOfRuns = 0;
}

- (uint64_t)averageTotalIterationTime {
  return (uint64_t)((float) _totalIterationTime / (float)_countOfRuns);
}

@end

uint RandomNumber(NSUInteger max) {
  return arc4random() % max;
}

@implementation MZPerformanceTest {
  NSMutableArray <MZPerformanceTestUnit *>*_perfUnits;
  int _dispatchIterations;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _dispatchIterations = 1;
    _perfUnits = [NSMutableArray arrayWithCapacity:10];
  }
  return self;
}

- (void)addTestNamed:(NSString *)name block:(void(^)(void))block {
  [_perfUnits addObject:[[MZPerformanceTestUnit alloc] initWithName:name block:block]];
}

- (void)clearResults {
  for (MZPerformanceTestUnit *perfUnit in _perfUnits) {
    [perfUnit clearCounts];
  }
}

- (void)removeAllTests {
  [self clearResults];
  [_perfUnits removeAllObjects];
}

- (void)runTestsInRandomOrder:(int)runs {
  NSLog(@"Running tests in random order %d times.", runs);
  NSUInteger count = _perfUnits.count;

  NSMutableArray <NSNumber *>*unOrdered = [NSMutableArray arrayWithCapacity:count];
  NSMutableArray <NSNumber *>*ordered = [NSMutableArray arrayWithCapacity:count];
  for (NSUInteger i = 0; i < count; i++) {
    unOrdered[i] = @(i);
  }
  NSUInteger left = count;
  for (NSUInteger i = 0; i < count; i++) {
    NSUInteger index = RandomNumber(left);
    ordered[i] = unOrdered[index];
    [unOrdered removeObjectAtIndex:index];
    left--;
  }
  _dispatchIterations = runs;
  for (NSNumber *indexNumber in ordered) {
    NSUInteger index = indexNumber.integerValue;
    uint64_t time = [self measureTimeOfBlock:_perfUnits[index].block];
    [_perfUnits[index] addToTotalIterationTime:time];
  }
}

- (void)runTestsSequentially:(int)runs {
  NSLog(@"Running tests one after another, then repeating %d times.", runs);
  _dispatchIterations = 1;
  for (int i = 0; i < runs; i++) {
    for (MZPerformanceTestUnit *perfUnit in _perfUnits) {
      uint64_t time = [self measureTimeOfBlock:perfUnit.block];
      [perfUnit addToTotalIterationTime:time];
    }
  }
}

- (void)runTestsSequentiallyInReverse:(int)runs {
  NSLog(@"Running tests one after another in reverse order, then repeating %d times.", runs);
  _dispatchIterations = 1;
  for (int i = 0; i < runs; i++) {
    for (MZPerformanceTestUnit *perfUnit in _perfUnits.reverseObjectEnumerator.allObjects) {
      uint64_t time = [self measureTimeOfBlock:perfUnit.block];
      [perfUnit addToTotalIterationTime:time];
    }
  }
}

- (void)runTestsIndividually:(int)runs {
  NSLog(@"Running each test %d times, then proceeding to the next test.", runs);
  _dispatchIterations = runs;
  for (MZPerformanceTestUnit *perfUnit in _perfUnits) {
    uint64_t time = [self measureTimeOfBlock:perfUnit.block];
    [perfUnit addToTotalIterationTime:time];
  }
}

- (void)runTestsIndividuallyInReverse:(int)runs {
  NSLog(@"Running each test %d times, then proceeding to next in reverse order.", runs);
  _dispatchIterations = runs;
  for (MZPerformanceTestUnit *perfUnit in _perfUnits.reverseObjectEnumerator.allObjects) {
    uint64_t time = [self measureTimeOfBlock:perfUnit.block];
    [perfUnit addToTotalIterationTime:time];
  }
}


- (NSString *)results {
  NSString *results;
  for (MZPerformanceTestUnit *perfUnit in _perfUnits) {
    int count = perfUnit.countOfRuns;
    results = [NSString stringWithFormat:@"%@ ran %d times: fastest %llu Avg. Runtime: %llu\n", perfUnit.name, count, perfUnit.bestTotalIterationTime, perfUnit.averageTotalIterationTime];
  }
  return results;
}

- (void)log {
  for (MZPerformanceTestUnit *perfUnit in _perfUnits) {
    int count = perfUnit.countOfRuns;
    NSLog(@"%@ ran %d times: fastest %llu Avg. Runtime: %llu", perfUnit.name, count, perfUnit.bestTotalIterationTime, perfUnit.averageTotalIterationTime);
  }
  NSLog(@"---------------------------------------------------------------------");
}

extern uint64_t dispatch_benchmark(size_t count, void (^block)(void));
- (uint64_t)measureTimeOfBlock:(void(^)(void))block {
  uint64_t t = dispatch_benchmark(_dispatchIterations, ^{
    @autoreleasepool {
      block();
    }
  });
  return t;

}
@end
