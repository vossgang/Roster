//
//  PersonDetailViewController.m
//  Roster
//
//  Created by Matthew Voss on 4/7/14.
//  Copyright (c) 2014 Matthew Voss. All rights reserved.
//

#import "PersonDetailViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface PersonDetailViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;
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
    
    _fullNameLabel.text = _detailPerson.fullName;
    _pictureOfPerson.image = _detailPerson.personPicture;
    
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        _actionSheet = [[UIActionSheet alloc] initWithTitle:@"Photos" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Choose Photo", @"Take Photo", nil];
        } else {
            _actionSheet = [[UIActionSheet alloc] initWithTitle:@"Photos" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Choose Photo", nil];
    }
    
    
    // Do any additional setup after loading the view.
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
        
        ALAssetsLibrary  *assestsLibrary = [ALAssetsLibrary new];
        
        if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusAuthorized || ALAuthorizationStatusNotDetermined) {
            
            [assestsLibrary writeImageToSavedPhotosAlbum:orginalImage.CGImage
                                             orientation:ALAssetOrientationUp
                                         completionBlock:^(NSURL *assetURL, NSError *error) {
                                             if (error) {
                                                 NSLog(@"Error %@", error.localizedDescription);
                                             }
                                         }];
//no possible way to hit this code...? since we just finished picking an image we know we have access to images
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
        
    }];
    
    
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
