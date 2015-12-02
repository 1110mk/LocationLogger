//
//  StateData.m
//  LocationLogger
//
//  Created by Erin Krentz on 11/13/15.
//  Copyright © 2015 EMK. All rights reserved.
//

#import "StateData.h"

@interface StateData ()

@end

@implementation StateData


- (NSArray *)loadStateData {
    NSMutableArray *stateDataArray = [[NSMutableArray alloc] init];
    
    NSArray *stateNames = @[@"AL", @"AK", @"AZ", @"AR", @"CA", @"CO", @"CT", @"DC", @"DE", @"FL", @"GA", @"HI", @"ID", @"IL", @"IN", @"IA", @"KS", @"KY", @"LA", @"ME", @"MD", @"MA", @"MI", @"MN", @"MS", @"MO",@"MT", @"NE", @"NV", @"NH", @"NJ", @"NM", @"NY", @"NC", @"ND", @"OH", @"OK", @"OR", @"PA", @"RI", @"SC", @"SD", @"TN", @"TX", @"UT", @"VT", @"VA", @"WA", @"WV", @"WI", @"WY"];
    
    for (int i=0; i < 51; i++ ) {
        StateData *stateData = [[StateData alloc] init];
        stateData.stateAbbreviation = stateNames[i];
        stateData.stateCount = @(0) ;
        stateData.statePercentage = @(0.0);
        stateData.stateLocation = [[CLLocation alloc] initWithLatitude:0.0 longitude:0.0];
        [stateDataArray addObject:stateData];
    }
    
    NSLog(@"Number of states: %ld", stateDataArray.count);
    
    NSArray *stateArray = [stateDataArray copy];
    
    return stateArray;
}

@end
