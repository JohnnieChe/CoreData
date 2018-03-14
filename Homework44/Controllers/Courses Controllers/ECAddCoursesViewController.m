//
//  ECAddCoursesViewController.m
//  Homework44
//
//  Created by Евгений Чемоданов on 22.12.2017.
//  Copyright © 2017 Eugene Chemodanov. All rights reserved.
//

#import "ECAddCoursesViewController.h"
#import "ECStudent+CoreDataClass.h"
#import "ECTeacher+CoreDataClass.h"
#import "ECCoreDataManager.h"

#import "ECSelectedItemsViewController.h"
#import "ECCoursesViewController.h"

#import "ECCell.h"
#import "ECAlert.h"

typedef enum {
    CourseTextFieldBranchName,
    CourseTextFieldNameCourse,
    CourseTextFieldSubjectCourse
} CourseTag;

@interface ECAddCoursesViewController () <UITextFieldDelegate, ECSelectedItemsViewControllerDelegate>
@property (strong, nonatomic) ECCoreDataManager *dataManager;
@end

@implementation ECAddCoursesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataManager = (ECCoreDataManager *)[ECCoreDataManager sharedManager];
    
    if (self.viewMode == AddMode) {
        
        self.navigationItem.title = @"Add course";
        
        ECCourse *course = [NSEntityDescription insertNewObjectForEntityForName:@"ECCourse"
                                                         inManagedObjectContext:self.managedObjectContext];
        self.course = course;
        
    } else {
        self.navigationItem.title = @"Edit course";
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)actionCancel:(UIBarButtonItem *)sender {
    
    [self.managedObjectContext rollback];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionDone:(UIBarButtonItem *)sender {
    
    if ([self isCourseInfoValid]) {
        self.course.branchCourse = [self branchCourse];
        self.course.nameCourse = [self nameCourse];
        self.course.subjectCourse = [self subjectCourse];
        
        [self.dataManager saveContext];
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } else {
        [self presentViewController:[ECAlert checkInfo]
                           animated:YES
                         completion:nil];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    switch (self.viewMode) {
        case AddMode:
            return 2;
            break;
        case EditMode:
            return 3;
        default:
            return 0;
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return 4;
            break;
        case 1:
            return 1 + [self.course.students count];
            break;
        case 2:
            return 1;
            break;
        default:
            return 0;
            break;
    }
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return @"Main info";
            break;
        case 1:
            return @"Students";
            break;
        default:
            return @"";
            break;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row != 3) {
            static NSString *identifier = @"CourseCell";
            ECCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            
            if (indexPath.row == 0) {
                cell.labelInfo.text = @"Branch";
                cell.textFieldInfo.placeholder = @"IT";
                cell.textFieldInfo.tag = CourseTextFieldBranchName;
                cell.textFieldInfo.keyboardType = UIKeyboardTypeDefault;
                cell.textFieldInfo.autocapitalizationType = UITextAutocapitalizationTypeWords;
                cell.textFieldInfo.returnKeyType = UIReturnKeyNext;
                
                if (self.viewMode == EditMode) {
                    cell.textFieldInfo.text = self.course.branchCourse;
                }
            
            } else if (indexPath.row == 1) {
                cell.labelInfo.text = @"Name";
                cell.textFieldInfo.placeholder = @"Programming";
                cell.textFieldInfo.tag = CourseTextFieldNameCourse;
                cell.textFieldInfo.keyboardType = UIKeyboardTypeDefault;
                cell.textFieldInfo.autocapitalizationType = UITextAutocapitalizationTypeWords;
                cell.textFieldInfo.returnKeyType = UIReturnKeyNext;
                
                if (self.viewMode == EditMode) {
                    cell.textFieldInfo.text = self.course.nameCourse;
                }
                
            } else if (indexPath.row == 2) {
                cell.labelInfo.text = @"Subject";
                cell.textFieldInfo.placeholder = @"Objective C";
                cell.textFieldInfo.tag = CourseTextFieldSubjectCourse;
                cell.textFieldInfo.keyboardType = UIKeyboardTypeDefault;
                cell.textFieldInfo.autocapitalizationType = UITextAutocapitalizationTypeWords;
                cell.textFieldInfo.returnKeyType = UIReturnKeyDone;
                
                if (self.viewMode == EditMode) {
                    cell.textFieldInfo.text = self.course.subjectCourse;
                }
            }
            
            cell.textFieldInfo.delegate = self;
            return cell;
            
        } else {
            
            static NSString *identifier = @"TeacherCell";
            UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];

            cell.textLabel.text = @"Teacher";
            
            if (self.course.teacher) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", self.course.teacher.firstNameTeacher, self.course.teacher.lastNameTeacher];
            }
            
            return cell;
        }
        
    } else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            static NSString *identifier = @"EditStudentsCell";
            UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            
            return cell;
            
        } else {
            static NSString *identifier = @"StudentCell";
            UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            
            ECStudent *student = [self.course.students allObjects][indexPath.row - 1];
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", student.firstNameStudent, student.lastNameStudent];
            
            return cell;
        }
        
    } else if (indexPath.section == 2) {
        static NSString *identifier = @"DeleteCourseCell";
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        
        return cell;
        
    } else {
        return nil;
    }
}

