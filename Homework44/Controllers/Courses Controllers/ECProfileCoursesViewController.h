//
//  ECProfileCoursesViewController.h
//  Homework44
//
//  Created by Евгений Чемоданов on 22.12.2017.
//  Copyright © 2017 Eugene Chemodanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECCoreDataViewController.h"
#import "ECCourse+CoreDataClass.h"

@interface ECProfileCoursesViewController : UITableViewController

@property (strong, nonatomic) ECCourse *course;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
