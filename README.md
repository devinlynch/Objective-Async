Objective-Async
===============

A framework for readably performing tasks in parallel or in sequence. 


Use
-----
    chainer = [[ObjectiveAsync alloc] init];
      
    [chainer addStepWithBlock:^(objectiveAsyncStepCallback callback) {
        callback(nil, @"1");
    } forName:@"first" withCallback:nil];
    
    [chainer addStepWithBlock:^(objectiveAsyncStepCallback callback) {
        callback(nil, @"2");
    } forName:@"second" withCallback:nil];
    
    [chainer executeSeries:^(NSError* error, NSDictionary *dic) {
        NSLog(@"Result: %@", dic);
        // Result: {
        //    first = 1;
        //    second = 2;
        // }
    }];
    
