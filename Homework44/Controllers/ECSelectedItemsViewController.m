//
//  ECSelectedItemsViewController.m
//  Homework44
//
//  Created by Евгений Чемоданов on 15.12.2017.
//  Copyright © 2017 Eugene Chemodanov. All rights reserved.
//

#import "ECSelectedItemsViewController.h"
#import "ECStudent+CoreDataClass.h"
#import "ECCourse+CoreDataClass.h"
#import "ECTeacher+CoreDataClass.h"

@interface ECSelectedItemsViewController ()

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (strong, nonatomic) NSArray *sortDescriptors;
@property (strong, nonatomic) NSString *entityName;
@property (strong ,nonatomic) NSIndexPath *lastSelectIndexPath;

@end

@implementation ECSelectedItemsViewController
@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setPreferencesForData];
    
    if (!self.selectedItems) {
        self.selectedItems = [NSMutableSet set];
    }
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self
                                                                                action:@selector(actionDoneButton)];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                  target:self
                                                                                  action:@selector(actionCancelButton)];
    
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = doneButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods

- (void)setPreferencesForData {
    
    if (self.typeItem == StudentItem) {
        NSSortDescriptor *firstNameStudentSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"firstNameStudent"
                                                                                         ascending:YES];
        NSSortDescriptor *lastNameSortStudentDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"lastNameStudent"
                                                                                        ascending:YES];
        
        self.sortDescriptors = @[firstNameStudentSortDescriptor, lastNameSortStudentDescriptor];
        self.entityName = @"ECStudent";
    
    } else if (self.typeItem == CourseItem) {
        NSSortDescriptor *nameCourseSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"nameCourse"
                                                                                   ascending:YES];
        
        self.sortDescriptors = @[nameCourseSortDescriptor];
        self.entityName = @"ECCourse";
    
    } else if (self.typeItem == TeacherItem) {
        NSSortDescriptor *firstNameTeacherSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"firstNameTeacher"
                                                                                         ascending:YES];
        NSSortDescriptor *lastNameTeacherSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"lastNameTeacher"
                                                                                        ascending:YES];
        
        self.sortDescriptors = @[firstNameTeacherSortDescriptor, lastNameTeacherSortDescriptor];
        self.entityName = @"ECTeacher";
    }
    
    NSString *title = [self titleTextForItems:self.typeItem];
    
    if (self.typeSelect == MultiSelect) {
        self.title = [title stringByAppendingString:@"s"];
    } else {
        self.title = title;
    }
}

- (NSString *)titleTextForItems:(TypeItem)sender {
    
    switch (sender) {
        case StudentItem:
            return @"Student";
            break;
        case CourseItem:
            return @"Course";
            break;
        case TeacherItem:
            return @"Teacher";
            break;
    }
}

- (NSString *)fullDescriptionEntity:(TypeItem)sender forItem:(id)item atIndexPath:(NSIndexPath *)indexPath {
    
    NSString *descriptionString;
    
    if (sender == StudentItem) {
        ECStudent *student = (ECStudent *)item;
        descriptionString = [NSString stringWithFormat:@"%@ %@", student.firstNameStudent, student.lastNameStudent];
    
    } else if (sender == CourseItem) {
        ECCourse *course = (ECCourse *)item;
        descriptionString =  [NSString stringWithFormat:@"%@", course.nameCourse];
    
    } else if (sender == TeacherItem) {
        ECTeacher *teacher = (ECTeacher *)item;
        descriptionString =  [NSString stringWithFormat:@"%@ %@", teacher.firstNameTeacher, teacher.lastNameTeacher];
    }
    
    return descriptionString;
}

- (void)deleteObject:(id)item {
    [self.selectedItems removeObject:item];
}

- (void)addObject:(id)item {
    
    if (self.typeSelect == SingleSelect) {
        [self.selectedItems removeAllObjects];
        [self.selectedItems addObject:item];
    } else {
        [self.selectedItems addObject:item];
    }
}

#pragma mark - Actions

- (void)actionDoneButton {
    
    id items;
    
    if (self.typeSelect == SingleSelect) {
        items = [self.selectedItems anyObject];
    } else {
        items = self.selectedItems;
    }
    
    [self.delegate didDoneSelectedItems:items
                            forTypeItem:self.typeItem];
    
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (void)actionCancelButton {
    
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (void)updateSelectedCellOnTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    
    if (self.lastSelectIndexPath) {
        UITableViewCell *lastSelectCell = [tableView cellForRowAtIndexPath:self.lastSelectIndexPath];
        lastSelectCell.accessoryType = UIAccessibilityTraitNone;
    }
    
    self.lastSelectIndexPath = indexPath;
}

#pragma mark - Core Data support

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:self.entityName];

    fetchRequest.fetchBatchSize = 50;
    
    fetchRequest.sortDescriptors = self.sortDescriptors;
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:self.managedObjectContext
                                          sectionNameKeyPath:nil
                                                   cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    
    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
    
    _fetchedResultsController = aFetchedResultsController;
    return _fetchedResultsController;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSManagedObject *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self deleteObject:item];
    } else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        if (self.typeSelect == SingleSelect) {
            [self updateSelectedCellOnTableView:tableView atIndexPath:indexPath];
        }
        
        [self addObject:item];
    }
}

#pragma mark - UITableViewDataSource

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    NSManagedObject *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = [self fullDescriptionEntity:self.typeItem forItem:item atIndexPath:indexPath];
    
    if ([self.selectedItems containsObject:item]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.lastSelectIndexPath = indexPath;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

@end
