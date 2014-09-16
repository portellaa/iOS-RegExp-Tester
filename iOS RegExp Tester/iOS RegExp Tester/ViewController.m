//
//  ViewController.m
//  iOS RegExp Tester
//
//  Created by Luís Portela Afonso on 17/12/13.
//  Copyright (c) 2013 GuildApp. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()

@property (nonatomic) id currentResponder;

- (void)updateMatchesWithRegex:(NSString*)regex andText:(NSString*)testText;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self.inputTextView.layer setBorderColor:[UIColor grayColor].CGColor];
	[self.inputTextView.layer setBorderWidth:0.5f];
	
	[self.inputTextView setDelegate:self];
	[self.regexpInput setDelegate:self];
	
	[self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Private Methods

- (void)updateMatchesWithRegex:(NSString*)regex andText:(NSString*)testText
{
	NSMutableAttributedString *finalText = [[NSMutableAttributedString alloc] initWithString:testText attributes:@{NSBackgroundColorAttributeName : [UIColor clearColor]}];
	[self.inputTextView setAttributedText:finalText];
	
	
	if ([regex length] > 0)
	{
		NSError *error = nil;
		
		NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionCaseInsensitive error:&error];
		
		NSArray *matches = [regexp matchesInString:testText options:0 range:NSMakeRange(0, [testText length])];
		
		if ([matches count] > 0)
		{
			NSMutableAttributedString *attribString = [[NSMutableAttributedString alloc] initWithString:testText];
			
			for (NSTextCheckingResult *match in matches)
			{
				[attribString setAttributes:@{NSBackgroundColorAttributeName : [UIColor yellowColor]} range:[match range]];
			}
			
			[self.inputTextView setAttributedText:attribString];
		}
	}
}

#pragma mark - Delegate Methods

#pragma mark UITexfField Delegate Methods

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
	self.currentResponder = textField;
	
	[self updateMatchesWithRegex:textField.text andText:self.inputTextView.text];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	
	[self updateMatchesWithRegex:textField.text andText:self.inputTextView.text];
	
	return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	NSMutableString *finalText = [[NSMutableString alloc] initWithString:textField.text];
	[finalText replaceCharactersInRange:range withString:string];

	[self updateMatchesWithRegex:finalText andText:self.inputTextView.text];
	
	return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
	[self updateMatchesWithRegex:self.regexpInput.text andText:textView.text];
	
	[textView resignFirstResponder];
	
	return YES;
}


#pragma mark UITextView Delegate Methods

- (void)textViewDidBeginEditing:(UITextView *)textView
{
	self.currentResponder = textView;
}

- (void)textViewDidChange:(UITextView *)textView
{
	[self updateMatchesWithRegex:self.regexpInput.text andText:textView.text];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
	[self updateMatchesWithRegex:self.regexpInput.text andText:textView.text];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
	NSMutableString *finalText = [[NSMutableString alloc] initWithString:textView.text];
	[finalText replaceCharactersInRange:range withString:text];

	[self updateMatchesWithRegex:self.regexpInput.text andText:finalText];
	
	return NO;
}


#pragma mark - Action Methods

- (void)viewTapped:(UIGestureRecognizer*)recognizer
{
	[self updateMatchesWithRegex:self.regexpInput.text andText:self.inputTextView.text];
	
	[self.currentResponder resignFirstResponder];
}

@end
