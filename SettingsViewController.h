//
//  SettingsViewController.h
//  LocationLogger
//
//  Created by Erin Krentz on 12/4/15.
//  Copyright © 2015 EMK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) NSMutableArray *locationYears;
@property (strong, nonatomic) NSString *locationYear;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UITextField *yearPickedText;

//+ (NSString *)returnLocalYear;

@end
