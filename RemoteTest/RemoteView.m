#import "RemoteView.h"

#import <GameController/GameController.h>

@implementation RemoteView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self configureRemote];
        });
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [[UIColor darkGrayColor] setFill];
    rect = CGRectInset(rect, 100, 200);
    [[UIBezierPath bezierPathWithRect:rect] fill];
}

- (void)configureRemote
{
    GCController *controller = [[GCController controllers] firstObject];
    
    controller.motion.valueChangedHandler = ^(GCMotion *motion) {
        //NSLog(@"%10f %10f %10f", motion.gravity.x, motion.gravity.y, motion.gravity.z);
        //NSLog(@"%10f %10f %10f", motion.userAcceleration.x, motion.userAcceleration.y, motion.userAcceleration.z);
        static CGFloat localX = 0;
        localX = localX*0.983 + motion.userAcceleration.x/5.0;
        CGFloat angle = atan2(motion.gravity.x, motion.gravity.z);
        CGAffineTransform transform = CGAffineTransformIdentity;
        transform = CGAffineTransformRotate(transform, -angle);
        transform = CGAffineTransformTranslate(transform, 1024.0*localX, -1024.0*motion.gravity.y);
        self.transform = transform;
    };
}

@end
