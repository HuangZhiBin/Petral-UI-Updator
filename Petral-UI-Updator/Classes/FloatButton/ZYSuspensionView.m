//
//  ZYSuspensionView.m
//  suspendButton
//
//  Created by wanglei on 17/1/9.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import "ZYSuspensionView.h"
#import "NSObject+ZYSuspensionView.h"
#import "ZYSuspensionManager.h"

@interface ZYSuspensionViewController : UIViewController

@end

@implementation ZYSuspensionViewController

- (BOOL)prefersStatusBarHidden
{
    return NO;
}


- (instancetype)init{
    if (self = [super init]) {
        self.view.frame = [UIScreen mainScreen].bounds;
        self.view.backgroundColor = [UIColor clearColor];
    }
    return self;
}
@end


@implementation ZYSuspensionView

- (instancetype)initWithFrame:(CGRect)frame color:(UIColor*)color delegate:(id<ZYSuspensionViewDelegate>)delegate{
    
    if(self = [super initWithFrame:frame])
    {
        // 这句话就说明了ZYSuspensionView的代理是ViewController,要在ViewController里面实现代理方法
        self.delegate = delegate;
        // 打印结果如下:self = ZYSuspensionView,delegate = ViewController
        NSLog(@"self = %@,delegate = %@",[self class],[delegate class]);
        
        //确保可以识别各种与用户进行交互的手势
        self.userInteractionEnabled = YES;
        self.backgroundColor = color;
        self.alpha = 0.7;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(changeLocation:)];
        
        // 这里的delaysTouchesBegan属性很明显就是对touchBegin方法是否进行延迟,
        // YES表示延迟,即在系统未识别出来手势为什么手势时先不要调用touchesBegan 方法;
        // NO表示不延迟,即在系统未识别出来手势为什么手势时会先调用touchesBegan 方法;
        pan.delaysTouchesBegan = YES;
        [self addGestureRecognizer:pan];
        [self addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
    
}

#pragma mark - event response
- (void)changeLocation:(UIPanGestureRecognizer*)p
{
    // 就是悬浮小球底下的那个的window,就是APPdelegete里面的那个window属性
    // 获取正在显示的那个界面的Window,http://www.jianshu.com/p/d23763e60e94
    UIWindow *appWindow = [UIApplication sharedApplication].delegate.window;
    CGPoint panPoint = [p locationInView:appWindow];
    
    if(p.state == UIGestureRecognizerStateBegan) {
        self.alpha = 1;
    }else if(p.state == UIGestureRecognizerStateChanged) {
        [ZYSuspensionManager windowForKey:self.md5Key].center = CGPointMake(panPoint.x, panPoint.y);
    }else if(p.state == UIGestureRecognizerStateEnded
             || p.state == UIGestureRecognizerStateCancelled) {
        self.alpha = .7;
        CGFloat touchWidth = self.frame.size.width;
        CGFloat touchHeight = self.frame.size.height;
        CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
        CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
        // fabs 是取绝对值的意思
        CGFloat left = fabs(panPoint.x);
        CGFloat right = fabs(screenWidth - left);
        CGFloat top = fabs(panPoint.y);
        CGFloat bottom = fabs(screenHeight - top);
        CGFloat minSpace = 0;
        if (self.leanType == ZYSuspensionViewLeanTypeHorizontal) {
            minSpace = MIN(left, right);
        }else{
            minSpace = MIN(MIN(MIN(top, left), bottom), right);
        }
        CGPoint newCenter;
        CGFloat targetY = 0;
        //校正Y
        if (panPoint.y < 15 + touchHeight / 2.0) {
            targetY = 15 + touchHeight / 2.0;
        }else if (panPoint.y > (screenHeight - touchHeight / 2.0 - 15)) {
            targetY = screenHeight - touchHeight / 2.0 - 15;
        }else{
            targetY = panPoint.y;
        }
        
        if (minSpace == left) {
            newCenter = CGPointMake(touchHeight / 2, targetY);
        }else if (minSpace == right) {
            newCenter = CGPointMake(screenWidth - touchHeight / 2, targetY);
        }else if (minSpace == top) {
            newCenter = CGPointMake(panPoint.x, touchWidth / 2);
        }else if (minSpace == bottom) {
            newCenter = CGPointMake(panPoint.x, screenHeight - touchWidth / 2);
        }
        
        [UIView animateWithDuration:0.25 animations:^{
            [ZYSuspensionManager windowForKey:self.md5Key].center = newCenter;
        }];
    }else{
        NSLog(@"pan state : %zd", p.state);
    }
}

#pragma mark - public methods
- (void)show
{
    UIWindow *currentKeyWindow = [UIApplication sharedApplication].keyWindow;
    UIWindow *backWindow = [[UIWindow alloc] initWithFrame:self.frame];
    backWindow.windowLevel = UIWindowLevelAlert * 2;
    backWindow.rootViewController = [[ZYSuspensionViewController alloc] init];
    [backWindow makeKeyAndVisible];
    [ZYSuspensionManager saveWindow:backWindow forKey:self.md5Key];
    
    self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    //将方形切换为圆形
    self.layer.cornerRadius = self.frame.size.width / 2.0;
    // 设置圆形的外边框的颜色为白色
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    // 设置圆形的外边框的宽度为3
    self.layer.borderWidth = 3.0;
    self.clipsToBounds = YES;
    [backWindow addSubview:self];
    
    // 保持原先的keyWindow，避免一些不必要的问题,暂时还不知道会有什么问题会发生
    [currentKeyWindow makeKeyWindow];
}



- (void)click
{
    if([self.delegate respondsToSelector:@selector(suspensionViewClick:)])
    {
        [self.delegate suspensionViewClick:self];
    }
}

@end
