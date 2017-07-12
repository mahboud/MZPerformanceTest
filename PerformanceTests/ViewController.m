//
//  ViewController.m
//  PerformanceTests
//
//  Created by mahboud on 7/12/17.
//  Copyright © 2017 Optimized. All rights reserved.
//

#import "ViewController.h"
#import "MZPerformanceTest.h"
#import "NSString+Reverse.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];

  NSString *myString = @"abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz";

  MZPerformanceTest *test = [[MZPerformanceTest alloc] init];

  [test addTestNamed:@"reverse0" block:^void(void) {[myString reverse0];}];
  [test addTestNamed:@"reverse01" block:^void(void) {[myString reverse01];}];
  [test addTestNamed:@"reverse1" block:^void(void) {[myString reverse1];}];
  [test addTestNamed:@"reverse2" block:^void(void) {[myString reverse2];}];
  [test addTestNamed:@"reverse3" block:^void(void) {[myString reverse3];}];
  [test addTestNamed:@"reverse4" block:^void(void) {[myString reverse4];}];
  [test addTestNamed:@"reverse5" block:^void(void) {[myString reverse5];}];

  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [test runTestsIndividually:10];
    [test log];
    [test clearResults];
    [test runTestsIndividuallyInReverse:10];
    [test log];
    [test clearResults];

    [test runTestsIndividually:10000];
    [test log];
    [test clearResults];
    [test runTestsIndividuallyInReverse:10000];
    [test log];
    [test clearResults];


    [test runTestsInRandomOrder:10000];
    [test log];
    [test clearResults];

    [test runTestsInRandomOrder:1];
    [test log];
    [test clearResults];

    [test runTestsInRandomOrder:10];
    [test log];
    [test clearResults];


    [test runTestsSequentially:10000];
    [test log];
    [test clearResults];
    [test runTestsSequentiallyInReverse:10000];
    [test log];
    [test clearResults];

  });
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


@end
