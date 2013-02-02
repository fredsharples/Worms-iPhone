////  GardenFlower.m//  LateWorm////  Created by Susan Surapruik on 12/16/09.//  Copyright 2009 __MyCompanyName__. All rights reserved.//#import "GardenFlower.h"#import "Constants.h"@implementation GardenFlower- (id)initWithFrame:(CGRect)frame {    if (self = [super initWithFrame:frame]) {        // Initialization code		self.backgroundColor = [UIColor clearColor];				_stem = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"flower_stem"]];		_stem.frame = CGRectMake(3,16,30,35);		[self addSubview:_stem];    }    return self;}- (void)drawRect:(CGRect)rect {    // Drawing code}- (void)dealloc {	[_flower release];	[_stem release];    [super dealloc];}- (unsigned) _level {	return _level;}- (void) set_level:(unsigned)newLevel {	NSString *flowerName;		_level = newLevel;		if (_level < 9) {		flowerName = [NSString stringWithFormat:@"flower_0%d_on", _level+1];	} else {		flowerName = [NSString stringWithFormat:@"flower_%d_on", _level+1];	}		_flower = [[UIImageView alloc] initWithImage:[UIImage imageNamed:flowerName]];	_flower.frame = CGRectMake(0,0,34,34);	[self addSubview:_flower];}@end