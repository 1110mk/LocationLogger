//
//  ListByPercentCustomCellTableViewCell.h
//  LocationLogger
//
//  Created by Erin Krentz on 11/15/15.
//  Copyright © 2015 EMK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListByPercentCustomCellTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *stateUSLabel;

@property (weak, nonatomic) IBOutlet UILabel *percentLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;


@end
