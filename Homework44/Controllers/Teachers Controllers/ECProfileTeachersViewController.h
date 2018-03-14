//
//  ECProfileTeachersViewController.h
//  Homework44
//
//  Created by Евгений Чемоданов on 24.12.2017.
//  Copyright © 2017 Eugene Chemodanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECCoreDataViewController.h"
#import "ECTeacher+CoreDataClass.h"

@interface ECProfileTeachersViewController : UITableViewController

@property (strong, nonatomic) ECTeacher *teacher;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
