//
//  ECAlert.h
//  Homework44
//
//  Created by Евгений Чемоданов on 14.12.2017.
//  Copyright © 2017 Eugene Chemodanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ECAlert : NSObject

+ (UIAlertController *)checkInfo;
+ (UIAlertController *)checkFormatForCell:(NSString *)string;

@end
