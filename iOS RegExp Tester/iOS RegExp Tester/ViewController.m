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
	
	[_inputTextView.layer setBorderColor:[UIColor grayColor].CGColor];
	
	[_inputTextView.layer setBorderWidth:0.5f];
	
	[_inputTextView setDelegate:self];
	[_regexpInput setDelegate:self];
	
	[self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Private Methods

- (void)updateMatchesWithRegex:(NSString*)regex andText:(NSString*)testText
{
	NSLog(@"ViewController: testing");
	if (([regex length] > 0) && ([testText length] > 0))
	{
		NSLog(@"ViewController: Input text and regex has text");
		NSError *error = nil;
		
		NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionCaseInsensitive error:&error];
		
		NSArray *matches = [regexp matchesInString:_inputTextView.text options:0 range:NSMakeRange(0, [testText length])];
		
		if ([matches count] > 0)
		{
			NSMutableAttributedString *attribString = [[NSMutableAttributedString alloc] initWithString:testText];
			
			for (NSTextCheckingResult *match in matches)
			{
				[attribString setAttributes:@{NSBackgroundColorAttributeName : [UIColor yellowColor]} range:[match range]];
			}
			
			[_inputTextView setAttributedText:attribString];
		}
	}
	else
	{
		[_inputTextView setText:_inputTextView.text];
	}
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
	_currentResponder = textField;
	
	[self updateMatchesWithRegex:textField.text andText:_inputTextView.text];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	
	[self updateMatchesWithRegex:textField.text andText:_inputTextView.text];
	
	return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
	[textView resignFirstResponder];
	
	[self updateMatchesWithRegex:_regexpInput.text andText:textView.text];
	
	return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
	_currentResponder = textView;
}

- (void)textViewDidChange:(UITextView *)textView
{
	[self updateMatchesWithRegex:_regexpInput.text andText:textView.text];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
	[self updateMatchesWithRegex:_regexpInput.text andText:textView.text];
}


- (void)viewTapped:(UIGestureRecognizer*)recognizer
{
	[self updateMatchesWithRegex:_regexpInput.text andText:_inputTextView.text];
	
	[_currentResponder resignFirstResponder];
}

- (IBAction)textFieldTextChanged:(id)sender
{
	[self updateMatchesWithRegex:((UITextField*)sender).text andText:_inputTextView.text];
}
@end
