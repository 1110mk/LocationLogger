//
//  LocalEntry.h
//  LocationLogger
//
//  Created by Erin Krentz on 11/4/15.
//  Copyright © 2015 EMK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocalEntry : NSObject

@property (nullable, nonatomic, strong) CLLocation *location;
@property (nullable, nonatomic, strong) CLPlacemark *placemark;
@property (nullable, nonatomic, strong) NSDate *timestamp;
@property (nullable, nonatomic, retain) NSNumber *manualFlag;
@property (nullable, nonatomic, strong) NSString *partOfDay;

@end
