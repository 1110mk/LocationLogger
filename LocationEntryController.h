//
//  LocationEntryController.h
//  LocationLogger
//
//  Created by Erin Krentz on 10/30/15.
//  Copyright © 2015 EMK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entry+CoreDataProperties.h"
#import "Stack.h"

@interface LocationEntryController : NSObject

@property (strong, nonatomic, readonly) NSArray *entries;
@property (strong, nonatomic) NSString *requestType;


+ (LocationEntryController *)sharedInstance;

- (Entry *)createEntryWithTimestamp:(NSDate *)timeStamp
                           location:(CLLocation *)location
                          placemark:(CLPlacemark *)placemark
                          partOfDay:(NSString *)partOfDay
                         manualFlag:(NSNumber *)manualFlag
                            stateUS:(NSString *)stateUS;


-(void)loadEntries;
-(void)removeEntry:(Entry *)entry;

- (void)removeEntryWithTimestamp:(NSDate *)timestamp
                        location:(CLLocation *)location
                       placemark:(CLPlacemark *)placemark
                       partOfDay:(NSString *)partOfDay
                      manualFlag:(NSNumber *)manualFlag
                         stateUS:(NSString *)stateUS;
-(void)save;


@end
