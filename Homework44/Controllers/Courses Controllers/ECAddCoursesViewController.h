//
//  ECAddCoursesViewController.h
//  Homework44
//
//  Created by Евгений Чемоданов on 22.12.2017.
//  Copyright © 2017 Eugene Chemodanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECCourse+CoreDataClass.h"

typedef enum {
    AddMode,
    EditMode
} ViewMode;

@interface ECAddCoursesViewController : UITableViewController <UIPopoverPresentationControllerDelegate>

- (IBAction)actionCancel:(UIBarButtonItem *)sender;
- (IBAction)actionDone:(UIBarButtonItem *)sender;

@property (strong, nonatomic) ECCourse *course;
@property (assign, nonatomic) ViewMode viewMode;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
