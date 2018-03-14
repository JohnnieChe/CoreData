//
//  ECBirthDayViewController.m
//  Homework44
//
//  Created by Евгений Чемоданов on 13.12.2017.
//  Copyright © 2017 Eugene Chemodanov. All rights reserved.
//

#import "ECBirthDayViewController.h"

@interface ECBirthDayViewController ()

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation ECBirthDayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.date) {
        self.date = [NSDate date];
    }
    
    self.datePicker.date = self.date;
    
    self.title = @"Date of birth";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionDatePicker:(UIDatePicker *)sender {
    self.date = self.datePicker.date;
    [self.delegate dateChanged:self.date];
}

@end
