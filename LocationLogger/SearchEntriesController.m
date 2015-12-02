//
//  SearchEntriesController.m
//  LocationLogger
//
//  Created by Erin Krentz on 11/18/15.
//  Copyright © 2015 EMK. All rights reserved.
//

#import "SearchEntriesController.h"

@implementation SearchEntriesController


//This method sorts the entries by the date and then by part of day
+ (NSMutableArray *)sortAllTheEntriesByDate: (NSArray *)entriesToSort {
    
    //Create a mutable array to work with inside the method
    NSMutableArray *sortedLocalEntries = [[NSMutableArray alloc] initWithArray:entriesToSort];
    
    //Now sort the date by the timestamp
    NSSortDescriptor *sortDate = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO];
    NSSortDescriptor *sortPartOfDay = [NSSortDescriptor sortDescriptorWithKey:@"partOfDay" ascending:YES];
    [sortedLocalEntries sortUsingDescriptors:@[sortDate,sortPartOfDay]];
    return sortedLocalEntries;
}

//This method sorts the entries alphabetically by state then by day; other countries are put at the end
+ (NSMutableArray *)sortAllTheEntriesByState: (NSArray *)entriesToSort {

    //Create a mutable array of local entries to work with inside the method
    NSMutableArray *sortedLocalEntries = [[NSMutableArray alloc] initWithArray:entriesToSort];
    
    NSSortDescriptor *sortDate = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO];
    NSSortDescriptor *sortPartOfDay = [NSSortDescriptor sortDescriptorWithKey:@"partOfDay" ascending:YES];
   //Now sort the data by the state name
    NSSortDescriptor *sortState = [NSSortDescriptor sortDescriptorWithKey:@"placemark.administrativeArea" ascending:NO];
    NSSortDescriptor *sortCountry = [NSSortDescriptor sortDescriptorWithKey:@"placemark.country" ascending:NO];
    
    
    [sortedLocalEntries sortUsingDescriptors:@[sortCountry, sortState, sortDate, sortPartOfDay]];
    return sortedLocalEntries;
}

//This method sorts the entries by the states with the greatest percent
//Each day has 3 timestamps. You need to figure out which state wins.

