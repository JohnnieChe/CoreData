//
//  ECAddStudentsViewController.m
//  Homework44
//
//  Created by Евгений Чемоданов on 12.12.2017.
//  Copyright © 2017 Eugene Chemodanov. All rights reserved.
//

#import "ECAddStudentsViewController.h"
#import "ECCourse+CoreDataClass.h"
#import "ECCoreDataManager.h"

#import "ECBirthDayViewController.h"
#import "ECSelectedItemsViewController.h"
#import "ECStudentsViewController.h"

#import "ECCell.h"
#import "ECAlert.h"

typedef enum {
    StudentTextFieldFirstName,
    StudentTextFieldLastName,
    StudentTextFieldEmail,
    StudentTextFieldBirthday
} StudentTextFieldTag;

@interface ECAddStudentsViewController () <UITextFieldDelegate, ECBirthViewControllerDelegate, ECSelectedItemsViewControllerDelegate>

@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) ECCoreDataManager *dataManager;

@end

@implementation ECAddStudentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dateFormatter = [NSDateFormatter new];
    self.dateFormatter.dateFormat = @"dd.MM.yyyy";
    
    self.dataManager = (ECCoreDataManager *)[ECCoreDataManager sharedManager];
    
    if (self.viewMode == AddMode) {
        
        self.navigationItem.title = @"Add student";
        
        ECStudent *student = [NSEntityDescription insertNewObjectForEntityForName:@"ECStudent"
                                                           inManagedObjectContext:self.managedObjectContext];
        self.student = student;
    
    } else {
        self.navigationItem.title = @"Edit student";
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

#pragma mark - ECBirthViewControllerDelegate

- (void)dateChanged:(NSDate *)newDate {
    
    self.date = newDate;
    self.student.birthDayStudent = [self.dateFormatter stringFromDate:newDate];
    
    ECCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    cell.textFieldInfo.text = self.student.birthDayStudent;
}

#pragma mark - Actions

- (IBAction)actionCancel:(UIBarButtonItem *)sender {
    [self.managedObjectContext rollback];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionDone:(UIBarButtonItem *)sender {
    
    if ([self isStudentInfoValid]) {
        
        if ([self isDoneMailString:[self mail]]) {
            self.student.firstNameStudent = [self firstName];
            self.student.lastNameStudent = [self lastName];
            self.student.mail = [self mail];
            self.student.birthDayStudent = [self birthDay];
            
            [self.dataManager saveContext];
            [self dismissViewControllerAnimated:YES completion:nil];
       
        } else {
            ECCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
            NSString *cellString = cell.labelInfo.text;
            
            [self presentViewController:[ECAlert checkFormatForCell:cellString]
                               animated:YES
                             completion:nil];
        }
        
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
            return 1 + [self.student.courses count];
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
        static NSString *identifier = @"StudentCell";
        ECCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        
            if (indexPath.row == 0) {
                cell.labelInfo.text = @"First name";
                cell.textFieldInfo.placeholder = @"Ivan";
                cell.textFieldInfo.tag = StudentTextFieldFirstName;
                cell.textFieldInfo.keyboardType = UIKeyboardTypeDefault;
                cell.textFieldInfo.autocapitalizationType = UITextAutocapitalizationTypeWords;
                cell.textFieldInfo.returnKeyType = UIReturnKeyNext;
             
                if (self.viewMode == EditMode) {
                    cell.textFieldInfo.text = self.student.firstNameStudent;
                }
                
            } else if (indexPath.row == 1) {
                cell.labelInfo.text = @"Last name";
                cell.textFieldInfo.placeholder = @"Ivanov";
                cell.textFieldInfo.tag = StudentTextFieldLastName;
                cell.textFieldInfo.keyboardType = UIKeyboardTypeDefault;
                cell.textFieldInfo.autocapitalizationType = UITextAutocapitalizationTypeWords;
                cell.textFieldInfo.returnKeyType = UIReturnKeyNext;
                
                if (self.viewMode == EditMode) {
                    cell.textFieldInfo.text = self.student.lastNameStudent;
                }
                
            } else if (indexPath.row == 2) {
                cell.labelInfo.text = @"Email";
                cell.textFieldInfo.placeholder = @"mail@gmail.com";
                cell.textFieldInfo.tag = StudentTextFieldEmail;
                cell.textFieldInfo.keyboardType = UIKeyboardTypeEmailAddress;
                cell.textFieldInfo.autocapitalizationType = UITextAutocapitalizationTypeNone;
                cell.textFieldInfo.returnKeyType = UIReturnKeyDone;
                
                if (self.viewMode == EditMode) {
                    cell.textFieldInfo.text = self.student.mail;
                }
                
            } else if (indexPath.row == 3) {
                cell.labelInfo.text = @"Birthday";
                cell.textFieldInfo.placeholder = @"01.01.1900";
                cell.textFieldInfo.tag = StudentTextFieldBirthday;
                
                if (self.viewMode == EditMode) {
                    cell.textFieldInfo.text = self.student.birthDayStudent;
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
            
            ECCourse *course = [[self.student.courses allObjects] objectAtIndex:(indexPath.row - 1)];
            cell.textLabel.text = course.nameCourse;
            
            return cell;
        }
    
    } else if (indexPath.section == 2) {
        static NSString *identifier = @"DeleteStudentCell";
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

- (NSString *)mail {
    
    ECCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    NSString *mail = cell.textFieldInfo.text;
    
    return mail;
}

- (NSString *)birthDay {
    
    ECCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    NSString *birthDay = cell.textFieldInfo.text;
    
    return birthDay;
}

- (BOOL)isStudentInfoValid {
    
    NSString *firstName= [self firstName];
    if (!firstName || [firstName isEqualToString:@""]) {
        return NO;
    }
    
    NSString *lastName = [self lastName];
    if (!lastName || [lastName isEqualToString:@""]) {
        return NO;
    }
    
    NSString *mail = [self mail];
    if (!mail || [mail isEqualToString:@""]) {
        return NO;
    }
    
    return YES;
}

- (void)addCourse:(UITableViewCell *)sender {

    ECSelectedItemsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ECSelectedItemsViewController"];
    vc.preferredContentSize = CGSizeMake(500, 300);
    vc.typeItem = CourseItem;
    vc.typeSelect = MultiSelect;
    vc.selectedItems = [self.student.courses mutableCopy];
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

- (void)deleteStudentWithConfirmation:(BOOL)confirmation {
    
    if (confirmation == YES) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are you sure to delete student?"
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete"
                                                               style:UIAlertActionStyleDestructive
                                                             handler:^(UIAlertAction * action) {
                                                                 [self deleteStudent];
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
        [self deleteStudent];
    }
}

- (void)deleteStudent {
    [self.managedObjectContext deleteObject:self.student];
    [self.dataManager saveContext];
}

- (void)actionDateOfBirthPopover:(UITextField *)sender {
    
    ECBirthDayViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ECBirthDayViewController"];
    vc.preferredContentSize = CGSizeMake(500, 300);
    vc.delegate = self;
    vc.date = [self.dateFormatter dateFromString:self.student.birthDayStudent];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationPopover;
    
    UIPopoverPresentationController *popController = [nav popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    popController.delegate = self;
    popController.sourceView = sender;
    popController.sourceRect = CGRectMake(CGRectGetMidX(sender.bounds),
                                          CGRectGetMaxY(sender.bounds),
                                          0, 0);
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                          target:self
                                                                          action:@selector(actionBirthdayDismiss)];

    vc.navigationItem.rightBarButtonItem = doneButton;

    [self presentViewController:nav
                       animated:YES
                     completion:nil];
}

- (void)actionBirthdayDismiss {
    
    if (!self.student.birthDayStudent) {
        self.student.birthDayStudent = [self.dateFormatter stringFromDate:[NSDate date]];
        
        ECCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        cell.textFieldInfo.text = self.student.birthDayStudent;
    }
    
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (void)actionDismiss {
    
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (BOOL)isDoneMailString:(NSString *)string {
    
    NSArray *components = [string componentsSeparatedByString:@"@"];
    
    if ([components count] != 2) {
        return NO;
    } else if ([(NSString *)components[0] length] == 0) {
        return NO;
    } else if ([(NSString *)components[1] length] == 0) {
        return NO;
    }
    
    NSArray *componentsSeparatedByDotBeforeAt = [(NSString *)components[0] componentsSeparatedByString:@"."];
    NSArray *componentsSeparatedByDotAfterAt = [(NSString *)components[1] componentsSeparatedByString:@"."];
    
    if ([componentsSeparatedByDotAfterAt count] == 1) {
        return NO;
    }
    
    for (NSString *component in componentsSeparatedByDotBeforeAt) {
        if ([component length] == 0) {
            return NO;
            break;
        }
    }
    
    for (NSString *component in componentsSeparatedByDotAfterAt) {
        if (![component isEqual:componentsSeparatedByDotAfterAt[0]] && [component length] < 2) {
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)checkStringBeforePrint:(NSString *)string {

    NSCharacterSet *lettersSet = [NSCharacterSet characterSetWithCharactersInString:@"1234567890abcdefghijklmnopqrstuvwxyz"];
    
    NSArray *arrayForNewString = [string componentsSeparatedByCharactersInSet:[lettersSet invertedSet]];
    
    NSInteger arrayCount = [arrayForNewString count];
    
    NSString *preLastComponentString = arrayCount == 1 ? (NSString *)arrayForNewString[0] : (NSString *)arrayForNewString[arrayCount - 2];
    
    if (preLastComponentString.length == 0) {
        return NO;
    }

    return YES;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [self addCourse:cell];
    
    } else if (indexPath.section == 2 && indexPath.row == 0) {
        [self deleteStudentWithConfirmation:YES];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.tag == StudentTextFieldFirstName) {
        [textField resignFirstResponder];
        
        ECCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
        [cell.textFieldInfo becomeFirstResponder];
    
    } else if (textField.tag == StudentTextFieldLastName) {
        [textField resignFirstResponder];
        
        ECCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0]];
        [cell.textFieldInfo becomeFirstResponder];
    
    } else if (textField.tag == StudentTextFieldEmail) {
        if (![self isDoneMailString:[self mail]]) {
            ECCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
            NSString *cellString = cell.labelInfo.text;
            
            [self presentViewController:[ECAlert checkFormatForCell:cellString]
                               animated:YES
                             completion:nil];
            
        } else {
            [textField resignFirstResponder];
        }
    }
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (textField.tag == StudentTextFieldBirthday) {
        [self actionDateOfBirthPopover:textField];
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField.tag == StudentTextFieldEmail) {
        
        NSCharacterSet *validationSet = [[NSCharacterSet characterSetWithCharactersInString:@".-_@1234567890abcdefghijklmnopqrstuvwxyz"] invertedSet];
        
        NSArray *components = [string componentsSeparatedByCharactersInSet:validationSet];
        
        NSInteger lengthString = 20;
        
        if ([components count] == 1) {
            NSString *resultString = [textField.text stringByReplacingCharactersInRange:range withString:string];
            NSArray *validComponents = [resultString componentsSeparatedByString:@"@"];
            
            if ([validComponents count] <= 2 && resultString.length <= lengthString) {
                if ([self checkStringBeforePrint:resultString]) {
                    textField.text = resultString;
                }
            }
        }
        
        return NO;
        
    } else {
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
    
    return YES;
}

#pragma mark - ECSelectedItemsViewControllerDelegate

- (void)didDoneSelectedItems:(id)items forTypeItem:(TypeItem)typeItem {
    self.student.courses = items;
}

@end
