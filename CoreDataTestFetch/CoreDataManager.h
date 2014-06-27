//
//  CoreDataManager.h
//  CoreDataTest
//
//  Created by 马远征 on 13-12-19.
//  Copyright (c) 2013年 马远征. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FaceInfoEntity.h"


@interface CoreDataManager : NSObject
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (id)sharedInstance;
- (void)saveContext;
- (NSManagedObjectContext *)managedObjectContext;
- (NSURL *)applicationDocumentsDirectory;

- (BOOL)insertNewRecord:(NSMutableDictionary*)infoDic date:(NSDate*)date;

@end
