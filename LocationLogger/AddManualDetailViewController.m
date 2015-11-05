//
//  AddManualDetailViewController.m
//  LocationLogger
//
//  Created by Erin Krentz on 10/29/15.
//  Copyright © 2015 EMK. All rights reserved.
//

#import "AddManualDetailViewController.h"
#import "LocationEntryController.h"
#import "LocateMeNowDetailViewController.h"
#import "LocalEntry.h"


@interface AddManualDetailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UITextField *stateTextField;
@property (weak, nonatomic) IBOutlet UITextField *countryTextField;

@property (weak, nonatomic) IBOutlet UIDatePicker *locationDatePicker;


@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (strong, nonatomic) CLGeocoder *geocoder;

@end

@implementation AddManualDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Initialize an entry
    LocalEntry *localEntry = [LocalEntry new];
    [self updateWithEntry:localEntry];
    
    //add the geocoder in to get the city and state
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateWithEntry:(LocalEntry *)localEntry{
    self.cityTextField.text = self.entryCity;
    self.stateTextField.text = self.entryState;
    self.countryTextField.text = self.entryCountry;
    
    //set the segmented control
    //to make none highlighted set to -1
    
    if ([self.localEntry.partOfDay isEqualToString:@"AM"]) {
        self.segmentedControl.selectedSegmentIndex = 0;
    } else if ([self.localEntry.partOfDay isEqualToString:@"MID"]) {
        self.segmentedControl.selectedSegmentIndex = 1;
    } else if ([self.localEntry.partOfDay isEqualToString:@"PM"]) {
        self.segmentedControl.selectedSegmentIndex = 2;
    }
}

- (IBAction)datePickerUpdated:(id)sender {
    NSDate *pickerDate = [self.locationDatePicker date];
    self.localEntry.timestamp = pickerDate;
}

- (IBAction)segmentedControlChanged:(id)sender {
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        [self.localEntry.partOfDay isEqualToString:@"AM"];
    } else if (self.segmentedControl.selectedSegmentIndex == 1) {
        [self.localEntry.partOfDay isEqualToString:@"MID"];
    } else if (self.segmentedControl.selectedSegmentIndex == 2) {
        [self.localEntry.partOfDay isEqualToString:@"PM"];
    }
}


- (IBAction)saveButtonPressed:(id)sender {
    
   //get all the properties and store in correct format
    //set the timestamp
    NSDate *pickerDate = [self.locationDatePicker date];
    self.localEntry.timestamp = pickerDate;
    
    //set the segmented control
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        [self.localEntry.partOfDay isEqualToString:@"AM"];
    } else if (self.segmentedControl.selectedSegmentIndex == 1) {
        [self.localEntry.partOfDay isEqualToString:@"MID"];
    } else if (self.segmentedControl.selectedSegmentIndex == 2) {
        [self.localEntry.partOfDay isEqualToString:@"PM"];
    }
   
    //set the location and placemark
    if (!self.geocoder) {
        self.geocoder = [[CLGeocoder alloc] init];
    }
    //Get the latest City, State, and Country
    self.entryCity = self.cityTextField.text;
    self.entryState = self.stateTextField.text;
    self.entryCountry = self.countryTextField.text;
    
    //Forward Geocode those into location coordinates

    NSString *addressString = [NSString stringWithFormat:@"%@, %@, %@", self.entryCity, self.entryState, self.entryCountry];
    [self.geocoder geocodeAddressString:addressString completionHandler:^(NSArray *placemarks, NSError *error) {
            if ([placemarks count] > 0) {
            
                //if more than one placemark returned, pick the first one
                self.localEntry.placemark = [placemarks objectAtIndex:0];
            
                //set the location
               CLLocation *location = self.localEntry.placemark.location;
                self.localEntry.location = location;
            }
    }];

    //set the manual Flag
    self.localEntry.manualFlag = [NSNumber numberWithBool:YES];
    
    //save to the shared instance
    [[LocationEntryController sharedInstance] createEntryWithTimestamp:
            self.localEntry.timestamp
        location:self.localEntry.location
        placemark:self.localEntry.placemark
        partOfDay:self.localEntry.partOfDay
        manualFlag:self.localEntry.manualFlag];
}



@end