#pragma mark - Private methods

- (NSString *)branchCourse {
    
    ECCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSString *branchCourse = cell.textFieldInfo.text;
    
    return branchCourse;
}

- (NSString *)nameCourse {
    
    ECCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSString *nameCourse = cell.textFieldInfo.text;
    
    return nameCourse;
}

- (NSString *)subjectCourse {
    
    ECCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    NSString *subjectCourse = cell.textFieldInfo.text;
    
    return subjectCourse;
}

- (BOOL)isCourseInfoValid {
    
    NSString *branchCourse = [self branchCourse];
    if (!branchCourse || [branchCourse isEqualToString:@""]) {
        return NO;
    }
    
    NSString *nameCourse = [self nameCourse];
    if (!nameCourse || [nameCourse isEqualToString:@""]) {
        return NO;
    }
    
    NSString *subjectCourse = [self subjectCourse];
    if (!subjectCourse || [subjectCourse isEqualToString:@""]) {
        return NO;
    }
    
    return YES;
}

- (void)selectObjectsWithTypeItem:(TypeItem)typeItem andTypeSelect:(TypeSelect)typeSelect andSelectedItems:(NSMutableSet *)selectedItems fromSender:(UITableViewCell *)sender {
    
    ECSelectedItemsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ECSelectedItemsViewController"];
    vc.preferredContentSize = CGSizeMake(500, 300);
    vc.typeItem = typeItem;
    vc.typeSelect = typeSelect;
    vc.selectedItems = selectedItems;
    vc.delegate = self;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationPopover;
    
    UIPopoverPresentationController *popController = [nav popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    popController.delegate = self;
    popController.sourceView = sender;
    popController.sourceRect = CGRectMake(CGRectGetMidX(sender.bounds),
                                          CGRectGetMaxY(sender.bounds),
                                          0, 0);
    
    [self presentViewController:nav
                       animated:YES
                     completion:nil];
}

- (void)actionDismiss {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (void)deleteCourseWithConfirmation:(BOOL)confirmation {
    
    if (confirmation == YES) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are you sure to delete course?"
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete"
                                                               style:UIAlertActionStyleDestructive
                                                             handler:^(UIAlertAction * action) {
                                                                 [self deleteCourse];
                                                                 [self dismissViewControllerAnimated:YES completion:nil];
                                                             }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * action) {
                                                                 nil;
                                                             }];
        
        [alert addAction:deleteAction];
        [alert addAction:cancelAction];
        
        [self presentViewController:alert
                           animated:YES
                         completion:nil];
        
    } else {
        [self deleteCourse];
    }
}

- (void)deleteCourse {
    [self.managedObjectContext deleteObject:self.course];
    [self.dataManager saveContext];
}

- (NSMutableSet *)selectTeacher {
    
    ECSelectedItemsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ECSelectedItemsViewController"];
    
    if (self.course.teacher) {
        vc.selectedItems = [NSMutableSet setWithObject:self.course.teacher];
        return vc.selectedItems;
    } else {
        return nil;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 3) {
        ECCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        [self selectObjectsWithTypeItem:TeacherItem
                          andTypeSelect:SingleSelect
                       andSelectedItems:[self selectTeacher]
                             fromSender:cell];
    
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        [self selectObjectsWithTypeItem:StudentItem
                          andTypeSelect:MultiSelect
                       andSelectedItems:[self.course.students mutableCopy]
                             fromSender:cell];
    
    } else if (indexPath.section == 2 && indexPath.row == 0) {
        [self deleteCourseWithConfirmation:YES];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.tag == CourseTextFieldBranchName) {
        [textField resignFirstResponder];
        
        ECCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
        [cell.textFieldInfo becomeFirstResponder];
        
    } else if (textField.tag == CourseTextFieldNameCourse) {
        [textField resignFirstResponder];
        
        ECCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0]];
        [cell.textFieldInfo becomeFirstResponder];
        
    } else if (textField.tag == CourseTextFieldSubjectCourse) {
            [textField resignFirstResponder];
    }
    
    return YES;
}

#pragma mark - ECSelectedItemsViewControllerDelegate

- (void)didDoneSelectedItems:(id)items forTypeItem:(TypeItem)typeItem {

    if (typeItem == TeacherItem) {
        self.course.teacher = items;
    } else if (typeItem == StudentItem) {
        self.course.students = items;
    }
}

@end
