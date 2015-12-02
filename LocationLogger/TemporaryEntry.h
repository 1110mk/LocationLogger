//
//  TemporaryEntry.h
//  LocationLogger
//
//  Created by Erin Krentz on 11/21/15.
//  Copyright © 2015 EMK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface TemporaryEntry : NSObject

@property (nonatomic, strong) NSString *stateUS;
@property (nonatomic, retain) CLLocation *location;
@property (nonatomic, retain) CLPlacemark *placemark;
@property (nonatomic, strong) NSDate *timestamp;
@property (nonatomic, strong) NSNumber *manualFlag;
@property (nonatomic, strong) NSString *partOfDay;



@end
