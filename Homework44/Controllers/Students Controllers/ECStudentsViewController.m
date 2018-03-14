//
//  ECStudentsViewController.m
//  Homework44
//
//  Created by Евгений Чемоданов on 12.12.2017.
//  Copyright © 2017 Eugene Chemodanov. All rights reserved.
//

#import "ECStudentsViewController.h"
#import "ECAddStudentsViewController.h"
#import "ECProfileStudentsViewController.h"

#import "ECCoreDataManager.h"
#import "ECStudent+CoreDataClass.h"

#import "ECCell.h"

@interface ECStudentsViewController ()
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@end

@implementation ECStudentsViewController
@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"ECStudent"];
    
    fetchRequest.fetchBatchSize = 50;
    
    NSSortDescriptor *firstNameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"firstNameStudent"
                                                                          ascending:YES];
    
    NSSortDescriptor *lastNameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"lastNameStudent"
                                                                         ascending:YES];
    
    fetchRequest.sortDescriptors = @[firstNameDescriptor, lastNameDescriptor];
    
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

    [self performSegueWithIdentifier:@"StudentProfileSegue" sender:[tableView cellForRowAtIndexPath:indexPath]];
}

#pragma mark - UITableViewDataSource

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    ECStudent *student = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", student.firstNameStudent, student.lastNameStudent];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    
    return sectionInfo.name;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"AddStudentSegue"]) {
        UINavigationController *nav = segue.destinationViewController;
        ECAddStudentsViewController *addStudentVC = (ECAddStudentsViewController *)nav.topViewController;
        addStudentVC.managedObjectContext = self.managedObjectContext;
        addStudentVC.viewMode = AddMode;
    
    } else if ([segue.identifier isEqualToString:@"StudentProfileSegue"]) {
        ECProfileStudentsViewController *profileVC = segue.destinationViewController;
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        ECStudent *student = [self.fetchedResultsController objectAtIndexPath:indexPath];
        profileVC.managedObjectContext = self.managedObjectContext;
        profileVC.student = student;
    }
}

@end
