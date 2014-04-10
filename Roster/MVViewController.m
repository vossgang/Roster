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
#import "TabelDataSorceController.h"

@interface MVViewController () <UITabBarControllerDelegate, UIActionSheetDelegate>


@property (nonatomic, strong) TabelDataSorceController  *myDataSorce;

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UIActionSheet *actionSheet;

@end

@implementation MVViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _myDataSorce = [TabelDataSorceController new];
        
    _tableView.dataSource = _myDataSorce;
    
    
    _actionSheet = [[UIActionSheet alloc] initWithTitle:@"Sort Cells by" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"First Name", @"Last Name", nil];

	// Do any additional setup after loading the view, typically from a nib.
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_myDataSorce populateArrays];
    [_tableView reloadData];
    [_myDataSorce saveToFile];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    Person *thisPerson = [Person new];

    
    
        if ([segue.identifier isEqualToString:@"showPersonSegue"]) {
            NSIndexPath *path = [self.tableView indexPathForSelectedRow];
            
            if (path.section == student) {
                
                thisPerson = [[_myDataSorce students] objectAtIndex:path.row];
            } else {
                thisPerson = [[_myDataSorce teachers] objectAtIndex:path.row];
            }
            
            PersonDetailViewController *destVC = segue.destinationViewController;
            destVC.title = thisPerson.fullName;
            destVC.detailPerson = thisPerson;
        } else if ([segue.identifier isEqualToString:@"addPerson"]){
            PersonDetailViewController *destVC = segue.destinationViewController;
            
            thisPerson.personType = student;
            [_myDataSorce.allPeople  addObject:thisPerson];
            
            if (thisPerson.firstName && thisPerson.lastName) {
                destVC.title = thisPerson.fullName;
            } else {
                destVC.title = @"New Person";
            }
            
            destVC.detailPerson = thisPerson;
        }
    
}


- (IBAction)sortCells:(id)sender
{
        [self.actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"First Name"]) {
        [_myDataSorce sortArrayByFirstName];
        [_tableView reloadData];
    } else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Last Name"]) {
        [_myDataSorce sortArrayByLastName];
        [_tableView reloadData];

    }
}

@end