//
//  PersonDetailViewController.m
//  Roster
//
//  Created by Matthew Voss on 4/7/14.
//  Copyright (c) 2014 Matthew Voss. All rights reserved.
//

#import "PersonDetailViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "TabelDataSorceController.h"

@interface PersonDetailViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *lastNameLabel;
@property (weak, nonatomic) IBOutlet UISwitch *PersontypeSwitch;

@property (weak, nonatomic) IBOutlet UITextField *firstNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pictureOfPerson;
@property (nonatomic, strong) UIActionSheet *actionSheet;

@end

@implementation PersonDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _lastNameLabel.delegate = self;
    _firstNameLabel.delegate = self;
    
    _firstNameLabel.text = _detailPerson.firstName;
    _lastNameLabel.text = _detailPerson.lastName;
    [_PersontypeSwitch setOn:_detailPerson.personType];
    _pictureOfPerson.image = _detailPerson.personPicture;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        _actionSheet = [[UIActionSheet alloc] initWithTitle:@"Photos" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Choose Photo", @"Take Photo", nil];
        } else {
            _actionSheet = [[UIActionSheet alloc] initWithTitle:@"Photos" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Choose Photo", nil];
    }
}


-(void)viewWillDisappear:(BOOL)animated
{
    _detailPerson.firstName = _firstNameLabel.text;
    _detailPerson.lastName  = _lastNameLabel.text;
    _detailPerson.personType = _PersontypeSwitch.isOn;
}

- (IBAction)choosePhoto:(id)sender {
    [self.actionSheet showInView:self.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Take Photo"]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Choose Photo"]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        if ([ALAssetsLibrary authorizationStatus] == (ALAuthorizationStatusDenied || ALAuthorizationStatusRestricted)){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Photo Library access"
                                                                message:@"Acceses to Photo Library is not active, please go to setting to allow access"
                                                               delegate:nil
                                                      cancelButtonTitle:@"ok"
                                                      otherButtonTitles: nil];
            [alertView show];
        }
        
    } else {
        return;
    }
    
    [self presentViewController:imagePicker animated:YES completion:^{
        
    }];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{

    _pictureOfPerson.image = _detailPerson.personPicture = [info objectForKey:UIImagePickerControllerEditedImage];
    
    UIImage *orginalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    
        [self dismissViewControllerAnimated:YES completion:^{
            if (picker.sourceType != UIImagePickerControllerSourceTypePhotoLibrary) {

            ALAssetsLibrary  *assestsLibrary = [ALAssetsLibrary new];
        
            if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusAuthorized) {
            
                [assestsLibrary writeImageToSavedPhotosAlbum:orginalImage.CGImage
                                                 orientation:ALAssetOrientationUp
                                             completionBlock:^(NSURL *assetURL, NSError *error) {
                                                 if (error) {
                                                     NSLog(@"Error %@", error.localizedDescription);
                                                 }
                                             }];
            } else if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusDenied || ALAuthorizationStatusRestricted){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Cannot Save Photo"
                                                                    message:@"Acceses to Photo Library is not active, please go to setting to allow access"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"ok"
                                                          otherButtonTitles: nil];
                [alertView show];
            
            } else {
                //notdetermined
            }
            }
        }];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    self.title  = [NSString stringWithFormat:@"%@ %@", _firstNameLabel.text, _lastNameLabel.text];
    
    return YES;
}

- (IBAction)deleteCurrentPerson:(id)sender
{
    _firstNameLabel.text = @"DELETE";
    _lastNameLabel.text  = @"ME";
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
