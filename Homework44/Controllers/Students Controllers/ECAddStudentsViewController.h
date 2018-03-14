//
//  ECAddStudentsViewController.h
//  Homework44
//
//  Created by Евгений Чемоданов on 12.12.2017.
//  Copyright © 2017 Eugene Chemodanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECStudent+CoreDataClass.h"

typedef enum {
    AddMode,
    EditMode
} ViewMode;

@interface ECAddStudentsViewController : UITableViewController <UIPopoverPresentationControllerDelegate>

- (IBAction)actionCancel:(UIBarButtonItem *)sender;
- (IBAction)actionDone:(UIBarButtonItem *)sender;

@property (strong, nonatomic) ECStudent *student;
@property (assign, nonatomic) ViewMode viewMode;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
