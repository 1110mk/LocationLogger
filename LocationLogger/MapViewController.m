//
//  MapViewController.m
//  LocationLogger
//
//  Created by Erin Krentz on 11/17/15.
//  Copyright © 2015 EMK. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

//This is the Entry Model Shared Instance array
@property (nonatomic, strong) NSArray *entriesArray;

@property (strong, nonatomic) NSMutableArray *stateDataArray;


@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // GET the Core Data stored entries to display
    [self loadEntries];

    self.mapView.delegate = self;
    
    // Uses CLLocation manager to locate the user
    self.locationManager = [[CLLocationManager alloc] init];
    
    self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    [self.locationManager requestLocation];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    
    // Add an annotation on where the user currently is
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = userLocation.coordinate;
    [self.mapView addAnnotation:point];

    
    // Add annotations for U.S. Places
    self.stateDataArray = [SearchEntriesController sortAllTheEntriesByPercent:self.entriesArray];
    
    for (StateData *singleState in self.stateDataArray) {
        int i = [singleState.stateCount intValue];
        if (i > 0) {
            MKPointAnnotation *point2 = [[MKPointAnnotation alloc] init];
            point2.coordinate = singleState.stateLocation.coordinate;
            [self.mapView addAnnotation:point2];
        }
    }
    
    // Add annotations for non-U.S. Places
    
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    UIAlertController* errorAlert = [UIAlertController alertControllerWithTitle:@"LocationAlert"
            message:@"Failed to get your location."
            preferredStyle:UIAlertControllerStyleAlert];
    
    [errorAlert addAction:[UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Alert");
    }]];
    
    
    [self presentViewController:errorAlert animated:YES completion:nil];
    
}


- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    NSLog(@"Did change status");
}

- (void)loadEntries {
    
    self.entriesArray = [LocationEntryController sharedInstance].entries;
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    //When the location manager gets a new location, update the user's location
    
    
    
}



@end
