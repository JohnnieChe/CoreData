//
//  ECAlert.m
//  Homework44
//
//  Created by Евгений Чемоданов on 14.12.2017.
//  Copyright © 2017 Eugene Chemodanov. All rights reserved.
//

#import "ECAlert.h"

@implementation ECAlert

+ (UIAlertController *)checkFormatForCell:(NSString *)string {
    
    NSString *alertString = [NSString stringWithFormat:@"Wrong format of %@ field", string];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertString
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * action) {
                                                             nil;
                                                         }];
    
    [alert addAction:cancelAction];
    
    return alert;
}

+ (UIAlertController *)checkInfo {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Please enter all info"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Ok"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * action) {
                                                             nil;
                                                         }];
    
    [alert addAction:cancelAction];
    
    return alert;
}

@end
