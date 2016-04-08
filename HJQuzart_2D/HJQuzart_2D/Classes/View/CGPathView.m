//
//  CGPathView.m
//  HJQuzart_2D
//
//  Created by coco on 16/3/30.
//  Copyright © 2016年 XHJ. All rights reserved.
//

#import "CGPathView.h"
#define PI 3.14159265358979323846 
@implementation CGPathView
/**
 *  @author XHJ, 16-03-30 16:03:54
 *  desc :http://www.jcodecraeer.com/IOS/2015/0204/2414.html
 *  iOS的绘图操作是在UIView类的drawRect方法中完成的，所以如果我们要想在一个UIView中绘图，需要写一个扩展UIView 的类，并重写drawRect方法，在这里进行绘图操作，程序会自动调用此方法进行绘图。这个方法在ViewDidLoad之后运行
 *  再说明一下重绘，重绘操作仍然在drawRect方法中完成，但是苹果不建议直接调用drawRect方法，当然如果你强直直接调用此方法，当然是没有效果的。苹果要求我们调用UIView类中的setNeedsDisplay方法，则程序会自动调用drawRect方法进行重绘。（调用setNeedsDisplay会自动调用drawRect）
 在UIView中,重写drawRect: (CGRect) aRect方法,可以自己定义想要画的图案.且此方法一般情况下只会画一次.也就是说这个drawRect方法一般情况下只会被掉用一次. 当某些情况下想要手动重画这个View,只需要掉用[self setNeedsDisplay]方法即可.
 
 drawRect调是在Controller->loadView, Controller->viewDidLoad 两方法之后掉用的.所以不用担心在控制器中,这些View的drawRect就开始画了.这样可以在控制器中设置一些值给View(如果这些View draw的时候需要用到某些变量值).
 
 1.如果在UIView初始化时没有设置rect大小，将直接导致drawRect不被自动调用。
 2.该方法在调用sizeThatFits后被调用，所以可以先调用sizeToFit计算出size。然后系统自动调用drawRect:方法。
 3.通过设置contentMode属性值为UIViewContentModeRedraw。那么将在每次设置或更改frame的时候自动调用drawRect:。
 4.直接调用setNeedsDisplay，或者setNeedsDisplayInRect:触发drawRect:，但是有个前提条件是rect不能为0.
 以上1,2推荐；而3,4不提倡
 1、若使用UIView绘图，只能在drawRect：方法中获取相应的contextRef并绘图。如果在其他方法中获取将获取到一个invalidate的ref并且不能用于画图。drawRect：方法不能手动显示调用，必须通过调用setNeedsDisplay 或者 setNeedsDisplayInRect ，让系统自动调该方法。
 2、若使用calayer绘图，只能在drawInContext: 中（类似鱼drawRect）绘制，或者在delegate中的相应方法绘制。同样也是调用setNeedDisplay等间接调用以上方法。
 3、若要实时画图，不能使用gestureRecognizer，只能使用touchbegan等方法来掉用setNeedsDisplay实时刷新屏幕
 *  @param rect
 */
- (void)drawRect:(CGRect)rect {
    //获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //1⃣️画线
    [self drawLineWithContext:context];
    //2⃣️画圆
    [self drawCirleWithContext:context];
    //3⃣️三角形
    //加个点之间加线
    
    //4⃣️绘制渐变颜色
    [self drawChangeColorWithContext:context];
}
/*画线*/
- (void)drawLineWithContext:(CGContextRef)context {
    //方法1:绿线
    CGMutablePathRef path = CGPathCreateMutable();  //路径
    CGPathMoveToPoint(path, nil, 0, 33);  //移动到点
    CGPathAddLineToPoint(path, nil, self.frame.size.width, 33); //添加线
    CGContextAddPath(context, path);  //往上下文添加路径
    CGContextSetLineWidth(context, 3.0f);  //设置线宽
    
    //设置颜色的几种方法
    CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
//    CGContextSetRGBFillColor(context, 1, 0, 0, 1); //设置填充颜色
//    CGContextSetRGBStrokeColor(context, 0, 1, 0, 1);//设置描边颜色
//    [[UIColor redColor] set];  //统一设置填充颜色和描边颜色
//    [[UIColor redColor] setStroke]; //设置秒变颜色
//    [[UIColor blueColor] setFill]; //设置填充颜色
    
    CGContextDrawPath(context, kCGPathStroke);  //绘制图形到上下文
    CGPathRelease(path);
    
    //方法2:红线
    CGContextMoveToPoint(context, 0, 50);
    CGContextAddLineToPoint(context, self.frame.size.width, 50);
    CGContextSetLineWidth(context, 2);
    CGContextSetRGBStrokeColor(context, 1, 0, 0, 1);
    CGContextDrawPath(context, kCGPathStroke);
    
    //方法3:
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, 60)];
    [bezierPath addLineToPoint:CGPointMake(self.frame.size.width, 60)];
    bezierPath.lineWidth = 4;
