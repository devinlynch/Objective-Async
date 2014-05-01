Objective-Async
===============

A framework for readably performing tasks in parallel or in sequence. 


Use
-----
    ObjectiveAsync *objectiveAsync = [[ObjectiveAsync alloc] init];
    
    [objectiveAsync addStepWithBlock:^(objectiveAsyncStepCallback callback) {
        callback(nil, @"1");
    } forName:@"first" withCallback:nil];
    
    [objectiveAsync addStepWithBlock:^(objectiveAsyncStepCallback callback) {
        callback(nil, @"2");
    } forName:@"second" withCallback:nil];
    
    [objectiveAsync executeSeries:^(NSError* error, NSDictionary *dic) {
        NSLog(@"Result: %@", dic);
        // Result: {
        //    first = 1;
        //    second = 2;
        // }
    }];
    
