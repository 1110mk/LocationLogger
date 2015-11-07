//
//  LocationEntryController.h
//  LocationLogger
//
//  Created by Erin Krentz on 10/30/15.
//  Copyright © 2015 EMK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entry+CoreDataProperties.h"

@interface LocationEntryController : NSObject

@property (strong, nonatomic, readonly) NSArray *entries;

+ (LocationEntryController *)sharedInstance;

- (Entry *)createEntryWithTimestamp:(NSDate *)timeStamp
                           location:(CLLocation *)location
                          placemark:(CLPlacemark *)placemark
                          partOfDay:(NSString *)partOfDay
                         manualFlag:(NSNumber *)manualFlag;


-(void)loadEntries;
-(void)removeEntry:(Entry *)entry;
-(void)save;


@end
