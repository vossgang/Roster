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

@interface PersonDetailViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *lastNameLabel;
@property (weak, nonatomic) IBOutlet UISwitch *PersontypeSwitch;

@property (weak, nonatomic) IBOutlet UITextField *firstNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pictureOfPerson;
@property (nonatomic, strong) UIActionSheet *actionSheet;
@property (weak, nonatomic) IBOutlet UITextField *twitterLabel;
@property (weak, nonatomic) IBOutlet UITextField *githubLabel;

@property (weak, nonatomic) IBOutlet UILabel *teacherStudentLabel;
@property (weak, nonatomic) IBOutlet UISlider *redValue;
@property (weak, nonatomic) IBOutlet UISlider *blueValue;
@property (weak, nonatomic) IBOutlet UISlider *greenValue;

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapping;

@end

@implementation PersonDetailViewController

- (IBAction)changePersonType:(id)sender
{
    
    _detailPerson.personType = _PersontypeSwitch.isOn;
    
    if (_PersontypeSwitch.isOn) {
        _teacherStudentLabel.text = @"Student";
    } else {
        _teacherStudentLabel.text = @"Teacher";
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _tapping.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _lastNameLabel.delegate = self;
    _firstNameLabel.delegate = self;
    _githubLabel.delegate = self;
    _twitterLabel.delegate = self;
    
    
    _firstNameLabel.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:.8];
    _lastNameLabel.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:.8];
    _githubLabel.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:.8];
    _twitterLabel.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:.8];
    
    
    if (_detailPerson.firstName) {
        _firstNameLabel.text = _detailPerson.firstName;
    }
    
    if (_detailPerson.lastName) {
        _lastNameLabel.text = _detailPerson.lastName;
    }
    
    if (_detailPerson.twitterUserName) {
        _twitterLabel.text = _detailPerson.twitterUserName;
    }
    
    if (_detailPerson.githubUserName) {
        _githubLabel.text = _detailPerson.githubUserName;
    }
    
    [_PersontypeSwitch setOn:_detailPerson.personType];
    
    if (_detailPerson.personPicture) {
        _pictureOfPerson.image = _detailPerson.personPicture;
    } else {
        _pictureOfPerson.image = [UIImage imageNamed:@"default.jpg"];
    }
    
    if (_detailPerson.personType) {
        [_PersontypeSwitch setOn:YES];
        _teacherStudentLabel.text = @"Student";
    } else {
        [_PersontypeSwitch setOn:NO];
        _teacherStudentLabel.text = @"Teacher";
    }
        
    if (_detailPerson.userRedColor || _detailPerson.userGreenColor || _detailPerson.userBlueColor) {
        self.topView.backgroundColor = _detailPerson.userBGColor;
        _greenValue.value = _detailPerson.userGreenColor;
        _redValue.value = _detailPerson.userRedColor;
        _blueValue.value = _detailPerson.userBlueColor;
    }
    
    _pictureOfPerson.layer.cornerRadius = _pictureOfPerson.frame.size.width / 3;
    _pictureOfPerson.layer.masksToBounds = YES;
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    _detailPerson.firstName = _firstNameLabel.text;
    _detailPerson.lastName  = _lastNameLabel.text;
    _detailPerson.twitterUserName = _twitterLabel.text;
    _detailPerson.githubUserName = _githubLabel.text;
}

- (IBAction)choosePhoto:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        _actionSheet = [[UIActionSheet alloc] initWithTitle:@"Photos" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Choose Photo", @"Take Photo", nil];
    } else {
        _actionSheet = [[UIActionSheet alloc] initWithTitle:@"Photos" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Choose Photo", nil];
    }
    
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
    
    [_scrollView setContentOffset:CGPointMake(0, 0) animated: YES];

    
    self.title  = [NSString stringWithFormat:@"%@ %@", _firstNameLabel.text, _lastNameLabel.text];
    
    return YES;
}

- (IBAction)deleteCurrentPerson:(id)sender
{
    _firstNameLabel.text = @"DELETE";
    _lastNameLabel.text  = @"ME";
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    self.title  = [NSString stringWithFormat:@"%@ %@", _firstNameLabel.text, _lastNameLabel.text];
//    
//    [self.topView endEditing:YES];
//    
//}

-(IBAction)sharePhoto:(id)sender
{
    UIActivityViewController *ActVc = [[UIActivityViewController alloc] initWithActivityItems:@[_detailPerson.personPicture] applicationActivities:nil];
    [self presentViewController:ActVc animated:YES completion:nil];
    
}


- (IBAction)changeBGValue:(id)sender
{
    
    _detailPerson.userRedColor = _redValue.value;
    _detailPerson.userBlueColor = _blueValue.value;
    _detailPerson.userGreenColor = _greenValue.value;
    
    
//    _greenValue.tintColor = [UIColor colorWithRed:0 green:_greenValue.value blue:0 alpha:1];
//    _redValue.tintColor = [UIColor colorWithRed:_redValue.value green:0 blue:0 alpha:1];
//    _blueValue.tintColor = [UIColor colorWithRed:0 green:0 blue:_blueValue.value alpha:1];
    
    _detailPerson.userBGColor = [UIColor colorWithRed:_detailPerson.userRedColor green:_detailPerson.userGreenColor blue:_detailPerson.userBlueColor alpha:1];
    self.topView.backgroundColor = _detailPerson.userBGColor;

}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [_scrollView setContentOffset:CGPointMake(0, textField.frame.size.height) animated: YES];
    
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    for (UITextField *text in self.topView.subviews) {
        [self textFieldShouldReturn:text];
    }
    
   CGPoint tapPoint = [gestureRecognizer locationInView:_topView];
    
    if (CGRectContainsPoint(_pictureOfPerson.frame, tapPoint) && (!CGRectContainsPoint(_githubLabel.frame, tapPoint)) && (!CGRectContainsPoint(_firstNameLabel.frame, tapPoint)) && (!CGRectContainsPoint(_lastNameLabel.frame, tapPoint)) && (!CGRectContainsPoint(_twitterLabel.frame, tapPoint))) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            _actionSheet = [[UIActionSheet alloc] initWithTitle:@"Photos" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Choose Photo", @"Take Photo", nil];
        } else {
            _actionSheet = [[UIActionSheet alloc] initWithTitle:@"Photos" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Choose Photo", nil];
        }
        [self.actionSheet showInView:self.view];
    }
    
    return YES;
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
- (IBAction)shareOnSocialMedia:(id)sender
{
    NSString *twitter = @" ";
    if (_detailPerson.twitterUserName) {
        twitter = _detailPerson.twitterUserName;
    }
    
    if (_detailPerson.personPicture) {
        UIActivityViewController *actVC = [[UIActivityViewController alloc] initWithActivityItems:@[_detailPerson.personPicture, [NSURL URLWithString:twitter]] applicationActivities:nil];
        
        [self presentViewController:actVC animated:YES completion:nil];
    }
    
    
}

@end

