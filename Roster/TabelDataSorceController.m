//
//  TabelDataSorceController.m
//  Roster
//
//  Created by Matthew Voss on 4/9/14.
//  Copyright (c) 2014 Matthew Voss. All rights reserved.
//

#import "TabelDataSorceController.h"


@implementation TabelDataSorceController

-(id)init
{
    self = [super init];
    
    if (self) {
        
        [self setUpData];

    }
    
    return self;
}

-(void)setUpData
{
    [self loadFromFile];
    
    if (_allPeople) {
        [self populateArrays];
    } else {
        
        NSMutableArray *these = [NSMutableArray new];
        Person *thePerson = [Person new];
        [these addObject:thePerson];
        _allPeople = these;
    }

}

-(char)randChar
{
    char newChar;
    
    int i = ((arc4random() % 26) + 65);
    newChar = i;
    
    return newChar;
}

-(void)checkRandomPathFor:(Person *)person
{
    if (!person.randomPicturePathExtension) {
        NSString *randomSting = @"a";
        for (int i = 0; i < 16; i++) {
           randomSting = [NSString stringWithFormat:@"%@%c", randomSting, [self randChar]];
        }
        person.randomPicturePathExtension = randomSting;
    }
}

-(void)populateArrays
{
    NSMutableArray *students = [NSMutableArray new];
    NSMutableArray *teachers = [NSMutableArray new];
    NSMutableArray *all      = [NSMutableArray new];
    
    for (Person *person in _allPeople) {
        if (![person.fullName isEqualToString:@"DELETE ME"]) {
            [self checkRandomPathFor:person];
            if (person.personType == teacher) {
                [teachers addObject:person];
            } else if (person.personType == student){
                [students addObject:person];
            }
            
        } else {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSError *error = NULL;
            [fileManager removeItemAtPath:person.picturePath error:&error];
            if (error) {
                 NSLog(@"Could not delete picture -:%@ ",[error localizedDescription]);
            }
        }
    }
    _students = students;
    _teachers = teachers;
    [all addObjectsFromArray:_teachers];
    [all addObjectsFromArray:_students];
    _allPeople = all;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return personTypeCount;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == student) {
        return @"Students";
    }
    return @"Teachers";
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    Person *thisPerson = [Person new];
    
    if (indexPath.section) {
        thisPerson = _students[indexPath.row];
    } else {
        thisPerson = _teachers[indexPath.row];
    }
    if (thisPerson.userBlueColor || thisPerson.userGreenColor || thisPerson.userRedColor) {
        cell.backgroundColor = thisPerson.userBGColor;
    } else {
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    cell.nameLabel.text = thisPerson.fullName;
    if (thisPerson.personPicture) {
        cell.personPicture.image = thisPerson.personPicture;
    } else {
        cell.personPicture.image = [UIImage imageNamed:@"default.jpg"];
    }
    cell.personPicture.layer.cornerRadius = cell.personPicture.frame.size.width / 3;
    cell.personPicture.layer.masksToBounds = YES;
    
    cell.clipsToBounds = YES;
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == student) {
        return _students.count;
    }
    
    return _teachers.count;
}


-(void)sortArrayByFirstName
{
    NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    _students = [[_students sortedArrayUsingDescriptors:@[sorter]] mutableCopy];
    _teachers = [[_teachers sortedArrayUsingDescriptors:@[sorter]] mutableCopy];
    NSMutableArray *everyone = [NSMutableArray new];
    [everyone addObjectsFromArray:_students];
    [everyone addObjectsFromArray:_teachers];
    _allPeople = everyone;
}

-(void)sortArrayByLastName
{
    NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
    _students = [[_students sortedArrayUsingDescriptors:@[sorter]] mutableCopy];
    _teachers = [[_teachers sortedArrayUsingDescriptors:@[sorter]] mutableCopy];
    NSMutableArray *everyone = [NSMutableArray new];
    [everyone addObjectsFromArray:_students];
    [everyone addObjectsFromArray:_teachers];
    _allPeople = everyone;
}

-(void)saveToFile
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"save.plist"];
    [NSKeyedArchiver archiveRootObject:_allPeople toFile:appFile];
}

-(void)loadFromFile
{

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"save.plist"];
    
    NSMutableArray *myArray = [NSMutableArray new];
    myArray  = [NSKeyedUnarchiver unarchiveObjectWithFile:appFile];
    if (!myArray) {
        NSString *pathForPlistInBudle = [[NSBundle mainBundle] pathForResource:@"save" ofType:@"plist"];
        
        myArray = [NSKeyedUnarchiver unarchiveObjectWithFile:pathForPlistInBudle];
        
        [self saveToFile];
    }
    
    _allPeople = myArray;
    
}


-(NSString *)applicaitionDocumentsDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) firstObject];
}

-(BOOL)checkForPlistFileInDocs
{
    NSError *error;
    
    NSFileManager *myManager = [NSFileManager defaultManager];
    
    
    NSString *pathForPlistInBudle = [[NSBundle mainBundle] pathForResource:@"save" ofType:@"plist"];
    NSString *pathForPlistInDocs  = [self applicaitionDocumentsDirectory];
    
    [myManager copyItemAtPath:pathForPlistInBudle toPath:pathForPlistInDocs error:&error];
    
    if ([myManager fileExistsAtPath:pathForPlistInDocs]) {
        return  YES;
    }
    
    
    if (error) {
        NSLog(@"error %@", error.localizedDescription);
    } else {
        return YES;
    }
    return [myManager fileExistsAtPath:pathForPlistInDocs];
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    Person *thisPerson = [Person new];

    if (indexPath.section) {
        thisPerson = _students[indexPath.row];
    } else {
        thisPerson = _teachers[indexPath.row];
    }
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        thisPerson.firstName = @"DELETE";
        thisPerson.lastName = @"ME";
        [self populateArrays];
        [tableView reloadData];
    }
    
}


@end
