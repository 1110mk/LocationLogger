//
//  Entry+CoreDataProperties.h
//  LocationLogger
//
//  Created by Erin Krentz on 10/30/15.
//  Copyright © 2015 EMK. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Entry.h"


NS_ASSUME_NONNULL_BEGIN

@interface Entry (CoreDataProperties)

@property (nullable, nonatomic, retain) CLLocation *location;
@property (nullable, nonatomic, retain) CLPlacemark *placemark;
@property (nullable, nonatomic, retain) NSDate *timestamp;
@property (nullable, nonatomic, retain) NSNumber *manualFlag;
@property (nullable, nonatomic, retain) NSString *partOfDay;

@end

NS_ASSUME_NONNULL_END
