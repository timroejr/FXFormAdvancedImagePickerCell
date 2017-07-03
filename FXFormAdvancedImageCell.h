//
//  FXFormAdvancedImageCell.h
//  Property Genie
//
//  Created by Timothy Roe Jr. on 6/29/17.
//  Copyright © 2017 Timothy Roe Jr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "FXForms.h"
#import <Photos/Photos.h>

@interface FXFormAdvancedImagePickerCell : FXFormBaseCell

@property (nonatomic, readonly) UIImageView *imagePickerView;
@property (nonatomic, readonly) UIImagePickerController *imagePickerController;

@end
