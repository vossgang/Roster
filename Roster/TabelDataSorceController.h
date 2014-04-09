//
//  TabelDataSorceController.h
//  Roster
//
//  Created by Matthew Voss on 4/9/14.
//  Copyright (c) 2014 Matthew Voss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"
#import "PersonTableViewCell.h"

@interface TabelDataSorceController : NSObject <UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *students;
@property (nonatomic, strong) NSMutableArray *teachers;

@property (nonatomic, strong) NSMutableArray *allPeople;

@property (nonatomic, strong) NSArray *studentFirstNameArray;
@property (nonatomic, strong) NSArray *studentLastNameArray;
@property (nonatomic, strong) NSArray *teacherFirstNameArray;
@property (nonatomic, strong) NSArray *teacherLastNameArray;


-(void)sortArrayByFirstName;
-(void)sortArrayByLastName;
-(void)populateArrays;
-(void)saveToFile;

@end
