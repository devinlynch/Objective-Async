Objective-Async
===============

A framework for readably performing tasks in parallel or in sequence. 


## Use
The general idea behind this framework is to allow you to execute a set of blocks that go and retrieve data somehow.  You then specify a final callback which will be called once all the blocks are complete with all the data returned.

#### Steps
1. Create a new instance of ObjectiveAsync
```objectivec
ObjectiveAsync *objectiveAsync = [[ObjectiveAsync alloc] init];
```

2. Add a step to the sequence of steps that will be executed.  Each step needs a block that will actually get executed and a name that is unique to the step.  The block given MUST call the callback at some point with either an error or non-nil data.  You can optionally also give a callback which will be called once this specific step completes.
```objectivec
[objectiveAsync addStepWithBlock:^(objectiveAsyncStepCallback callback) {
    callback(nil, @"1");
} forName:@"first" withCallback:nil];
```

3. Call either executeSeries: or executeAsync:.  Execute series will perform each step in sequence of when they were added.  Or, in other words, it executes each step only after the previous added step has completed.  Execute async will execute steps simutaniously and there is no guaranteed order of execution.  This method is usually faster if order is not important.  You also must give a callback that will be called once all steps have completed or if an error is given to any of the callbacks of the steps.  The data NSDictionary of the final callback will have the names of each step mapped with the data that they gave to their callbacks.

executeSeries:
```objectivec
[objectiveAsync executeSeries:^(NSError* error, NSDictionary *dic) {
    NSLog(@"Result: %@", dic);
}];
```

executeAsync:
```objectivec
[objectiveAsync executeAsync:^(NSError* error, NSDictionary *dic) {
    NSLog(@"Result: %@", dic);
}];
```

```objectivec
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
```
    
Motivation
-----
When trying to execute a set of server calls in order, I found myself having to write way too much code just to handle starting the next call after a successful completion of the prior call.  This looked to messy, so I decided to make this framework to make things more readable.  It turned out to be a lot more useful than just making my code more readable.


Copyright 2014 Devin Lynch.  Please give me credit if you use this, that's all I ask.
