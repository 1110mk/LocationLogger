//
//  LocationEntryController.m
//  LocationLogger
//
//  Created by Erin Krentz on 10/30/15.
//  Copyright © 2015 EMK. All rights reserved.
//

#import "LocationEntryController.h"
#import "Stack.h"

@interface LocationEntryController()

@property (nonatomic, strong) NSArray *entries;

@end

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
- (void)loadEntries {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Entry"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:@NO]];
    NSArray *fetchedObjects = [[Stack sharedInstance].managedObjectContext
                               executeFetchRequest:fetchRequest
                               error:nil];
    self.entries = fetchedObjects;
}

#pragma mark: Delete
- (void)removeEntry:(Entry *)entry{
    NSMutableArray *mutableEntries = [NSMutableArray arrayWithArray:self.entries];
    if ([mutableEntries containsObject:entry]) {
        [mutableEntries removeObject:entry];
    }
    self.entries = mutableEntries;
    [entry.managedObjectContext deleteObject:entry];
    [self saveToPersistentStorage];
}


#pragma mark: Update
- (void)save {
    [self saveToPersistentStorage];
}

- (void)saveToPersistentStorage {
    [[Stack sharedInstance].managedObjectContext save:nil];
}




@end
