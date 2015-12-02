//
//  StateData.h
//  LocationLogger
//
//  Created by Erin Krentz on 11/13/15.
//  Copyright © 2015 EMK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


@interface StateData : NSObject

@property (nullable, nonatomic, strong) NSString *stateAbbreviation;
@property (nullable, nonatomic, strong) NSNumber *stateCount;
@property (nullable, nonatomic, strong) NSNumber *statePercentage;
@property (nullable, nonatomic, strong) CLLocation *stateLocation;



@property (nullable, nonatomic, strong) NSMutableArray *stateDataArray;


-(nonnull NSArray  *)loadStateData;


@end
