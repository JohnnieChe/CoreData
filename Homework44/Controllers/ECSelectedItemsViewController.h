//
//  ECSelectedItemsViewController.h
//  Homework44
//
//  Created by Евгений Чемоданов on 15.12.2017.
//  Copyright © 2017 Eugene Chemodanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECCoreDataViewController.h"

typedef enum {
    SingleSelect,
    MultiSelect,
} TypeSelect;

typedef enum {
    StudentItem,
    CourseItem,
    TeacherItem,
} TypeItem;

@protocol ECSelectedItemsViewControllerDelegate;

@interface ECSelectedItemsViewController : ECCoreDataViewController

@property (weak, nonatomic) id <ECSelectedItemsViewControllerDelegate> delegate;

@property (assign, nonatomic) TypeSelect typeSelect;
@property (assign, nonatomic) TypeItem typeItem;
@property (strong, nonatomic) NSMutableSet *selectedItems;

@end

@protocol ECSelectedItemsViewControllerDelegate <NSObject>
- (void)didDoneSelectedItems:(id)items forTypeItem:(TypeItem)typeItem;
@end