+ (NSMutableArray *)sortAllTheEntriesByPercent: (NSArray *)entriesToSort {
    
    
    //Create a mutable array to work with inside this View Controller; this has every day with possibly 3 locations
    //You need this because you have to change the entries
    
    
    //create the array of states, the count, and the percentage
    // You need to keep track of each day in a particular state
    // Use the StateData class to have name, daily count, percentage
    // This only had 50 entries, one for each state
    
    NSMutableArray *stateDataArray = [[NSMutableArray alloc] init];
    
    NSArray *stateNames = @[@"AL", @"AK", @"AZ", @"AR", @"CA", @"CO", @"CT", @"DE", @"DC", @"FL", @"GA", @"HI", @"ID", @"IL", @"IN", @"IA", @"KS", @"KY", @"LA", @"ME", @"MD", @"MA", @"MI", @"MN", @"MS", @"MO",@"MT", @"NE", @"NV", @"NH", @"NJ", @"NM", @"NY", @"NC", @"ND", @"OH", @"OK", @"OR", @"PA", @"RI", @"SC", @"SD", @"TN", @"TX", @"UT", @"VT", @"VA", @"WA", @"WV", @"WI", @"WY"];
    
//    NSArray *stateLongNames =[
//                                                          @"Alabama",
//                                                          @"Alaska",
//                                                          @"Arizona",
//                                                          @"Arkansas",
//                                                          @"California",
//                                                          @"Colorado",
//                                                          @"Connecticut",
//                                                          @"Delaware",
//                                                          @"District of Columbia",
//                                                          @"Florida",
//                                                          @"Georgia",
//                                                          @"Hawaii",
//                                                          @"Idaho",
//                                                          @"Illinois",
//                                                          @"Indiana",
//                                                          @"Iowa",
//                                                          @"Kansas",
//                                                          @"Kentucky",
//                                                          @"Louisiana",
//                                                          @"Maine",
//                                                          @"Maryland",
//                                                          @"Massachusetts",
//                                                          @"Michigan",
//                                                          @"Minnesota",
//                                                          @"Mississippi",
//                                                          @"Missouri",
//                                                          @"Montana",
//                                                          @"Nebraska",
//                                                          @"Nevada",
//                                                          @"New Hampshire",
//                                                          @"New Jersey",
//                                                          @"New Mexico",
//                                                          @"New York",
//                                                          @"North Carolina",
//                                                          @"North Dakota",
//                                                          @"Ohio",
//                                                          @"Oklahoma",
//                                                          @"Oregon",
//                                                          @"Pennsylvania",
//                                                          @"Rhode Island",
//                                                          @"South Carolina",
//                                                          @"South Dakota",
//                                                          @"Tennessee",
//                                                          @"Texas",
//                                                          @"Utah",
//                                                          @"Vermont",
//                                                          @"Virginia",
//                                                          @"Washington",
//                                                          @"West Virginia",
//                                                          @"Wisconsin",
//                                                            @"Wyoming"];
    
    
    for (int i=0; i < 51; i++ ) {
        StateData *stateData = [[StateData alloc] init];
        stateData.stateAbbreviation = stateNames[i];
        
        // initialize the counts to Zero for below
        stateData.stateCount = @(0) ;
        stateData.statePercentage = @(0.0);
        stateData.stateLocation = [[CLLocation alloc] initWithLatitude:0.0 longitude:0.0];
        [stateDataArray addObject:stateData];
    }
    
    NSLog(@"\n\n\nNumber of states:\n   %ld \n", stateDataArray.count);
    
    //At this point in the program, you have 3 arrays
    //  1) entriesToSort which was sent to the method
    //  2) sortedLocalEntries, which is a mutable copy
    //  3) stateDataArray, which has all 50 states
    
    //Now for each day you need to pick a state
    //Find the possibly 3 entries for a day
    
    
    //**** Get only one entry for each day
    //This is the array with just one Entry per day
    NSMutableArray *justOneEntryPerDay = [[NSMutableArray alloc] init];
    
    //Create a mutable array to work with inside the method
    NSMutableArray *sortedLocalEntries = [[NSMutableArray alloc] initWithArray:entriesToSort];
    
    //Now sort the date by the timestamp
    NSSortDescriptor *sortDate = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO];
    NSSortDescriptor *sortPartOfDay = [NSSortDescriptor sortDescriptorWithKey:@"partOfDay" ascending:NO];
    [sortedLocalEntries sortUsingDescriptors:@[sortDate,sortPartOfDay]];
    
    for (Entry *logEntry in sortedLocalEntries) {
        NSLog(@"\n\n Entry: \n%@, \n%@, \n%@, \n%@: \n\n", logEntry.placemark.administrativeArea, logEntry.placemark.locality, logEntry.timestamp, logEntry.partOfDay );
    }

    
    
    //The first loop is through the entire database
    for (int i = 0; i < (sortedLocalEntries.count - 1); i++) { //don't check past the array
        Entry *firstTimeEntry = sortedLocalEntries[i];
        
        //Get date components to compare days
        NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSCalendarUnit units = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
        
        //These date components are from the Entries sent into the method
        NSDateComponents *firstComponents = [calendar components:units fromDate:firstTimeEntry.timestamp];
        
        NSLog(@"\n\nFirstTimeEntry i = :%d %ld %ld %ld\n\n", i, (long)[firstComponents month], (long)[firstComponents day], (long)[firstComponents year]);
        
        //Check if there is another day
        if ((sortedLocalEntries.count - i) > 1) {
        
        
            //See if there is a matching Day in the array. You just need to look at the next two entries.
            Entry *secondTimeEntry = sortedLocalEntries[i+1];
            
            //Get the date components of Day 2
            
            //Get date components to compare days
            NSCalendar *secondCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSCalendarUnit secondUnits = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
            
            //These date components are from the Entries sent into the method
            NSDateComponents *secondComponents = [secondCalendar components:secondUnits fromDate:secondTimeEntry.timestamp];
                
            NSLog(@"\n\nSecondTimeEntry i+1 = :%d %ld %ld %ld\n\n", i+1, (long)[secondComponents month], (long)[secondComponents day], (long)[secondComponents year]);

            
            if (([secondComponents year] == [firstComponents year]) && ([secondComponents month] == [secondComponents month]) &&([secondComponents day] == [firstComponents day]))    {
                    
                NSLog(@"Two Entries Match. Right after checking components");
                        
                //now you have two matching days called Day1 and Day2
                //See if the next entry in the array matches
                if ((sortedLocalEntries.count -  i) > 2) {  //don't check past end of array
                        
                    NSLog(@"Two Entries Match & Another Entry in Array.");
                                
                    Entry *thirdTimeEntry = sortedLocalEntries[i+2];
                                    
                    //Get date components to compare days
                    NSCalendar *thirdCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                    NSCalendarUnit thirdUnits = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
                                        
                    //These date components are from the Entries sent into the method
                    NSDateComponents *thirdComponents = [thirdCalendar components:thirdUnits fromDate:thirdTimeEntry.timestamp];
                                    
                    NSLog(@"\n\nThirdTimeEntry i+2 = :%d %ld %ld %ld\n\n", i+2, (long)[thirdComponents month], (long)[thirdComponents day], (long)[thirdComponents year]);

                                
                    if (([thirdComponents year] == [firstComponents year])  && ([thirdComponents month] == [firstComponents month]) && ([thirdComponents day] == [firstComponents day])) {
                                            
                        //now you have three matching days: Day 1, Day 2, and Day 3
                        //Check if the states are the same
                        //If 2 or 3 of the days have the same state, keep that Entry
                        //If all 3 days have different states, keep the First Entry
                        if ([thirdTimeEntry.placemark.administrativeArea isEqualToString:firstTimeEntry.placemark.administrativeArea]) {
                                                        
                            NSLog(@"\n]nIn Search Entries Three matching days. %d %d %d 1 & 3 states match.%@, %@\n\n", i, i+1, i+2, thirdTimeEntry.placemark.administrativeArea, firstTimeEntry.placemark.administrativeArea);
                                                
                            //Entries 1 and 3 match; if 2 out of 3 match, set the state
                            //set the location
                            [justOneEntryPerDay addObject:firstTimeEntry];
                            i = i + 2;
                                                
                        } else if ([thirdTimeEntry.placemark.administrativeArea isEqualToString:secondTimeEntry.placemark.administrativeArea]) {
                                                    
                            NSLog(@"\n\nIn Search Entries Three matching days. %d %d %d 2  & 3 states match.%@, %@\n\n", i, i+1, i+2, thirdTimeEntry.placemark.administrativeArea, secondTimeEntry.placemark.administrativeArea);
                                                    
                            //Entries 2 and 3 match; if 2 out of 3 match, set the state
                                        //set the location
                            [justOneEntryPerDay addObject:secondTimeEntry];
                            i = i + 2;
                                                
                        } else if ([firstTimeEntry.placemark.administrativeArea isEqualToString:secondTimeEntry.placemark.administrativeArea]) {
                                    
                            NSLog(@"\n\nIn Search Entries Three matching days. %d %d %d 1  & 2 states match.%@, %@\n\n", i, i+1, i+2, firstTimeEntry.placemark.administrativeArea, secondTimeEntry.placemark.administrativeArea);
                                    
                            //Entries 1 and 2 match; if 2 out of 3 match, set the state
                                        //set the location
                            [justOneEntryPerDay addObject:secondTimeEntry];
                            i = i + 2;
                                
                        } else {
                                                    
                            NSLog(@"\n\nIn Search Entries Three matching days.None of the States Match. %d %d %d %@, %@, %@\n\n", i, i+1, i+2, firstTimeEntry.placemark.administrativeArea, secondTimeEntry.placemark.administrativeArea, thirdTimeEntry.placemark.administrativeArea);
                            
                            //Each state is different
                            //for right now pick the first location
                            [justOneEntryPerDay addObject:firstTimeEntry];
                            i = i + 2;
                                                
                        } // end of all 3 matching days options
                                    
                    } else { //The 3 days DO NOT MATCH
                        
                        NSLog(@"Two entries match, but not the third");
                        //Two days match but not the third day in the array
                        
                        //If the first two matching days also match state location, just set the location
                        if ([firstTimeEntry.placemark.administrativeArea isEqualToString:secondTimeEntry.placemark. administrativeArea]) {
                            
                            NSLog(@"\n\nIn Search Entries; States 1 and 2 match, NOT state 3;\n\n FirstTimeEntry State%@\n\n, second TimeEntry State %@\n\n", firstTimeEntry.placemark.administrativeArea, secondTimeEntry.placemark.administrativeArea);
                            
                            //Day 1 and Day 2 match with state so set the location
                            [justOneEntryPerDay addObject:firstTimeEntry];
                            i = i + 1;
                            
                        } else {
                            //Day 1 and Day 2 states don't match
                            //For now, pick the first state
                        
                            NSLog(@"\n\nIn Search Entries; None of the states match; FirstTimeEntry State%@\n SecondTimeEntry State%@\n\n", firstTimeEntry.placemark.administrativeArea, secondTimeEntry.placemark.administrativeArea);
                            
                            
                            [justOneEntryPerDay addObject:firstTimeEntry];
                            i = i + 1;
                            
                        } //checking two matching day entries for the matching states
                        
                    } //end of 3 days do NOT MATCH

                        
                } else {  //2 days match but no more in array.
                                    
                        //Check if the states match for later on. Right now just take the first state if
                        //     they don't match.
                        
                        //If the first two matching days also match state location, just set the location
                        if ([firstTimeEntry.placemark.administrativeArea isEqualToString:secondTimeEntry.placemark. administrativeArea]) {
                            
                            NSLog(@"\n\nIn Search Entries; States 1 and 2 match. At end of array so no state 3;\n\n FirstTimeEntry State%@\n\n, second TimeEntry State %@\n\n", firstTimeEntry.placemark.administrativeArea, secondTimeEntry.placemark.administrativeArea);
                       
                            // pick the first entry because both entries are the same
                            [justOneEntryPerDay addObject:firstTimeEntry];
                            i = i + 1;
                            
                        } else {
                            
                            NSLog(@"\n\nIn Search Entries; States 1 and 2 DO NOT match. At end of array so no state 3;\n\n FirstTimeEntry State%@\n\n, second TimeEntry State %@\n\n", firstTimeEntry.placemark.administrativeArea, secondTimeEntry.placemark.administrativeArea);
                            
                            //save first entry
                            [justOneEntryPerDay addObject:firstTimeEntry];
                            i = i + 1;
                            
                        }
                    
                } //End of if 3 days left
                
            } else { // 2 Days left in the array, but the days DO NOT MATCH
            
                //store the first Entry
                [justOneEntryPerDay addObject:firstTimeEntry];
                
            }
            
                        
        } else { // only one day left; add the entry
            
            [justOneEntryPerDay addObject:firstTimeEntry];
            
        } // End of loop if only 1 day left in array
        
    }//for loop through the sortedLocalEntries array
    
    for (Entry *logEntry in justOneEntryPerDay) {
            NSLog(@"\n\n Entry: \n%@, \n%@, \n%@, \n%@: \n\n", logEntry.placemark.administrativeArea, logEntry.placemark.locality,logEntry.timestamp, logEntry.partOfDay );
        
    }

    //***** Now that you have the justOneEntryPerDay array with no more than one location per day,
     //     you can start counting the states
    int i = 0;
    NSLog(@"\n\n justOneEntryPerDay Count:  %ld\n\n", justOneEntryPerDay.count);
    for (Entry *entry in justOneEntryPerDay) {
        NSLog(@"\n\n Entry: %@\n\n ", entry.placemark.administrativeArea);
    }
    
    for (Entry *entry in justOneEntryPerDay) {
        
        NSLog(@"\n\nEntry Index: %d, Entry Timestamp: %@\n\n", i, entry.timestamp);

        
        // if in U.S.
        if ([entry.placemark.country isEqualToString:@"United States"]) {
            NSLog(@"\n\nEntry.placemark.country %@\n\n", entry.placemark.country);
            
            // compare its state's data to every state in the country
            for (StateData *eachState in stateDataArray) {
                
                //When you find a matching state, increment the count and set the coordinates
                if ([entry.placemark.administrativeArea isEqualToString:eachState.stateAbbreviation]) {
                    NSLog(@"\n\nEntry.placemark.administrativeArea %@\n\n", entry.placemark.administrativeArea);

                    
                    //convert NSNumber to int
                    int number = [eachState.stateCount intValue];
                    number++;  //increment
                    //convert back to NSNumber
                    eachState.stateCount = [NSNumber numberWithInt:number];
                    
                    //set the coordinates
                    eachState.stateLocation = [[CLLocation alloc] initWithLatitude:entry.location.coordinate.latitude longitude:entry.location.coordinate.longitude];
                    NSLog(@"\n\nstateData.stateCount for index: %d is equal to: %@\n\n", i, eachState.stateCount);
                    
                } //END if matching state
                
            } //END for loop  all the states
            
        } // END if country is U.S.
        
        i = i + 1;
        
    } //END for all the entries
    
    //Now figure out the state percentages
    int totalDaysInState = 0;
    
    //Go through each state to find the total number of days
    for (StateData *stateData in stateDataArray) {
        
        //Convert NSNumber of that state's number of days into an integer
        int number = [stateData.stateCount intValue];
        
        //add that number to the total
        totalDaysInState = totalDaysInState + number;
    } //END for loop for total number of days
    
    
    //Go through each state again to set the percentage value
    for (StateData *stateData in stateDataArray) {
        
        //convert the NSNumber state count into a float & divide by the total
        double percent = [stateData.stateCount doubleValue] / totalDaysInState;
        
        
        
        //store the percentage in NSNumber format into the property
        stateData.statePercentage = [NSNumber numberWithDouble:percent];
        
    } //END for loop for percent
    
    
    //Now sort by percentage
    NSSortDescriptor *statePercent = [NSSortDescriptor sortDescriptorWithKey:@"statePercentage" ascending:NO];
    NSSortDescriptor *stateAbbrev   = [NSSortDescriptor sortDescriptorWithKey:@"stateAbbreviation" ascending:NO];
    [stateDataArray sortUsingDescriptors:@[statePercent, stateAbbrev]];
    


    return stateDataArray;
    
} // search all entries by percent


@end
