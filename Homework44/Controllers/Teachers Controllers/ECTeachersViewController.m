//
//  ECTeachersViewController.m
//  Homework44
//
//  Created by Евгений Чемоданов on 24.12.2017.
//  Copyright © 2017 Eugene Chemodanov. All rights reserved.
//

#import "ECTeachersViewController.h"
#import "ECAddTeachersViewController.h"
#import "ECProfileTeachersViewController.h"

#import "ECCoreDataManager.h"
#import "ECTeacher+CoreDataClass.h"

#import "ECCell.h"

@interface ECTeachersViewController ()
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@end

@implementation ECTeachersViewController
@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"ECTeacher"];
    
    fetchRequest.fetchBatchSize = 50;
    
    NSSortDescriptor *firstNameTeacherDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"firstNameTeacher"
                                                                             ascending:YES];
    
    NSSortDescriptor *lastNameTeacherDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"lastNameTeacher"
                                                                           ascending:YES];
    
    fetchRequest.sortDescriptors = @[firstNameTeacherDescriptor, lastNameTeacherDescriptor];
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self performSegueWithIdentifier:@"TeacherProfileSegue" sender:[tableView cellForRowAtIndexPath:indexPath]];
}

#pragma mark - UITableViewDataSource

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    ECTeacher *teacher = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    NSString *countCourses = teacher.courses.count == 1 ? [NSString stringWithFormat:@"%lu course", teacher.courses.count] : [NSString stringWithFormat:@"%lu courses", teacher.courses.count];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@ (%@)", teacher.firstNameTeacher, teacher.lastNameTeacher, countCourses];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    
    return [sectionInfo name];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"AddTeacherSegue"]) {
        UINavigationController *nav = segue.destinationViewController;
        ECAddTeachersViewController *addTeacherVC = (ECAddTeachersViewController *)nav.topViewController;
        addTeacherVC.managedObjectContext = self.managedObjectContext;
        addTeacherVC.viewMode = AddMode;
        
    } else if ([segue.identifier isEqualToString:@"TeacherProfileSegue"]) {
        ECProfileTeachersViewController *profileVC = segue.destinationViewController;
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        ECTeacher *teacher = [self.fetchedResultsController objectAtIndexPath:indexPath];
        profileVC.managedObjectContext = self.managedObjectContext;
        profileVC.teacher = teacher;
    }
}

@end
