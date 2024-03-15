//
//  WPDrawDefines.h
//  AVDemo
//
//  Created by daicanglan on 2024/3/15.
//

#ifndef WPDrawDefines_h
#define WPDrawDefines_h


typedef NS_ENUM(NSInteger,WPDrawType) {
    WPDrawTypeUndefined  = 0,
    WPDrawTypeDraw       = 1,
    WPDrawTypeEraser     = 2,
    WPDrawTypeUndo       = 3,
    WPDrawTypeRedo       = 4,
    WPDrawTypeClearAll   = 5,
};

#define kDrawCanvasRatio (375.0/325)

#define kDrawCanvasRatio (375.0/325)

#define kDrawMaxPointNumPerTrace 50

#define UIColorFromHex(x) [UIColor colorWithRed:(((x)>>16)&0xff)/255.0f green:(((x)>>8)&0xff)/255.0f blue:((x)&0xff)/255.0f alpha:1]

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

#endif /* WPDrawDefines_h */
