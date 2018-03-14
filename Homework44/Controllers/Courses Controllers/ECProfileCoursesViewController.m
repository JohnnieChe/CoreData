//
//  ECProfileCoursesViewController.m
//  Homework44
//
//  Created by Евгений Чемоданов on 22.12.2017.
//  Copyright © 2017 Eugene Chemodanov. All rights reserved.
//

#import "ECProfileCoursesViewController.h"
#import "ECAddCoursesViewController.h"
#import "ECProfileStudentsViewController.h"
#import "ECSelectedItemsViewController.h"

#import "ECStudent+CoreDataClass.h"
#import "ECTeacher+CoreDataClass.h"

#import "ECCell.h"

@interface ECProfileCoursesViewController () <UITextFieldDelegate>

@end

@implementation ECProfileCoursesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                                target:self
                                                                                action:@selector(actionEditButton)];
    
    self.navigationItem.rightBarButtonItem = editButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.tableView reloadData];
}

- (void)actionEditButton {
    
    UINavigationController *nav = [self.storyboard instantiateViewControllerWithIdentifier:@"ECAddCoursesNavigationViewController"];
    
    ECAddCoursesViewController *vc = (ECAddCoursesViewController *)nav.topViewController;
    vc.course = self.course;
    vc.managedObjectContext = self.managedObjectContext;
    vc.viewMode = EditMode;
    
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if ([self.course.students count] > 0) {
        return 2;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        if (self.course.teacher) {
            return 4;
        } else {
            return 3;
        }
    } else if (section == 1) {
        return [self.course.students count];
    }
    
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    switch (section) {
        case 1:
            return @"Students";
            break;
        default:
            return @"";
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier;
    
    if (indexPath.section == 0) {
        if (indexPath.row != 3) {
            identifier = @"CourseInfo";
            ECCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            
            switch (indexPath.row) {
                case 0:
                    cell.labelInfo.text = @"Branch";
                    cell.textFieldInfo.text = self.course.branchCourse;
                    break;
                case 1:
                    cell.labelInfo.text = @"Name";
                    cell.textFieldInfo.text = self.course.nameCourse;
                    break;
                case 2:
                    cell.labelInfo.text = @"Subject";
                    cell.textFieldInfo.text = self.course.subjectCourse;
                    break;
            }
            
            cell.textFieldInfo.delegate = self;
            return cell;
            
        } else {
            identifier = @"TeacherInfo";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            
            cell.textLabel.text = @"Teacher";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", self.course.teacher.firstNameTeacher, self.course.teacher.lastNameTeacher];
            
            return cell;
        }
        
    } else if (indexPath.section == 1) {
        ECStudent *student = [self.course.students allObjects][indexPath.row];
        
        identifier = @"StudentInfo";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", student.firstNameStudent, student.lastNameStudent];
        
        return cell;
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        ECProfileStudentsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ECProfileStudentsViewController"];
        
        ECStudent *student = [self.course.students allObjects][indexPath.row];
        vc.student = student;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}

@end
