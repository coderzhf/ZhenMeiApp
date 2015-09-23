//
//  HeaderSearchView.m
//  ZhenMeiShiDaiApp
//
//  Created by 张锋 on 15/6/15.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#import "HeaderSearchView.h"

@implementation HeaderSearchView
{
    UIImageView *_textFieldSearchIcon;
    UILabel *_textFieldPlaceholderLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {        
        UITextField *textField = [[UITextField alloc] init];
        textField.layer.cornerRadius = 5;
        textField.clipsToBounds = YES;
        textField.backgroundColor = [UIColor whiteColor];
        textField.font = [UIFont systemFontOfSize:15];
        textField.returnKeyType=UIReturnKeySearch;
        [textField addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
        textField.clearButtonMode = UITextFieldViewModeAlways;
        textField.delegate = self;
        [self addSubview:textField];
        _textField = textField;
        
        UIImageView *searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zm_search_Btn"]];
        searchIcon.contentMode = UIViewContentModeScaleAspectFill;
        [_textField addSubview:searchIcon];
        _textFieldSearchIcon = searchIcon;
        
        UILabel *placeholderLabel = [[UILabel alloc] init];
        placeholderLabel.font = _textField.font;
        placeholderLabel.textColor = [UIColor lightGrayColor];
        [_textField addSubview:placeholderLabel];
        _textFieldPlaceholderLabel = placeholderLabel;
    }
    return self;
}

- (void)setPlaceholderText:(NSString *)placeholderText
{
    _placeholderText = placeholderText;
    
    _textFieldPlaceholderLabel.text = placeholderText;
}

- (void)layoutSubviews
{
    CGFloat margin = 2;
    _textField.frame = CGRectMake(margin, margin, self.width - margin * 2, self.height - margin * 2);
    
    
    
    [self layoutTextFieldSubviews];
    
    if (!_textField.leftView) {
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _textFieldSearchIcon.height * 1.4, _textFieldSearchIcon.height)];
        _textField.leftView = leftView;
        _textField.leftViewMode = UITextFieldViewModeAlways;
    }
    
}

- (void)layoutTextFieldSubviews
{
    CGRect rect = [self.placeholderText boundingRectWithSize:CGSizeMake(_textField.width * 0.7, _textField.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : _textFieldPlaceholderLabel.font} context:nil];
    _textFieldPlaceholderLabel.bounds = CGRectMake(0, 0, rect.size.width, _textField.height);
    _textFieldPlaceholderLabel.center = CGPointMake(_textField.width * 0.5, _textField.height * 0.5);
    _textFieldSearchIcon.bounds = CGRectMake(0, 0, _textField.height * 0.6, _textField.height * 0.6);
    _textFieldSearchIcon.center = CGPointMake(_textFieldPlaceholderLabel.left - _textFieldSearchIcon.width * 0.5,  _textFieldPlaceholderLabel.center.y);
}

- (void)textFieldValueChanged:(UITextField *)field
{
    _textFieldPlaceholderLabel.hidden = (field.text.length != 0);
}

#pragma mark - textField delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [_textField becomeFirstResponder];
    CGFloat deltaX = _textFieldSearchIcon.left - 5;
    
    [UIView animateWithDuration:0.4 animations:^{
        _textFieldSearchIcon.transform = CGAffineTransformMakeTranslation(- deltaX, 0);
        _textFieldPlaceholderLabel.transform = CGAffineTransformMakeTranslation(- deltaX, 0);
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.4 animations:^{
        _textFieldSearchIcon.transform = CGAffineTransformIdentity;
        _textFieldPlaceholderLabel.transform = CGAffineTransformIdentity;
    }];
    _textField.text=nil;
    _textFieldPlaceholderLabel.hidden = NO;
}

#pragma mark - public funcs

@end
