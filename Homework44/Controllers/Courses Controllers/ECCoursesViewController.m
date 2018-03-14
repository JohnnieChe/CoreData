//
//  ECCoursesViewController.m
//  Homework44
//
//  Created by Евгений Чемоданов on 22.12.2017.
//  Copyright © 2017 Eugene Chemodanov. All rights reserved.
//

#import "ECCoursesViewController.h"
#import "ECAddCoursesViewController.h"
#import "ECProfileCoursesViewController.h"

#import "ECCoreDataManager.h"
#import "ECCourse+CoreDataClass.h"

#import "ECCell.h"

@interface ECCoursesViewController ()
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@end

@implementation ECCoursesViewController
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
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"ECCourse"];
    
    fetchRequest.fetchBatchSize = 50;
    
    NSSortDescriptor *branchCourseDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"branchCourse"
                                                                          ascending:YES];
    
    NSSortDescriptor *nameCourseDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"nameCourse"
                                                                         ascending:YES];
    
    NSSortDescriptor *subjectCourseDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"subjectCourse"
                                                                           ascending:YES];
    
    fetchRequest.sortDescriptors = @[branchCourseDescriptor, nameCourseDescriptor, subjectCourseDescriptor];
    
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
    
    [self performSegueWithIdentifier:@"CourseProfileSegue" sender:[tableView cellForRowAtIndexPath:indexPath]];
}

#pragma mark - UITableViewDataSource

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    ECCourse *course = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    NSString *countStudents = course.students.count == 1 ? [NSString stringWithFormat:@"%lu student", course.students.count] : [NSString stringWithFormat:@"%lu students", course.students.count];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@ (%@)", course.nameCourse, course.branchCourse, countStudents];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    
    return [sectionInfo name];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"AddCourseSegue"]) {
        UINavigationController *nav = segue.destinationViewController;
        ECAddCoursesViewController *addCourseVC = (ECAddCoursesViewController *)nav.topViewController;
        addCourseVC.managedObjectContext = self.managedObjectContext;
        addCourseVC.viewMode = AddMode;
        
    } else if ([segue.identifier isEqualToString:@"CourseProfileSegue"]) {
        ECProfileCoursesViewController *profileVC = segue.destinationViewController;
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        ECCourse *course = [self.fetchedResultsController objectAtIndexPath:indexPath];
        profileVC.managedObjectContext = self.managedObjectContext;
        profileVC.course = course;
    }
}

@end
