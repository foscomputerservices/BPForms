//
//  BPFormInputTextFieldCell.m
//
//  Copyright (c) 2014 Bogdan Poplauschi
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import "BPFormInputTextFieldCell.h"
#import <Masonry/Masonry.h>
#import "BPAppearance.h"

@interface BPFormInputTextFieldCell ()

@property (nonatomic, strong) MASConstraint *widthConstraint;
@property (nonatomic, strong) MASConstraint *heightConstraint;

@end


@implementation BPFormInputTextFieldCell

// auto-synthesize doesn't work here since the properties are defined in a base class (BPFormCell)
@synthesize spaceToNextCell = _spaceToNextCell;
@synthesize customContentHeight = _customContentHeight;
@synthesize customContentWidth = _customContentWidth;

+ (Class)textInputClass {
    return [BPFormTextField class];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupTextField];
            
        [self.contentView bringSubviewToFront:self.validationImageView];
    }
    return self;
}

- (void)setupTextField {
    Class textInputClass = [[self class] textInputClass];
    if (!textInputClass) {
        textInputClass = [BPFormTextField class];
    }

    self.textField = [[textInputClass alloc] init];

    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textField.textColor = [BPAppearance sharedInstance].inputCellTextFieldTextColor;
    self.textField.font = [BPAppearance sharedInstance].inputCellTextFieldFont;
    self.textField.backgroundColor = [BPAppearance sharedInstance].inputCellTextFieldBackgroundColor;

    self.textField.layer.borderColor = [BPAppearance sharedInstance].inputCellTextFieldBorderColor.CGColor;
    self.textField.layer.borderWidth = 0.5;

    [self.contentView addSubview:self.textField];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self.widthConstraint uninstall];
    [self.heightConstraint uninstall];
    
    [self.textField mas_updateConstraints:^(MASConstraintMaker *make) {
        CGFloat offset = self.mandatoryImageView.bounds.size.width + 5.0f;

        if (self.shouldShowFieldHelp) {
            offset += self.fieldHelpButton.bounds.size.width + 4.0f;
        }
        if (self.shouldShowValidation) {
            offset += self.validationImageView.bounds.size.width + 6.0f;
        }

        self.widthConstraint = make.width.equalTo(self.mas_width).offset(-offset);
        make.left.equalTo(self.mandatoryImageView.mas_right).offset(5.0f);
        make.top.equalTo(self.mas_top);
        self.heightConstraint = make.height.equalTo(self.mas_height).offset(-self.spaceToNextCell);
    }];
}

- (void)setSpaceToNextCell:(CGFloat)inSpaceToNextCell {
    if (inSpaceToNextCell != _spaceToNextCell) {
        _spaceToNextCell = inSpaceToNextCell;
        
        if (self.customContentHeight == 0) {
            
            [self.heightConstraint uninstall];
            [self.textField mas_updateConstraints:^(MASConstraintMaker *make) {
                self.heightConstraint = make.height.equalTo(self.mas_height).offset(-inSpaceToNextCell);
            }];
        }
    }
}

- (void)setCustomContentHeight:(CGFloat)inCustomContentHeight {
    if (inCustomContentHeight != _customContentHeight) {
        _customContentHeight = inCustomContentHeight;
        
        [self.heightConstraint uninstall];
        [self.textField mas_updateConstraints:^(MASConstraintMaker *make) {
            self.heightConstraint = make.height.equalTo(@(inCustomContentHeight));
        }];
    }
}

- (void)setCustomContentWidth:(CGFloat)inCustomContentWidth {
    if (inCustomContentWidth != _customContentWidth) {
        _customContentWidth = inCustomContentWidth;
        
        [self.widthConstraint uninstall];
        [self.textField mas_updateConstraints:^(MASConstraintMaker *make) {
            self.widthConstraint = make.width.equalTo(@(inCustomContentWidth));
        }];
    }
}

@end
