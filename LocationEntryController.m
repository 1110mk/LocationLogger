//
//  LocationEntryController.m
//  LocationLogger
//
//  Created by Erin Krentz on 10/30/15.
//  Copyright © 2015 EMK. All rights reserved.
//

#import "LocationEntryController.h"
#import "Stack.h"

@implementation LocationEntryController

+ (LocationEntryController *)sharedInstance {
    static LocationEntryController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [LocationEntryController new];
    });
    return sharedInstance;
}


#pragma mark - Create
- (Entry *)createEntryWithTimestamp:(NSDate *)timestamp
                           location:(CLLocation *)location
                          placemark:(CLPlacemark *)placemark
                          partOfDay:(NSString *)partOfDay
                         manualFlag:(NSNumber *)manualFlag{
    
    Entry *entry = [NSEntityDescription insertNewObjectForEntityForName:@"Entry"
                                                 inManagedObjectContext:[Stack sharedInstance].managedObjectContext];
    entry.timestamp = timestamp;
    entry.location = location;
    entry.placemark = placemark;
    entry.partOfDay = partOfDay;
    entry.manualFlag = manualFlag;
    
    [self saveToPersistentStorage];
    
    return entry;
}

#pragma mark - Read
- (NSArray *)entries {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Entry"];
    NSArray *fetchedObjects = [[Stack sharedInstance].managedObjectContext
                               executeFetchRequest:fetchRequest
                               error:nil];
    return fetchedObjects;
}

#pragma mark: Delete
- (void)removeEntry:(Entry *)entry{
    [entry.managedObjectContext deleteObject:entry];
}


#pragma mark: Update
- (void)save {
    [self saveToPersistentStorage];
}

- (void)saveToPersistentStorage {
    [[Stack sharedInstance].managedObjectContext save:nil];
}




@end
