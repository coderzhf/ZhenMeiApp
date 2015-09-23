//
//  UQFactory.m
//  UQPlatformSDK
//
//  Created by Dyfei on 14/10/23.
//  Copyright (c) 2014年 UQ Interactive. All rights reserved.
//

#import "UQFactory.h"

#if __has_feature(objc_arc)
#define AUTORELEASE(xx) xx
#else
#define AUTORELEASE(xx) [xx autorelease]
#endif

#define kDefaultSize 16
#define kDefaultFont @"Heiti SC"

#define OS_Version [[[UIDevice currentDevice] systemVersion] floatValue]

@implementation UQFactory

+ (UIView *)viewWithFrame:(CGRect)frame backgroundColor:(UIColor *)bgColor
{
    UIView *view = AUTORELEASE([[UIView alloc] init]);
    [view setFrame:frame];
    [view setBackgroundColor:bgColor];
    return view;
}

+ (UILabel *)labelWithFrame:(CGRect)frame text:(NSString *)text
{
    return [self labelWithFrame:frame text:text textColor:[UIColor whiteColor] fontSize:kDefaultSize center:YES];
}

+ (UILabel *)labelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)color fontSize:(CGFloat)size center:(BOOL)center
{
    UILabel *label = AUTORELEASE([[UILabel alloc] init]);
    label.frame = frame;
    label.text = text;
    label.textColor = color;
    label.numberOfLines = 0;
    label.backgroundColor = [UIColor clearColor];
 
        label.font = [UIFont systemFontOfSize:size];
    if (center) {
        label.textAlignment = NSTextAlignmentCenter;
    } else {
        label.textAlignment = NSTextAlignmentLeft;
    }
    return label;
}

+ (UIButton *)buttonWithFrame:(CGRect)frame image:(UIImage *)image highlightedImage:(UIImage *)highlightedImage title:(NSString *)title titleColor:(UIColor *)color
{
    return [self buttonWithFrame:frame image:image highlightedImage:highlightedImage title:title titleColor:color fontName:kDefaultFont fontSize:kDefaultSize];
}

+ (UIButton *)buttonWithFrame:(CGRect)frame image:(UIImage *)image highlightedImage:(UIImage *)highlightedImage title:(NSString *)title titleColor:(UIColor *)color fontName:(NSString *)name fontSize:(CGFloat)size
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    if (image) {
        [button setBackgroundImage:image forState:UIControlStateNormal];
    }
    if (highlightedImage) {
        [button setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
    }
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    if (name == nil) {
        button.titleLabel.font = [UIFont systemFontOfSize:size];
    } else {
        button.titleLabel.font = [UIFont fontWithName:name size:size];
    }
    return button;
}

+ (UIButton *)buttonWithFrame:(CGRect)frame image:(UIImage *)image
{
    return [self buttonWithFrame:frame backgroundImage:nil image:image ];
}

+ (UIButton *)buttonWithFrame:(CGRect)frame backgroundImage:(UIImage *)bgImage  image:(UIImage *)image
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    if (bgImage) {
        [button setBackgroundImage:bgImage forState:UIControlStateNormal];
    }
    if (image) {
        [button setImage:image forState:UIControlStateNormal];
    }
    return button;
}

+ (UIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)color highlighted:(BOOL)highlighted highlightedColor:(UIColor *)highlightedColor
{
    return [self buttonWithFrame:frame title:title titleColor:color fontName:kDefaultFont fontSize:kDefaultSize];
}

+ (UIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)color fontName:(NSString *)name fontSize:(CGFloat)size
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    if (name == nil) {
        button.titleLabel.font = [UIFont systemFontOfSize:size];
    } else {
        button.titleLabel.font = [UIFont fontWithName:name size:size];
    }
    if (color) {
        [button setTitleColor:color forState:UIControlStateNormal];
    }
  
    return button;
}

+ (UIImageView *)imageViewWithFrame:(CGRect)frame image:(UIImage *)image
{
    return [self imageViewWithFrame:frame image:image contentMode:UIViewContentModeScaleToFill userInteractionEnabled:YES];
}

+ (UIImageView *)imageViewWithFrame:(CGRect)frame image:(UIImage *)image contentMode:(NSInteger)contentMode userInteractionEnabled:(BOOL)enabled
{
    UIImageView *imageView = AUTORELEASE([[UIImageView alloc] init]);
    imageView.frame = frame;
    if (image) {
        imageView.image = image;
    }
    imageView.contentMode = contentMode;
    if (enabled) {
        imageView.userInteractionEnabled = YES;
    }
    return imageView;
}

+ (UITextField *)textFieldWithFrame:(CGRect)frame placeholder:(NSString *)placeholder text:(NSString *)text borderStyle:(NSInteger)borderStyle backgroundColor:(UIColor *)bgColor delegate:(id)delegate
{
    return [self textFieldWithFrame:frame placeholder:placeholder text:text borderStyle:borderStyle backgroundColor:bgColor delegate:delegate returnKeyType:UIReturnKeyDefault keyboardType:UIKeyboardTypeDefault fontName:kDefaultFont fontSize:kDefaultSize secure:NO];
}

+ (UITextField *)textFieldWithFrame:(CGRect)frame placeholder:(NSString *)placeholder text:(NSString *)text borderStyle:(NSInteger)borderStyle backgroundColor:(UIColor *)bgColor delegate:(id)delegate returnKeyType:(NSInteger)returnKeyType keyboardType:(NSInteger)keyboardType fontName:(NSString *)fontName fontSize:(CGFloat)fontSize secure:(BOOL)secure
{
    UITextField *textField = AUTORELEASE([[UITextField alloc] init]);
    textField.frame = frame;
    textField.placeholder = placeholder;
    textField.text = text;
    textField.delegate = delegate;
    textField.borderStyle = borderStyle;
    textField.backgroundColor = bgColor;
    textField.returnKeyType = returnKeyType;
    textField.keyboardType = keyboardType;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    if (secure) {
        textField.secureTextEntry = YES;
    }
    if (fontName == nil)
    {
        textField.font = [UIFont systemFontOfSize:fontSize];
    } else {
        textField.font = [UIFont fontWithName:fontName size:fontSize];
    }
    return textField;
}

+ (UITextView *)textViewWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont *)font isEditable:(BOOL)isEditable
{
    UITextView *textView = AUTORELEASE([[UITextView alloc] init]);
    textView.frame = frame;
    textView.font = font;
    textView.text = text;
    textView.editable = isEditable;
    return textView;
}

+ (UIWebView *)webViewWithFrame:(CGRect)frame{
    
    UIWebView *web=[[UIWebView alloc]init];
    web.backgroundColor = [UIColor clearColor];
    web.detectsPhoneNumbers=NO;
    web.scrollView.bounces = NO;
    web.scalesPageToFit = YES;
    web.frame=frame;
    return web;
 }
@end
