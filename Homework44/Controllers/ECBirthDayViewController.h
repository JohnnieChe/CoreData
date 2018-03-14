//
//  ECBirthDayViewController.h
//  Homework44
//
//  Created by Евгений Чемоданов on 13.12.2017.
//  Copyright © 2017 Eugene Chemodanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ECBirthViewControllerDelegate <NSObject>
- (void) dateChanged:(NSDate*) newDate;
@end

@interface ECBirthDayViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) NSDate *date;

@property (weak, nonatomic) id <ECBirthViewControllerDelegate> delegate;

- (IBAction)actionDatePicker:(UIDatePicker *)sender;

@end
