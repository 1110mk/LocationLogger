//
//  SettingsViewController.m
//  LocationLogger
//
//  Created by Erin Krentz on 12/4/15.
//  Copyright © 2015 EMK. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()
@property (nonatomic, strong) NSString *yearToReturn;
@property (nonatomic, strong) NSString *currentYearString;
@end

@implementation SettingsViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Create the array of years
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    int currentYear  = [[dateFormatter stringFromDate:[NSDate date]] intValue];
    self.currentYearString = [dateFormatter stringFromDate:[NSDate date]];
    
    
    //Create Years Array from 1960 to This year
    self.locationYears = [[NSMutableArray alloc] init];
    for (int i=2014; i<=currentYear; i++) {
        [self.locationYears addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    //Set default value of current year
//    for (int i = 0; i < self.locationYears.count; i++) {
//        if ([[NSString stringWithFormat:@"%d", currentYear] isEqualToString:self.locationYears[i]]) {
//            [self.pickerView selectedRowInComponent:i];
//            
//        }
//    }
    
    self.yearToReturn = self.currentYearString;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfComponentsInPickerView: (UIPickerView*)thePickerView {
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.locationYears count];
}


- (NSString *)pickerView:(UIPickerView *)thePickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.locationYears objectAtIndex:row];

}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.locationYear = self.locationYears[row];
    self.yearPickedText.text = self.locationYear;
    self.yearToReturn = self.locationYear;
    
    [[NSUserDefaults standardUserDefaults] setObject:self.locationYear forKey:@"yearKey"];
    
}

//+ (NSString *)returnLocalYear {
//    NSString *year = [[NSString alloc] initWithString:self.yearToReturn];
//     return year  ;
//}



@end
