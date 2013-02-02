#import "GameObject.h"@implementation GameObject@synthesize delegate;@synthesize _row, _column;static unsigned kBlankFrames = 3;static unsigned kMaxIdleFrames = 50;static unsigned kAppearFrames = 7;static unsigned kDisappearFrames = 10;- (id)initWithFrame:(CGRect)frame {    if (self = [super initWithFrame:frame]) {        // Initialization code		self.userInteractionEnabled = NO;		_type = [[NSMutableString alloc] init];		_imageType = [[NSMutableString alloc] init];    }    return self;}- (id)initWithCoder:(NSCoder*)coder {	if ((self = [super initWithCoder:coder])) {		self.userInteractionEnabled = NO;		_type = [[NSMutableString alloc] init];		_imageType = [[NSMutableString alloc] init];	}		return self;}- (void) changeState:(unsigned)state {	_animationFrame = 0;	_idleAnimationFrames = kMaxIdleFrames + arc4random() % kMaxIdleFrames;	_state = state;}- (void) renderScene {	NSString *imageName;	unsigned idleType;		if (_state == kObjectState_Appear) {		imageName = [NSString stringWithFormat:@"%@_appear_%d", _imageType, _animationFrame];		_objectImage.image = [UIImage imageNamed:imageName];		_animationFrame++;		if (_animationFrame == kAppearFrames) {			_lookStraight = YES;			[self changeState: kObjectState_Idle];						if (delegate && [delegate respondsToSelector:@selector(enableHole:row:column:)]) {				[delegate enableHole:self row:_row column:_column];			}		}	} else if (_state == kObjectState_Disppear) {		imageName = [NSString stringWithFormat:@"%@_leave_%d", _imageType, _animationFrame];		_objectImage.image = [UIImage imageNamed:imageName];		_animationFrame++;		if (_animationFrame == kDisappearFrames) {			[self changeState:kObjectState_StandBy];			if (delegate && [delegate respondsToSelector:@selector(removeObject:row:column:)]) {				[delegate removeObject:self row:_row column:_column];			}			if (delegate && [delegate respondsToSelector:@selector(enableHole:row:column:)]) {				[delegate enableHole:self row:_row column:_column];			}		}	} else if (_state == kObjectState_Idle) {		if (_animationFrame == 0) {			idleType = arc4random() % 5;			if (idleType == 0 || _lookStraight) {				_lookStraight = NO;				imageName = [NSString stringWithFormat:@"%@_look_straight", _imageType];			} else if (idleType == 1) {				imageName = [NSString stringWithFormat:@"%@_look_down", _imageType];			} else if (idleType == 2) {				imageName = [NSString stringWithFormat:@"%@_look_left", _imageType];			} else if (idleType == 3) {				imageName = [NSString stringWithFormat:@"%@_look_right", _imageType];			} else {				imageName = [NSString stringWithFormat:@"%@_look_up", _imageType];			}			_objectImage.image = [UIImage imageNamed:imageName];		}		_animationFrame++;		if (_animationFrame == _idleAnimationFrames) {			[self changeState:kObjectState_Blink];		}	} else if (_state == kObjectState_Blink) {		if (_animationFrame + 1 == kBlankFrames) {			imageName = [NSString stringWithFormat:@"%@_blink_%d", _imageType, _animationFrame - 1];		} else {			imageName = [NSString stringWithFormat:@"%@_blink_%d", _imageType, _animationFrame];		}		_objectImage.image = [UIImage imageNamed:imageName];		_animationFrame++;		if (_animationFrame == kBlankFrames) {			[self changeState:kObjectState_Idle];		}	}}- (void) invalidateTimer {	if (_timer) {		[_timer invalidate];		_timer = nil;	}}- (NSString*) getType {	return _type;}- (void) setType:(NSString*)type {	[_type setString:type];	[_imageType setString:[type lowercaseString]];		_objectImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,kGameObjectWidth,kGameObjectHeight)];	[self addSubview:_objectImage];		[self changeState:kObjectState_Appear];		_timer = [NSTimer scheduledTimerWithTimeInterval:(1.0 / kRenderingFPS) target:self selector:@selector(renderScene) userInfo:nil repeats:YES];}- (void) dealloc {	[self invalidateTimer];		[_type release];	[_imageType release];	[_objectImage release];		delegate = nil;		[super dealloc];}@end