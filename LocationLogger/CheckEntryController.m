//
//  CheckEntryController.m
//  LocationLogger
//
//  Created by Erin Krentz on 11/13/15.
//  Copyright © 2015 EMK. All rights reserved.
//
//  This controller provides 1 methods to check if the entry is a duplicate entry

#import "CheckEntryController.h"

@interface CheckEntryController()

@property (nonatomic, strong) NSArray *entries;

@end


@implementation CheckEntryController

+  (TemporaryEntry *)checkEntryWithTimestamp:(NSDate *)timestamp
                            location:(CLLocation *)location
                           placemark:(CLPlacemark *)placemark
                           partOfDay:(NSString *)partOfDay
                          manualFlag:(NSNumber *)manualFlag
                             stateUS:(NSString *)stateUS
 {
    
    //YOU have two entry arrays and two classes of entries
    //From your persistent stored database, you have an array entries and a comparyEntry entry
    //You are comparing it to a Entry, which is sent in called notYetSavedEntry.
    
    [[LocationEntryController sharedInstance] loadEntries];
    NSArray *entries = [LocationEntryController sharedInstance].entries;
    
    NSCalendar *calendar = [[NSCalendar alloc]
                            initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSCalendarUnit units = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    
    //These date components are from notYetSavedEntry sent in
    NSDateComponents *componentsTimestamp = [calendar components:units fromDate:timestamp];
    
    //see if there is another entry already in the database
    //compareEntry is the stored entry in the shared database
    //check compareEntries date properties versus what is sent in
     //If there is another entry in the same time slot, send back a temporary entry for the user to decide which to keep
     // otherwise, send back nil
    for (Entry *compareEntry in entries) {
        
        if (compareEntry.timestamp) {
            NSDateComponents *componentsStoredEntry = [calendar components:units fromDate:compareEntry.timestamp];
            
            //if year/month/day/partOfDay are equal, send back to the user to select which entry
            
            if ([componentsStoredEntry year] == [componentsTimestamp year]) {
                if ([componentsStoredEntry month] == [componentsTimestamp month]) {
                    if ([componentsStoredEntry day] == [componentsTimestamp day]) {
                        if ([partOfDay isEqualToString:compareEntry.partOfDay]) {
                            NSLog(@"\n In Check Entry Controller\nNotYetSaved %@  compareEntry %@", partOfDay, compareEntry.partOfDay);
                            
                            
                            //create a temporary entry to send back to the calling method
                            TemporaryEntry *tmpEntry = [[TemporaryEntry alloc] init];
                            tmpEntry.location = compareEntry.location;
                            tmpEntry.placemark = compareEntry.placemark;
                            tmpEntry.timestamp = compareEntry.timestamp;
                            tmpEntry.partOfDay = compareEntry.partOfDay;
                            tmpEntry.manualFlag = compareEntry.manualFlag;
                            tmpEntry.stateUS = compareEntry.stateUS;
                            
                            
                            return tmpEntry;
                            
                        } //if partOfDay
                        
                        
                    }// if day
                    
                    
                }  //if month
                
            }  else {
                return nil;  // if years don't match
            }
            
        } else {
            return nil; //if no timestamp on notYetSavedEntry
        }
        
    }  //for loop
    
    
    return nil;
    
    
}  //checkEntry




@end
