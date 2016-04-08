//
//  TKAlertCenter.m
//  Created by Devin Ross on 9/29/10.
//
/*
 
 tapku.com || http://github.com/devinross/tapkulibrary
 
 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
*/

#import "TKAlertCenter.h"
#import "UIView+TKCategory.h"


#pragma mark -
@interface TKAlertView : UIView {
	CGRect _messageRect;
	NSString *_text;
	UIImage *_image;
}

- (id) init;
- (void) setMessageText:(NSString*)str;
- (void) setImage:(UIImage*)image;

@end


#pragma mark -
@implementation TKAlertView
- (id) init{
	if((self = [super initWithFrame:CGRectMake(0,0,100,100)])){
        self.backgroundColor = [UIColor clearColor];
        _messageRect = CGRectInset(self.bounds, 10, 10);
    }
	return self;
}

- (void) drawRect:(CGRect)rect{
	[[UIColor colorWithWhite:0 alpha:0.8] set];
	[UIView drawRoundRectangleInRect:rect withRadius:10];
	[[UIColor whiteColor] set];
    
	[_text drawInRect:_messageRect withFont:[UIFont boldSystemFontOfSize:14] lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];
	
	CGRect r = CGRectZero;
	r.origin.y = 15;
	r.origin.x = (rect.size.width-_image.size.width)/2;
	r.size = _image.size;
	
	[_image drawInRect:r];
}

#pragma mark Setter Methods
- (void) adjust{
	CGSize s = [_text sizeWithFont:[UIFont boldSystemFontOfSize:14] 
                 constrainedToSize:CGSizeMake(240,240)
                     lineBreakMode:NSLineBreakByWordWrapping];
	
	float imageAdjustment = 0;
	if (_image) {
		imageAdjustment = 7+_image.size.height;
	}
	
	self.bounds = CGRectMake(0,0,MAX(s.width,80)+20,s.height+20+imageAdjustment);
	_messageRect.size = s;
	_messageRect.size.height += 5;
	_messageRect.origin.x = (self.width-s.width)/2;
	_messageRect.origin.y = 10+imageAdjustment;
	
	[self setNeedsLayout];
	[self setNeedsDisplay];
	
}
- (void) setMessageText:(NSString*)str{
    _text = str;
	[self adjust];
}

- (void) setImage:(UIImage*)img{
    _image = img;
	[self adjust];
}

@end


#pragma mark -
@implementation TKAlertCenter
-(UIWindow*) getKeyWindow
{
    UIWindow *keyWind = [UIApplication sharedApplication].keyWindow;
    if(!keyWind)
        keyWind = [[UIApplication sharedApplication].windows objectAtIndex:0];
    return keyWind;
}

#pragma mark Init & Friends
+ (TKAlertCenter*) defaultCenter {
	static TKAlertCenter *defaultCenter = nil;
	if (!defaultCenter) {
		defaultCenter = [[TKAlertCenter alloc] init];
	}
	return defaultCenter;
}

- (id) init{
	if(!(self=[super init])) return nil;
	
	_active = NO;
	_alerts = [[NSMutableArray alloc] init];
	_alertView = [[TKAlertView alloc] init];
	_alertFrame = [self getKeyWindow].bounds;

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardDidHideNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationWillChange:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];

	return self;
}


#pragma mark Show Alert Message
- (void) showAlerts{
	if([_alerts count] < 1) {
		_active = NO;
		return;
	}

	_active = YES;
	
	_alertView.transform = CGAffineTransformIdentity;
	_alertView.alpha = 0;
	[[self getKeyWindow] addSubview:_alertView];
	
	NSArray *ar = [_alerts objectAtIndex:0];
	
	UIImage *img = nil;
	if([ar count] > 1) img = [ar objectAtIndex:1];
	[_alertView setImage:img];

	if([ar count] > 0) [_alertView setMessageText:ar[0]];
	_alertView.center = CGPointMake(_alertFrame.origin.x+_alertFrame.size.width/2, _alertFrame.origin.y+_alertFrame.size.height/2);
	
	CGRect rr = _alertView.frame;
	rr.origin.x = (int)rr.origin.x;
	rr.origin.y = (int)rr.origin.y;
	_alertView.frame = rr;
	
	UIInterfaceOrientation o = [UIApplication sharedApplication].statusBarOrientation;
	CGFloat degrees = 0;
	if(o == UIInterfaceOrientationLandscapeLeft ) degrees = -90;
	else if(o == UIInterfaceOrientationLandscapeRight ) degrees = 90;
	else if(o == UIInterfaceOrientationPortraitUpsideDown) degrees = 180;
	_alertView.transform = CGAffineTransformMakeRotation(degrees * M_PI / 180);
	_alertView.transform = CGAffineTransformScale(_alertView.transform, 2, 2);

	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.15];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationStep2)];

	_alertView.transform = CGAffineTransformMakeRotation(degrees * M_PI / 180);
	[_alertView setFrame:CGRectMake((int)_alertView.left, (int)_alertView.top,
                                    _alertView.width, _alertView.height)];
	_alertView.alpha = 1;
	
	[UIView commitAnimations];
}

