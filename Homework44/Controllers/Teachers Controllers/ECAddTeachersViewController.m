//
//  ECAddTeachersViewController.m
//  Homework44
//
//  Created by Евгений Чемоданов on 24.12.2017.
//  Copyright © 2017 Eugene Chemodanov. All rights reserved.
//

#import "ECAddTeachersViewController.h"
#import "ECCourse+CoreDataClass.h"
#import "ECCoreDataManager.h"

#import "ECSelectedItemsViewController.h"
#import "ECCoursesViewController.h"

#import "ECCell.h"
#import "ECAlert.h"

typedef enum {
    TeacherTextFieldFirstName,
    TeacherTextFieldLastName
} TeacherTextFieldTag;

@interface ECAddTeachersViewController () <UITextFieldDelegate, ECSelectedItemsViewControllerDelegate>
@property (strong, nonatomic) ECCoreDataManager *dataManager;
@end

@implementation ECAddTeachersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataManager = (ECCoreDataManager *)[ECCoreDataManager sharedManager];
    
    if (self.viewMode == AddMode) {
        
        self.navigationItem.title = @"Add teacher";
        
        ECTeacher *teacher = [NSEntityDescription insertNewObjectForEntityForName:@"ECTeacher"
                                                           inManagedObjectContext:self.managedObjectContext];
        self.teacher = teacher;
        
    } else {
        self.navigationItem.title = @"Edit teacher";
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
    
    if ([self isTeacherInfoValid]) {
            self.teacher.firstNameTeacher = [self firstName];
            self.teacher.lastNameTeacher = [self lastName];

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
            return 2;
            break;
        case 1:
            return 1 + [self.teacher.courses count];
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
            return @"Courses";
            break;
        default:
            return @"";
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        static NSString *identifier = @"TeacherCell";
        ECCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        
        if (indexPath.row == 0) {
            cell.labelInfo.text = @"First name";
            cell.textFieldInfo.placeholder = @"Ivan";
            cell.textFieldInfo.tag = TeacherTextFieldFirstName;
            cell.textFieldInfo.keyboardType = UIKeyboardTypeDefault;
            cell.textFieldInfo.autocapitalizationType = UITextAutocapitalizationTypeWords;
            cell.textFieldInfo.returnKeyType = UIReturnKeyNext;
            
            if (self.viewMode == EditMode) {
                cell.textFieldInfo.text = self.teacher.firstNameTeacher;
            }
            
        } else if (indexPath.row == 1) {
            cell.labelInfo.text = @"Last name";
            cell.textFieldInfo.placeholder = @"Ivanov";
            cell.textFieldInfo.tag = TeacherTextFieldLastName;
            cell.textFieldInfo.keyboardType = UIKeyboardTypeDefault;
            cell.textFieldInfo.autocapitalizationType = UITextAutocapitalizationTypeWords;
            cell.textFieldInfo.returnKeyType = UIReturnKeyDone;
            
            if (self.viewMode == EditMode) {
                cell.textFieldInfo.text = self.teacher.lastNameTeacher;
            }
        }
        
        cell.textFieldInfo.delegate = self;
        return cell;
        
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            static NSString *identifier = @"EditCoursesCell";
            UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            
            return cell;
            
        } else {
            static NSString *identifier = @"CoursesCell";
            UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            
            ECCourse *course = [self.teacher.courses allObjects][indexPath.row - 1];
            cell.textLabel.text = course.nameCourse;
            
            return cell;
        }
        
    } else if (indexPath.section == 2) {
        static NSString *identifier = @"DeleteTeacherCell";
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        
        return cell;
        
    } else {
        return nil;
    }
}

#pragma mark - Private methods

- (NSString *)firstName {
    
    ECCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSString *firstName = cell.textFieldInfo.text;
    
    return firstName;
}

- (NSString *)lastName {
    
    ECCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSString *lastName = cell.textFieldInfo.text;
    
    return lastName;
}

- (BOOL)isTeacherInfoValid {
    
    NSString *firstName= [self firstName];
    if (!firstName || [firstName isEqualToString:@""]) {
        return NO;
    }
    
    NSString *lastName = [self lastName];
    if (!lastName || [lastName isEqualToString:@""]) {
        return NO;
    }
    
    return YES;
}

- (void)addCourse:(UITableViewCell *)sender {
    
    ECSelectedItemsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ECSelectedItemsViewController"];
    vc.preferredContentSize = CGSizeMake(500, 300);
    vc.typeItem = CourseItem;
    vc.typeSelect = MultiSelect;
    vc.selectedItems = [self.teacher.courses mutableCopy];
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

- (void)deleteTeacherWithConfirmation:(BOOL)confirmation {
    
    if (confirmation == YES) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are you sure to delete teacher?"
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete"
                                                               style:UIAlertActionStyleDestructive
                                                             handler:^(UIAlertAction * action) {
                                                                 [self deleteTeacher];
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
        [self deleteTeacher];
    }
}

- (void)deleteTeacher {
    [self.managedObjectContext deleteObject:self.teacher];
    [self.dataManager saveContext];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [self addCourse:cell];
    } else if (indexPath.section == 2 && indexPath.row == 0) {
        [self deleteTeacherWithConfirmation:YES];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.tag == TeacherTextFieldFirstName) {
        [textField resignFirstResponder];
        
        ECCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
        [cell.textFieldInfo becomeFirstResponder];
        
    } else if (textField.tag == TeacherTextFieldLastName) {
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    NSCharacterSet *validationSet = [[NSCharacterSet letterCharacterSet] invertedSet];
    NSArray *components = [string componentsSeparatedByCharactersInSet:validationSet];
    
    if ([components count] > 1) {
        return NO;
    } else {
        NSString *resultString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        textField.text = resultString;
    }
    
    return NO;
}

#pragma mark - ECSelectedItemsViewControllerDelegate

- (void)didDoneSelectedItems:(id)items forTypeItem:(TypeItem)typeItem {
    self.teacher.courses = items;
}

@end
