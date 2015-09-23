//
//  Extension.m
//  QQ聊天布局
//
//  Created by 张锋 on 15/3/8.
//  Copyright (c) 2015年 张锋. All rights reserved.
//

#import "Extension.h"

@implementation UIImage(Extension)
//返回一张能够拉伸的图片
+(UIImage *)resizeableImage:(NSString *)name{
    UIImage *normal=[UIImage imageNamed: name];
    CGFloat w=normal.size.width*0.5;
    CGFloat h=normal.size.height*0.5;
    //将原图去中间一个小点进行拉伸   或者平铺
    return [normal resizableImageWithCapInsets:UIEdgeInsetsMake(h, w, h, w) resizingMode:UIImageResizingModeStretch];
}
@end
