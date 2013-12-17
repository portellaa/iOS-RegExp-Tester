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

- (void)updateMatches;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[_inputTextView.layer setBorderColor:[UIColor grayColor].CGColor];
	[_outputTextView.layer setBorderColor:[UIColor grayColor].CGColor];
	
	[_inputTextView.layer setBorderWidth:0.5f];
	[_outputTextView.layer setBorderWidth:0.5f];
	
	[_inputTextView setDelegate:self];
	[_regexpInput setDelegate:self];
	
	[self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Private Methods

- (void)updateMatches
{
	if (([_regexpInput hasText] == YES) && ([_inputTextView hasText] == YES))
	{
		NSError *error = nil;
		
		NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:_regexpInput.text options:NSRegularExpressionCaseInsensitive error:&error];
		
		NSArray *matches = [regexp matchesInString:_inputTextView.text options:0 range:NSMakeRange(0, [_inputTextView.text length])];
		
		if ([matches count] > 0)
		{
			NSMutableAttributedString *attribString = [[NSMutableAttributedString alloc] initWithString:_inputTextView.text];
			
			for (NSTextCheckingResult *match in matches)
			{
				[attribString setAttributes:@{NSBackgroundColorAttributeName : [UIColor yellowColor]} range:[match range]];
			}
			
			[_outputTextView setAttributedText:attribString];
		}
	}
	else
	{
		[_outputTextView setText:_inputTextView.text];
	}
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
	_currentResponder = textField;
	
	[self updateMatches];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	
	[self updateMatches];
	
	return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
	[textView resignFirstResponder];
	
	[self updateMatches];
	
	return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
	_currentResponder = textView;
}

- (void)textViewDidChange:(UITextView *)textView
{
	[_outputTextView setText:_inputTextView.text];
	
	[self updateMatches];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
	[self updateMatches];
}


- (void)viewTapped:(UIGestureRecognizer*)recognizer
{
	[self updateMatches];
	
	[_currentResponder resignFirstResponder];
}

- (IBAction)textFieldTextChanged:(id)sender
{
	[self updateMatches];
}
@end
