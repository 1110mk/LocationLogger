//
//  MapViewController.h
//  LocationLogger
//
//  Created by Erin Krentz on 11/17/15.
//  Copyright © 2015 EMK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SearchEntriesController.h"
#import "StateData.h"
#import "LocationEntryController.h"
#import "Entry.h"




@interface MapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) CLLocationManager *locationManager;


@end
