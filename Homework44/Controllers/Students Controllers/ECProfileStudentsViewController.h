//
//  ECProfileStudentsViewController.h
//  Homework44
//
//  Created by Евгений Чемоданов on 12.12.2017.
//  Copyright © 2017 Eugene Chemodanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECCoreDataViewController.h"
#import "ECStudent+CoreDataClass.h"

@interface ECProfileStudentsViewController : UITableViewController

@property (strong, nonatomic) ECStudent *student;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
