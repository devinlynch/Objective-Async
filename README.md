Objective-Async
===============

A framework for readably performing tasks in parallel or in sequence. 


Use
-----
The general idea behind this framework is to allow you to execute a set of blocks that go and retrieve data somehow.  You then specify a final callback which will be called once all the blocks are complete with all the data returned.

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
    
Motivation
-----
When trying to execute a set of server calls in order, I found myself having to write way too much code just to handle starting the next call after a successful completion of the prior call.  This looked to messy, so I decided to make this framework to make things more readable.  It turned out to be a lot more useful than just making my code more readable.


Copyright 2014 Devin Lynch.  Please give me credit if you use this, that's all I ask.
