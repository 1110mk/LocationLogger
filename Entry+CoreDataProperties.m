//
//  Entry+CoreDataProperties.m
//  LocationLogger
//
//  Created by Erin Krentz on 10/30/15.
//  Copyright © 2015 EMK. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Entry+CoreDataProperties.h"

@implementation Entry (CoreDataProperties)

@dynamic stateUS;
@dynamic location;
@dynamic placemark;
@dynamic timestamp;
@dynamic manualFlag;
@dynamic partOfDay;

@end
