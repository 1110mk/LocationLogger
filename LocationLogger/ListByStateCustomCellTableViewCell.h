//
//  ListByStateCustomCellTableViewCell.h
//  LocationLogger
//
//  Created by Erin Krentz on 11/15/15.
//  Copyright © 2015 EMK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListByStateCustomCellTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *countryLabel;

@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end