//    [[UIColor blueColor] setStroke];
    CGContextSetRGBStrokeColor(context, 1, 0, 1, 1);

    [bezierPath stroke];
}
/*画圆*/
- (void)drawCirleWithContext:(CGContextRef)context {
    //方法1:
    CGMutablePathRef path = CGPathCreateMutable();
    //圆弧
    /*
     * path 路径
    CGAffineTransform  做移位的参数  旋转 平移  缩放等
     CGFloat x,   圆点x
     CGFloat y,   圆点y
     CGFloat radius,   半径
     CGFloat startAngle,   开始弧度
     CGFloat endAngle,  结束弧度
     bool clockwise   顺时针还是逆时针
     */
    CGPathAddArc(path, nil, 20, 100, 20, 0, M_PI * 1.5, NO);
    CGPathAddLineToPoint(path, nil, 20, 100);
    
    /*
    CGPathMoveToPoint(path,nil, 100, 90);
    //右上角和右下角两个点，画出半个圆角
    CGPathAddArcToPoint(path, nil, 190, 90, 190, 190, 30);
    //右下角和左下角两个点，画出另外半个圆角
    CGPathAddArcToPoint(path, nil, 190, 190, 90, 190, 30);
    //CGPathAddArcToPoint会在交点中停止，所以需要再次调用CGPathAddLineToPoint画出下面的线
    CGPathAddLineToPoint(path, nil, 100, 190);
    */
    CGContextAddPath(context, path);
    CGContextSetRGBStrokeColor(context, 1, 0, 0, 1);
    
    CGContextDrawPath(context, kCGPathFillStroke);
    
    //方法2:
    CGContextAddArc(context, 60, 100, 15, M_PI, M_PI * 2, NO);
    CGContextSetRGBStrokeColor(context, 0, .5, 1, 1);
    CGContextDrawPath(context, kCGPathStroke);
    
    //方法3:
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(100, 100) radius:15 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    bezierPath.lineWidth = 5;
    [[UIColor blueColor] setStroke];
    [[UIColor redColor] setFill];
//    [bezierPath stroke];
//    [bezierPath fill];
    CGContextAddPath(context, bezierPath.CGPath);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    
    //方法4;
    UIBezierPath *path1 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(100, 100, 50, 50)];
    [path1 stroke];
    
    UIBezierPath *path2 = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(160, 80, 100, 80) cornerRadius:15];
    [path2 stroke];
    
    //方法5:
    CGContextMoveToPoint(context, 10, 100);
    CGContextAddCurveToPoint(context, 10, 90, 110, 170, 300, 130); //三次贝塞尔曲线
    
    CGContextMoveToPoint(context, 90, 200);
    CGContextAddQuadCurveToPoint(context, 300, 100, 100, 300); //二次贝塞尔曲线
    
//    CGContextAddEllipseInRect(context, CGRectMake(170, 150, 80, 30));
    CGContextDrawPath(context, kCGPathStroke);
    
    
    NSString *string = @"画东西步骤:\n1⃣️获取上下文\n2⃣️绘制路径\n3⃣️添加到上下文\n4⃣️渲染,\n方法1:使用CGPath,需要加到上下文中,CGContextAddPath, \n方法2:使用CGContextAdd函数,\n方法3:使用UIBezierPath画图形";
   CGRect frame =   [string boundingRectWithSize:CGSizeMake(self.frame.size.width - 20, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor redColor]} context:nil];
    [string drawInRect:CGRectMake(10, 330, frame.size.width - 20, frame.size.height) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor redColor]}];
    
    
    
    UIImage *image = [UIImage imageNamed:@"4_XNT(CPXOLE`G%([POX7N0.jpg"];
