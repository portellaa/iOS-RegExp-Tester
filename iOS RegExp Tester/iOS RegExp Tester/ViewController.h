//
//  ViewController.h
//  iOS RegExp Tester
//
//  Created by Luís Portela Afonso on 17/12/13.
//  Copyright (c) 2013 GuildApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *regexpInput;
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;
@property (weak, nonatomic) IBOutlet UITextView *outputTextView;

- (IBAction)textFieldTextChanged:(id)sender;

@end