- (void) animationStep2{
    if(_alerts.count==0)
        return;
    
	[UIView beginAnimations:nil context:nil];
	// depending on how many words are in the text
	// change the animation duration accordingly
	// avg person reads 200 words per minute
    NSString *alertText = [[_alerts objectAtIndex:0] objectAtIndex:0];
	double duration = MAX(((double)alertText.length*60.0/400.0),1.1);
    duration = MIN(duration, 3.0);

	[UIView setAnimationDelay:duration];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationStep3)];
	UIInterfaceOrientation o = [UIApplication sharedApplication].statusBarOrientation;
	CGFloat degrees = 0;
	if(o == UIInterfaceOrientationLandscapeLeft ) degrees = -90;
	else if(o == UIInterfaceOrientationLandscapeRight ) degrees = 90;
	else if(o == UIInterfaceOrientationPortraitUpsideDown) degrees = 180;
	_alertView.transform = CGAffineTransformMakeRotation(degrees * M_PI / 180);
	_alertView.transform = CGAffineTransformScale(_alertView.transform, 0.5, 0.5);
	
	_alertView.alpha = 0;
	[UIView commitAnimations];
}

- (void) animationStep3{
	[_alertView removeFromSuperview];
	[_alerts removeObjectAtIndex:0];
	[self showAlerts];
}

- (void) postAlertWithArray:(NSArray*)msgArray {
	[_alerts addObject:msgArray];
	if(!_active) [self showAlerts];
}

- (void) postAlertWithMessage:(NSString*)message image:(UIImage*)image{
    if(IsNull(message)||IsEmpty(message))
        return;

	[_alerts addObject:[NSArray arrayWithObjects:message,image,nil]];
	if(!_active) [self showAlerts];
}

- (void) postAlertWithMessage:(NSString*)message {
	[self postAlertWithMessage:message image:nil];
}

#pragma mark System Observation Changes
CGRect subtractRect(CGRect wf,CGRect kf);
CGRect subtractRect(CGRect wf,CGRect kf){
	
	if(!CGPointEqualToPoint(CGPointZero,kf.origin)){
		
		if(kf.origin.x>0) kf.size.width = kf.origin.x;
		if(kf.origin.y>0) kf.size.height = kf.origin.y;
		kf.origin = CGPointZero;
		
	}else{
		kf.origin.x = abs(kf.size.width - wf.size.width);
		kf.origin.y = abs(kf.size.height -  wf.size.height);
		
		if(kf.origin.x > 0){
			CGFloat temp = kf.origin.x;
			kf.origin.x = kf.size.width;
			kf.size.width = temp;
		}else if(kf.origin.y > 0){
			CGFloat temp = kf.origin.y;
			kf.origin.y = kf.size.height;
			kf.size.height = temp;
		}
		
	}
	return CGRectIntersection(wf, kf);
}

- (void) keyboardWillAppear:(NSNotification *)notification {
	NSDictionary *userInfo = [notification userInfo];
	NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
	CGRect kf = [aValue CGRectValue];
	CGRect wf = [self getKeyWindow].bounds;
	
	[UIView beginAnimations:nil context:nil];
	_alertFrame = subtractRect(wf,kf);
	_alertView.center = CGPointMake(_alertFrame.origin.x+_alertFrame.size.width/2, _alertFrame.origin.y+_alertFrame.size.height/2);

	[UIView commitAnimations];
}
- (void) keyboardWillDisappear:(NSNotification *) notification {
	_alertFrame = [self getKeyWindow].bounds;

}
- (void) orientationWillChange:(NSNotification *) notification {
	
	NSDictionary *userInfo = [notification userInfo];
	NSNumber *v = [userInfo objectForKey:UIApplicationStatusBarOrientationUserInfoKey];
	UIInterfaceOrientation o = [v intValue];
	
	CGFloat degrees = 0;
	if(o == UIInterfaceOrientationLandscapeLeft ) degrees = -90;
	else if(o == UIInterfaceOrientationLandscapeRight ) degrees = 90;
	else if(o == UIInterfaceOrientationPortraitUpsideDown) degrees = 180;
	
	[UIView beginAnimations:nil context:nil];
	_alertView.transform = CGAffineTransformMakeRotation(degrees * M_PI / 180);
	[_alertView setFrame:CGRectMake((int)_alertView.left, (int)_alertView.top, (int)_alertView.width, (int)_alertView.height)];
	[UIView commitAnimations];
}

@end