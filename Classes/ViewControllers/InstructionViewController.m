////  InstructionViewController.m//  LateWorm////  Created by Susan Surapruik on 12/10/09.//  Copyright 2009 __MyCompanyName__. All rights reserved.//#import "InstructionViewController.h"#import "OpenALPlayer.h"#import "HoleObject.h"@implementation InstructionViewControllerstatic unsigned startHoleX = 100;static unsigned startHoleY = 325;/* // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {        // Custom initialization    }    return self;}*/// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.- (void)viewDidLoad {	unsigned column;	    [super viewDidLoad];		self.view.userInteractionEnabled = NO;		_label0.font = [UIFont fontWithName:@"Omnes-Bold" size:20.0];	_label1.font = [UIFont fontWithName:@"HelveticaNeueLTStd-Hv" size:14.0];	_label2.font = [UIFont fontWithName:@"Omnes-Bold" size:20.0];	_label3.font = [UIFont fontWithName:@"HelveticaNeueLTStd-Hv" size:14.0];		UIImage *holeImage = [UIImage imageNamed:kHoleImage];	_holeWidth = holeImage.size.width;	_holeHeight = holeImage.size.height;	_holeHeightDiff = kGameObjectHeight - _holeHeight;		for (column = 0; column < 3; column++) {		[self createHoleAtRow:0 andColumn:column];	}		[self initializeViewAnimation];}/*// Override to allow orientations other than the default portrait orientation.- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {    // Return YES for supported orientations    return (interfaceOrientation == UIInterfaceOrientationPortrait);}*/- (void)didReceiveMemoryWarning {	// Releases the view if it doesn't have a superview.    [super didReceiveMemoryWarning];		// Release any cached data, images, etc that aren't in use.}- (void)viewDidUnload {	// Release any retained subviews of the main view.	// e.g. self.myOutlet = nil;}- (void)dealloc {	[_holesView release];	[_objectsView release];	[_tryMeBalloon release];    [super dealloc];}- (void) initializeViewAnimation {	[UIView beginAnimations:nil context:nil];	[UIView setAnimationDuration:kViewFadeTime];	[UIView setAnimationDelegate:self];	[UIView setAnimationDidStopSelector:@selector(viewVisible)];	self.view.alpha = 1.0;	[UIView commitAnimations];}- (void) viewVisible {	self.view.userInteractionEnabled = YES;		[self createObject:kGameWorm atRow:0 andColumn:1];	[[NSNotificationCenter defaultCenter] postNotificationName:kNOTIFICATION_PLAYSOUND object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:kAudioWormAppear, kNOTIFICATION_PLAYSOUND, [NSNumber numberWithBool:NO], kNOTIFICATION_RESTART, nil]];		[UIView beginAnimations:nil context:nil];	[UIView setAnimationDuration:kViewFadeTime];	[UIView setAnimationDelegate:self];	_tryMeBalloon.alpha = 1.0;	[UIView commitAnimations];}- (void) fadeView {	[[NSNotificationCenter defaultCenter] postNotificationName:kNOTIFICATION_PLAYSOUND object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:kAudioClick, kNOTIFICATION_PLAYSOUND, [NSNumber numberWithBool:YES], kNOTIFICATION_RESTART, nil]];		self.view.userInteractionEnabled = NO;	[UIView beginAnimations:nil context:nil];	[UIView setAnimationDuration:kViewFadeTime];	[UIView setAnimationDelegate:self];	[UIView setAnimationDidStopSelector:@selector(removeView)];	self.view.alpha = 0.0;	[UIView commitAnimations];}- (void) removeView {	[[NSNotificationCenter defaultCenter] postNotificationName:kNOTIFICATION_CHANGESTATE object:self userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kGameState_Game] forKey:kNOTIFICATION_CHANGESTATE]];}- (void) createHoleAtRow:(unsigned)row andColumn:(unsigned)column {	NSInteger tag = (row + 1) * kMaxColumns + column;	HoleObject *hole = [[HoleObject alloc] initWithFrame:CGRectMake(startHoleX + (kGameHoleDiff * column) - (_holeWidth/2), startHoleY + (kGameHoleDiff * row) - (_holeHeight/2) - _holeHeightDiff, _holeWidth, _holeHeight + _holeHeightDiff)];	//HoleObject *hole = [[HoleObject alloc] initWithFrame:CGRectMake(startHoleX + (kGameHoleDiff * column) - (_holeWidth/2), startHoleY + (kGameHoleDiff * row) - (_holeHeight/2), _holeWidth, _holeHeight)];	hole._row = row;	hole._column = column;	hole.tag = tag;	[hole addTarget:self action:@selector(selectObject:) forControlEvents:UIControlEventTouchUpInside];	[_holesView addSubview:hole];	[hole release];}- (void) createObject:(NSString*)type atRow:(unsigned)row andColumn:(unsigned)column {	NSInteger tag = (row + 1) * kMaxColumns + column;	GameObject *object = [[GameObject alloc] initWithFrame:CGRectMake(0,0,kGameObjectWidth,kGameObjectHeight)];	[object setType:type];	object._row = row;	object._column = column;	object.tag = tag;	object.delegate = self;	object.center = CGPointMake(startHoleX + kGmeWormOffsetFromHoleX + (kGameHoleDiff * column), startHoleY + kGmeWormOffsetFromHoleY + (kGameHoleDiff * row));	[_objectsView addSubview:object];	[object release];}- (void) selectObject:(id)sender {	unsigned row, column;		if (_tryMeBalloon.alpha == 1.0) {		[UIView beginAnimations:nil context:nil];		[UIView setAnimationDuration:kViewFadeTime];		[UIView setAnimationDelegate:self];		_tryMeBalloon.alpha = 0.0;		[UIView commitAnimations];	}		HoleObject *obj = sender;		row = obj._row;	column = obj._column;		[self flipObjectAtRow:row andColumn:column];		if (column > 0) {		[self flipObjectAtRow:row andColumn:column-1];	}	if (column + 1 < 3) {		[self flipObjectAtRow:row andColumn:column+1];	}}- (void) flipObjectAtRow:(unsigned)row andColumn:(unsigned)column {	GameObject *gameObject;	NSInteger tag = (row + 1) * kMaxColumns + column;	HoleObject *hole = (HoleObject*)[_holesView viewWithTag:tag];		if ([_objectsView viewWithTag:tag]) {		gameObject = (GameObject*)[_objectsView viewWithTag:tag];		if ([[gameObject getType] isEqualToString:kGameWorm]) {			hole._enabled = NO;			[gameObject changeState:kObjectState_Disppear];				[[NSNotificationCenter defaultCenter] postNotificationName:kNOTIFICATION_PLAYSOUND object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:kAudioWormDisppear, kNOTIFICATION_PLAYSOUND, [NSNumber numberWithBool:NO], kNOTIFICATION_RESTART, nil]];		}	} else if ([_holesView viewWithTag:tag]) {		hole._enabled = NO;		[self createObject:kGameWorm atRow:row andColumn:column];		[[NSNotificationCenter defaultCenter] postNotificationName:kNOTIFICATION_PLAYSOUND object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:kAudioWormAppear, kNOTIFICATION_PLAYSOUND, [NSNumber numberWithBool:NO], kNOTIFICATION_RESTART, nil]];	}}#pragma mark -#pragma mark GameObjectDelegate- (void) enableHole:(GameObject*)gameObject row:(unsigned)row column:(unsigned)column {	NSInteger tag = (row + 1) * kMaxColumns + column;	HoleObject *hole = (HoleObject*)[_holesView viewWithTag:tag];	hole._enabled = YES;}- (void) removeObject:(GameObject*)gameObject row:(unsigned)row column:(unsigned)column {	NSInteger tag = (row + 1) * kMaxColumns + column;	GameObject *removeGameObject = (GameObject*)[_objectsView viewWithTag:tag];	if ([[removeGameObject getType] isEqualToString:kGameWorm]) {		[removeGameObject removeFromSuperview];	}}@end