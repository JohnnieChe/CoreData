//
//  ECAddTeachersViewController.h
//  Homework44
//
//  Created by Евгений Чемоданов on 24.12.2017.
//  Copyright © 2017 Eugene Chemodanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECTeacher+CoreDataClass.h"

typedef enum {
    AddMode,
    EditMode
} ViewMode;

@interface ECAddTeachersViewController : UITableViewController <UIPopoverPresentationControllerDelegate>

- (IBAction)actionCancel:(UIBarButtonItem *)sender;
- (IBAction)actionDone:(UIBarButtonItem *)sender;

@property (strong, nonatomic) ECTeacher *teacher;
@property (assign, nonatomic) ViewMode viewMode;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
