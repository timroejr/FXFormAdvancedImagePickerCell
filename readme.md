FXFormAdvancedImagePickerCell
------------------------
'FXFormAdvancedImagePickerCell' is a modification to 'FXFormImagePickerCell' provided in [FXForms](https://github.com/nicklockwood/FXForms).

'FXFormAdvancedImagePickerCell' is made to get a image from the user, and create a Dictionary that contains a UIImage, NSString for a date, and CLLocation taken directly from the UIImage.
The Dictionary is sent back the the main FXFormViewController as a 'NSArray' with 'NSDictionary's inside of it.

Installation
--------------
'FXForms' needs to already be copied to the target you intend to use 'FXFormAdvancedImagePickerCell' on.
'FXFormAdvancedImagePickerCell' requires CoreLocation and Photos. Import these into your target as well.
Finally copy 'FXFormAdvancedImagePickerCell' right into your target.

Usage
-------
To Use FXFormAdvancedImagePickerCell in your FXForm first create a new form by subclassing NSObject with a delegate of '<FXForm>'
''''objc
#import "FXForms.h"
@interface MyForm : NSObject <FXForm>

@end
''''

Create a new property of a 'NSArray' to store data from the Cell
''''objc
#import "FXForms.h"
@interface MyForm : NSObject <FXForm>

@property (nonatomic, strong) NSArray *photos;

@end
''''

In your .m file, you can create the Cell by using the following in your '-(NSArray *)fields' method:
''''objc
-(NSArray *)fields {
	return @[@{FXFormFieldKey: @"photos", FXFormFieldTemplate:@[@{FXFormFieldType: FXFormFieldTypeImage, FXFormFieldTitle: @"Add Photo", FXFormFieldCell: [FXFormAdvancedImagePickerCell class]}];
}
''''

It's as simple as that!

License
--------
Copyright (c) 2017 Timothy E. Roe, Jr.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.


