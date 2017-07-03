//
//  FXFormAdvancedImageCell.m
//  Property Genie
//
//  Created by Timothy Roe Jr. on 6/29/17.
//  Copyright © 2017 Timothy Roe Jr. All rights reserved.
//

#import "FXFormAdvancedImageCell.h"

@interface FXFormAdvancedImagePickerCell () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, weak) UIViewController *controller;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) CLLocation *location;

@end

@implementation FXFormAdvancedImagePickerCell

- (void)setUp
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    self.accessoryView = imageView;
    [self setNeedsLayout];
}

- (void)dealloc
{
    _imagePickerController.delegate = nil;
}

- (void)layoutSubviews
{
    CGRect frame = self.imagePickerView.bounds;
    frame.size.height = self.bounds.size.height - 10;
    UIImage *image = self.imagePickerView.image;
    frame.size.width = image.size.height? image.size.width * (frame.size.height / image.size.height): 0;
    self.imagePickerView.bounds = frame;
    [super layoutSubviews];
}

- (void)update
{
    self.textLabel.text = [self dateValue];
    self.textLabel.accessibilityValue = self.textLabel.text;
    self.imagePickerView.image = [self imageValue];
    [self setNeedsLayout];
}

-(NSString *)dateValue {
    if (self.field.value) {
        return [self.field.value valueForKey:@"date"];
    } else {
        return nil;
    }
}

-(UIImage *)imageValue {
    if (self.field.value) {
        return [self.field.value valueForKey:@"image"];
    } else if (self.field.placeholder) {
        UIImage *placeholderImage = self.field.placeholder;
        if ([placeholderImage isKindOfClass:[NSString class]])
        {
            placeholderImage = [UIImage imageNamed:self.field.placeholder];
        }
        return placeholderImage;
    }
    return nil;
}

- (UIImagePickerController *)imagePickerController
{
    if (!_imagePickerController)
    {
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
        _imagePickerController.allowsEditing = YES;
    }
    return _imagePickerController;
}

- (UIImageView *)imagePickerView
{
    return (UIImageView *)self.accessoryView;
}

- (void)didSelectWithTableView:(UITableView *)tableView controller:(UIViewController *)controller
{
    //[FXFormsFirstResponder(tableView) resignFirstResponder];
    [self resignFirstResponder];
    [tableView deselectRowAtIndexPath:tableView.indexPathForSelectedRow animated:YES];
    
    if (!TARGET_IPHONE_SIMULATOR && ![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [controller presentViewController:self.imagePickerController animated:YES completion:nil];
    }
    else if ([UIAlertController class])
    {
        UIAlertControllerStyle style = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? UIAlertControllerStyleAlert: UIAlertControllerStyleActionSheet;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:style];
        
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Take Photo", nil) style:UIAlertActionStyleDefault handler:^(__unused UIAlertAction *action) {
            [self actionSheet:nil didDismissWithButtonIndex:0];
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Photo Library", nil) style:UIAlertActionStyleDefault handler:^(__unused UIAlertAction *action) {
            [self actionSheet:nil didDismissWithButtonIndex:1];
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:NULL]];
        
        self.controller = controller;
        [controller presentViewController:alert animated:YES completion:NULL];
    }
    else
    {
        self.controller = controller;
        [[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Take Photo", nil), NSLocalizedString(@"Photo Library", nil), nil] showInView:controller.view];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"METADATA: %@", info[UIImagePickerControllerMediaMetadata]);
    self.image = info[UIImagePickerControllerEditedImage] ?: info[UIImagePickerControllerOriginalImage];
    
    NSURL *imageURL = info[UIImagePickerControllerReferenceURL];
    PHFetchResult *result = [PHAsset fetchAssetsWithALAssetURLs:@[imageURL] options:nil];
    PHAsset *asset = result.firstObject;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy"];
    self.date = [df stringFromDate:asset.creationDate];
    
    self.location = asset.location;
    
    self.field.value = @{@"image": self.image, @"date": self.date, @"location": self.location};
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    if (self.field.action) self.field.action(self);
    [self update];
}

- (void)actionSheet:(__unused UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    switch (buttonIndex)
    {
        case 0:
        {
            sourceType = UIImagePickerControllerSourceTypeCamera;
            break;
        }
        case 1:
        {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
        }
        default:
        {
            self.controller = nil;
            return;
        }
    }
    if ([UIImagePickerController isSourceTypeAvailable:sourceType])
    {
        self.imagePickerController.sourceType = sourceType;
        [self.controller presentViewController:self.imagePickerController animated:YES completion:nil];
    }
    self.controller = nil;
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end