//    [image drawInRect:CGRectMake(330, 330, 50, 50)];
//    [image drawAtPoint:CGPointMake(330, 330)];
    
    //由于在Core Graphics中坐标系的y轴正方向是向上的，坐标原点在屏幕左下角，y轴方向刚好和UIKit中y轴方向相反,所以使用CGContext内部方法绘制图片的时候方向是和UIKit显示的时候不一样,这个时候就可以使用移位方法
    
//    CGContextScaleCTM(context, 1.0, -1.0);//在y轴缩放-1相当于沿着x张旋转180
//    CGContextTranslateCTM(context, 0, -(50-(50-2*330-50)));//向上平移

    CGContextDrawImage(context, CGRectMake(150, 330, 50, 50), image.CGImage);

//    CGContextRotateCTM(context, -1);
//    CGContextDrawTiledImage(context, CGRectMake(330, 330, 50, 50), image.CGImage); //平铺了
}
/*绘制渐变颜色*/
- (void)drawChangeColorWithContext:(CGContextRef)context {
    
    /*
     //这里是先裁剪出一块区域在去调用渐变填充色
    CGContextAddEllipseInRect(context, CGRectMake(100, 100, 200, 200));
    CGContextClip(context);
    */
    
    //使用rgb颜色空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //线性渐变
    /*指定渐变色
     space:颜色空间
     components:颜色数组,注意由于指定了RGB颜色空间，那么四个数组元素表示一个颜色（red、green、blue、alpha），
     如果有三个颜色则这个数组有4*3个元素
     locations:颜色所在位置（范围0~1），这个数组的个数不小于components中存放颜色的个数
     count:渐变个数，等于locations的个数
     */
    CGFloat compoents[12]={
        248.0/255.0, 86.0/255.0,  86.0/255.0, 1,
        249.0/255.0,127.0/255.0,127.0/255.0,1,
        1.0,1.0,1.0,1.0
    };
    CGFloat locations[3]={0,0.3,1.0};
    CGGradientRef gradient= CGGradientCreateWithColorComponents(colorSpace, compoents, locations, 3);
    
    //设置叠加模式
    CGContextSetBlendMode(context, kCGBlendModeMultiply);
    
    /*绘制线性渐变
     context:图形上下文
     gradient:渐变色
     startPoint:起始位置
     endPoint:终止位置
     options:绘制方式,kCGGradientDrawsBeforeStartLocation 开始位置之前就进行绘制，到结束位置之后不再绘制，
     kCGGradientDrawsAfterEndLocation开始位置之前不进行绘制，到结束点之后继续填充
     */
    CGContextDrawLinearGradient(context, gradient, CGPointZero, CGPointMake(320, 300), kCGGradientDrawsAfterEndLocation);
    
    
    /*绘制径向渐变
     context:图形上下文
     gradient:渐变色
     startCenter:起始点位置
     startRadius:起始半径（通常为0，否则在此半径范围内容无任何填充）
     endCenter:终点位置（通常和起始点相同，否则会有偏移）
     endRadius:终点半径（也就是渐变的扩散长度）
     options:绘制方式,kCGGradientDrawsBeforeStartLocation 开始位置之前就进行绘制，但是到结束位置之后不再绘制，
     kCGGradientDrawsAfterEndLocation开始位置之前不进行绘制，但到结束点之后继续填充
     */
    
    CGContextDrawRadialGradient(context, gradient, CGPointMake(160, 284),0, CGPointMake(165, 289), 150, kCGGradientDrawsAfterEndLocation);
    
    //释放颜色空间
    CGColorSpaceRelease(colorSpace);
    
    //方法3:必须导入类库quartcore并#import <QuartzCore/QuartzCore.h>，这个就不属于在context上画，而是将层插入到view层上面。那么这里就设计到Quartz Core 图层编程了。
    CAGradientLayer *gradient1 = [CAGradientLayer layer];
    gradient1.frame = CGRectMake(240, 120, 60, 30);
    gradient1.colors = [NSArray arrayWithObjects:(id)[UIColor whiteColor].CGColor,
                        (id)[UIColor grayColor].CGColor,
                        (id)[UIColor blackColor].CGColor,
                        (id)[UIColor yellowColor].CGColor,
                        (id)[UIColor blueColor].CGColor,
                        (id)[UIColor redColor].CGColor,
                        (id)[UIColor greenColor].CGColor,
                        (id)[UIColor orangeColor].CGColor,
                        (id)[UIColor brownColor].CGColor,nil];
    [self.layer insertSublayer:gradient1 atIndex:0];
}
@end







