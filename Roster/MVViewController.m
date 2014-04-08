//
//  MVViewController.m
//  Roster
//
//  Created by Matthew Voss on 4/7/14.
//  Copyright (c) 2014 Matthew Voss. All rights reserved.
//

#import "MVViewController.h"
#import "PersonTableViewCell.h"
#import "Person.h"
#import "PersonDetailViewController.h"

@interface MVViewController () <UITabBarControllerDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *students;
@property (nonatomic, strong) NSMutableArray *teachers;

@property (nonatomic, strong) NSArray *studentFirstNameArray;
@property (nonatomic, strong) NSArray *studentLastNameArray;
@property (nonatomic, strong) NSArray *teacherFirstNameArray;
@property (nonatomic, strong) NSArray *teacherLastNameArray;

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end

@implementation MVViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tableView.dataSource = self;
    
    _studentFirstNameArray = @[@"Michael", @"Cole", @"Dan", @"Lauren", @"Sean", @"Taylor", @"Brian", @"Anton", @"Reed", @"Ryo", @"Chris", @"Matthew"];
    
    _studentLastNameArray = @[@"Babiy", @"Bratcher", @"Fairbanks", @"Lee", @"Mcneil", @"Potter", @"Radebaugh", @"Rivera", @"Sweeney", @"Tulman", @"Cohen", @"Voss"];
    
    _teacherFirstNameArray = @[@"John", @"Brad"];
    _teacherLastNameArray  = @[@"Clem", @"Johnson"];
    
    [self populatStudentArray];
    [self populateTeacherArray];
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)populatStudentArray
{
    NSMutableArray *group = [NSMutableArray new];
    
    for (int i = 0; i < _studentFirstNameArray.count; i++) {
        Person *thisPerson = [Person new];
        thisPerson.firstName = _studentFirstNameArray[i];
        thisPerson.lastName = _studentLastNameArray[i];
        
        thisPerson.personPicture = [UIImage imageNamed:@"addTime"];

        [group addObject:thisPerson];
    }
    
    _students = group;
}

-(void)populateTeacherArray
{
    NSMutableArray *group = [NSMutableArray new];
    for (int i = 0; i < _teacherFirstNameArray.count; i++) {
        Person *thisPerson = [Person new];
        thisPerson.firstName = _teacherFirstNameArray[i];
        thisPerson.lastName = _teacherLastNameArray[i];
        
        thisPerson.personPicture = [UIImage imageNamed:@"LivingCell.PNG"];
        
        [group addObject:thisPerson];
    }
    _teachers = group;
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
        
    cell.nameLabel.text = thisPerson.fullName;
    cell.personPicture.image = thisPerson.personPicture;
    
    return cell;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section) {
        return _students.count;
    }
    
    return _teachers.count;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    Person *thisPerson = [Person new];

    if (path.section) {
        thisPerson = _students[path.row];
    } else {
        thisPerson = _teachers[path.row];
    }
    
    if ([segue.identifier isEqualToString:@"showPersonSegue"]) {
        PersonDetailViewController *destVC = segue.destinationViewController;
        destVC.title = thisPerson.fullName;
        destVC.detailPerson = thisPerson;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section) {
        return @"Students";
    }
    return @"Teachers";
}


@end
