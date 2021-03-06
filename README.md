Objective-Async
===============

A framework for readably performing tasks in parallel or in sequence. 


## Use
The general idea behind this framework is to allow you to execute a set of blocks that go and retrieve data somehow.  You then specify a final callback which will be called once all the blocks are complete with all the data returned.  Please note that the blocks are being performed asynchronously on a seperate thread than where the framework is being called.

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

####Examples

#####Execute in sequence

```objectivec
    ObjectiveAsync *objectiveAsync = [[ObjectiveAsync alloc] init];
    
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
    
    NSLog(@"%@", dataInOrder);
```

The result of this execution would be "(1, 2)".  We are using executeSeries so our blocks are performed in order of when they are defined.  We can see that the first step we defined, our block sleeps for 1 second yet there is no sleep in the second block.  However, the data of the first block was still added to our array before the second block.




#####Execute asynchronously

```objectivec
    ObjectiveAsync *objectiveAsync = [[ObjectiveAsync alloc] init];
    
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
    
    NSLog(@"%@", dataInOrder);
```
The result of this execution would be "(2, 1)".  Since we are using executeAsync: the 2 steps are being performed at the same time.  We have a sleep for 1 second in the first block, so the second block finished executing first.


## Docs

* [`addStepWithBlock:forName:withCallback:`](#addStepWithBlock)
* [`executeSeries:`](#executeSeries)
* [`executeAsync:`](#executeAsync)



<a name="addStepWithBlock" />
### addStepWithBlock:forName:withCallback:
```objectivec
-(void) addStepWithBlock: (objectiveAsyncStepBlock) block forName: (NSString*) name withCallback: (objectiveAsyncPostStepCallback) callback;
```

Add a step to the list that will be executed.

    Parameters:
        block -         The actual block that will get executed.  It must take a objectiveAsyncStepCallback as a parameter and
                        this callback MUST be called from within the block.  Calling this callback with an error not nil will
                        cause the execution of all other steps to be haulted and a call to the final callback.  Calling the callback
                        with no error will cause the data given to be added to the final data dictionary, mapped with the given name
        name -          The name that will be used as the key in the final data dictionary, mapped with the data sent to the callback
                        of the given block
        callback -      An OPTIONAL callback that will be called after successful completion of this step


<a name="executeSeries" />
### executeSeries:
```objectivec
-(void) executeSeries: (objectiveAsyncFinalCallback) finalCallback;
```

In order of the steps that were added, executes each step in series.  In other words, each step only occurs AFTER the previous step successfully completes.



    Parameters:
        finalCallback - This is called once all steps have completed, or when an error was found in one of the steps.  The dictionary will contain the names of the steps mapped with their returned data.


<a name="executeAsync" />
### executeAsync:
```objectivec
-(void) executeAsync: (objectiveAsyncFinalCallback) finalCallback;
```
All the steps added are sent triggered to be called simultaneously.  The final callback will be called once every step has completed or when an error occurs.

    Parameters:
        finalCallback - This is called once all steps have completed, or when an error was found in one of the steps.  The dictionary will contain the names of the steps mapped with their returned data.
                        

Motivation
-----
When trying to execute a set of server calls in order, I found myself having to write way too much code just to handle starting the next call after a successful completion of the prior call.  This looked to messy, so I decided to make this framework to make things more readable.  It turned out to be a lot more useful than just making my code more readable.  The idea was inspired by Caolan McMahon's JavaScript async framework that I had used in the past.


Copyright 2014 Devin Lynch.  Please give me credit if you use this, that's all I ask.
