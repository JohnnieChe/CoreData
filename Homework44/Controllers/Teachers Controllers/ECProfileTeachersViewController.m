//
//  ECProfileTeachersViewController.m
//  Homework44
//
//  Created by Евгений Чемоданов on 24.12.2017.
//  Copyright © 2017 Eugene Chemodanov. All rights reserved.
//

#import "ECProfileTeachersViewController.h"
#import "ECAddTeachersViewController.h"

#import "ECCourse+CoreDataClass.h"

#import "ECCell.h"

@interface ECProfileTeachersViewController () <UITextFieldDelegate>

@end

@implementation ECProfileTeachersViewController

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
    
    UINavigationController *nav = [self.storyboard instantiateViewControllerWithIdentifier:@"ECAddTeachersNavigationViewController"];
    
    ECAddTeachersViewController *vc = (ECAddTeachersViewController *)nav.topViewController;
    vc.teacher = self.teacher;
    vc.managedObjectContext = self.managedObjectContext;
    vc.viewMode = EditMode;
    
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if ([self.teacher.courses count] > 0) {
        return 2;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return [self.teacher.courses count];
            break;
        default:
            return 0;
            break;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    switch (section) {
        case 1:
            return @"Courses";
            break;
        default:
            return @"";
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier;
    
    if (indexPath.section == 0) {
        identifier = @"TeacherInfo";
        ECCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        
        switch (indexPath.row) {
            case 0:
                cell.labelInfo.text = @"First name";
                cell.textFieldInfo.text = self.teacher.firstNameTeacher;
                break;
            case 1:
                cell.labelInfo.text = @"Last name";
                cell.textFieldInfo.text = self.teacher.lastNameTeacher;
                break;
        }
        
        cell.textFieldInfo.delegate = self;
        return cell;
        
    } else if (indexPath.section == 1) {
        ECCourse *course = [[self.teacher.courses allObjects] objectAtIndex:indexPath.row];
        
        identifier = @"TeacherCourses";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];

        cell.textLabel.text = course.nameCourse;
        
        return cell;
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}

@end
