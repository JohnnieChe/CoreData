//
//  ECCoreDataManager.h
//  Homework44
//
//  Created by Евгений Чемоданов on 12.12.2017.
//  Copyright © 2017 Eugene Chemodanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface ECCoreDataManager : NSObject

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;

+ (ECCoreDataManager *)sharedManager;

@end
