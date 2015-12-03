//
//  LocationEntryController.m
//  LocationLogger
//
//  Created by Erin Krentz on 10/30/15.
//  Copyright © 2015 EMK. All rights reserved.
//
//  This Controller provides the basic Core Data methods

#import "LocationEntryController.h"

@interface LocationEntryController()

@property (nonatomic, strong) NSArray *entries;

@end

@implementation LocationEntryController

+ (LocationEntryController *)sharedInstance {
    static LocationEntryController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [LocationEntryController new];
        [sharedInstance loadEntries];
    });
    return sharedInstance;
}


#pragma mark - Create
- (Entry *)createEntryWithTimestamp:(NSDate *)timestamp
                           location:(CLLocation *)location
                          placemark:(CLPlacemark *)placemark
                          partOfDay:(NSString *)partOfDay
                         manualFlag:(NSNumber *)manualFlag
                            stateUS:(NSString *)stateUS
    {
        
    
    Entry *saveEntry = [NSEntityDescription insertNewObjectForEntityForName:@"Entry"
                                                 inManagedObjectContext:[Stack sharedInstance].managedObjectContext];
    saveEntry.timestamp = timestamp;
    saveEntry.location = location;
    saveEntry.placemark = placemark;
    saveEntry.partOfDay = partOfDay;
    saveEntry.manualFlag = manualFlag;
    saveEntry.stateUS = stateUS;
        
    
    [self saveToPersistentStorage];
    
    return saveEntry;
}

#pragma mark - Read Data by Date Ascending
- (void)loadEntries {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Entry"];
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO]];
        NSArray *fetchedObjects = [[Stack sharedInstance].managedObjectContext
                               executeFetchRequest:fetchRequest
                               error:nil];
        self.entries = fetchedObjects;

}


#pragma mark: Delete
- (void)removeEntry:(Entry *)entry{
    NSMutableArray *mutableEntries = self.entries.mutableCopy;
    if ([mutableEntries containsObject:entry]) {
        [mutableEntries removeObject:entry];
    }
    self.entries = mutableEntries;
    [entry.managedObjectContext deleteObject:entry];
    [self saveToPersistentStorage];
}

//This method is called by the location view controllers
//They have the local properties.
//This method needs to find the entry and remove it
- (void)removeEntryWithTimestamp:(NSDate *)timestamp
                           location:(CLLocation *)location
                          placemark:(CLPlacemark *)placemark
                          partOfDay:(NSString *)partOfDay
                         manualFlag:(NSNumber *)manualFlag
                         stateUS:(NSString *)stateUS {
    
    NSMutableArray *mutableEntries = self.entries.mutableCopy;
    
    
    //From your persistent stored database, you have an array mutableEntries and a comparyEntry entry
    //You are comparing it to the properties sent in from the location view controllers.
        
    NSCalendar *calendar = [[NSCalendar alloc]
                                initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSCalendarUnit units = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
        
    //These date components are from the properties sent in from the location view controllers
    NSDateComponents *componentsTimestamp = [calendar components:units fromDate:timestamp];
        
    //find the other entry already in the database
    //compareEntry is the stored entry in the shared database
    //check compareEntry date properties versus what is sent in
    //If there is another entry in the same time slot, remove the old entry
        
    for (Entry *compareEntry in mutableEntries) {
            
        if (compareEntry.timestamp) {
            NSDateComponents *componentsStoredEntry = [calendar components:units fromDate:compareEntry.timestamp];
                
            //if year/month/day/partOfDay are equal, remove that entry
                
            if ([componentsStoredEntry year] == [componentsTimestamp year]) {
                if ([componentsStoredEntry month] == [componentsTimestamp month]) {
                    if ([componentsStoredEntry day] == [componentsTimestamp day]) {
                        if ([partOfDay isEqualToString:compareEntry.partOfDay]) {
                            NSLog(@"\n In RemoveEntryWithTimestamp %@  compareEntry %@", partOfDay, compareEntry.partOfDay);
                                
                            //remove the entry
                            [mutableEntries removeObject:compareEntry];
                            self.entries = mutableEntries;
                            [compareEntry.managedObjectContext deleteObject:compareEntry];
                            [self saveToPersistentStorage];
                            break;

                                
                        } //if partOfDay
                    }// if day
                }  //if month
            }  // if years don't match
                
        }   //if no timestamp on compareEntry
            
    }  //for loop

}  //removeEntryWithTimestamp
    

        
        


#pragma mark: Update
- (void)save {
    [self saveToPersistentStorage];
}

- (void)saveToPersistentStorage {
    [[Stack sharedInstance].managedObjectContext save:nil];
}




@end
