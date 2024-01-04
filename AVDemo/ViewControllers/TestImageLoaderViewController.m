//
//  TestImageLoaderViewController.m
//  AVDemo
//
//  Created by cl d on 2023/12/31.
//

#import "TestImageLoaderViewController.h"
#import <ToyImageLoader/UIImageView+Loader.h>
@interface TestImageLoaderViewController ()

@end

@implementation TestImageLoaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imageView = [UIImageView new];
    NSMutableArray<NSString *> *objects = [NSMutableArray arrayWithObjects:
                   @"https://placehold.co/200x200.jpg",
//                @"https://www.httpwatch.com/httpgallery/authentication/authenticatedimage/default.aspx?0.35786508303135633",     // requires HTTP auth, used to demo the NTLM auth
                @"http://assets.sbnation.com/assets/2512203/dogflops.gif",
                @"https://raw.githubusercontent.com/liyong03/YLGIFImage/master/YLGIFImageDemo/YLGIFImageDemo/joy.gif",
                @"http://apng.onevcat.com/assets/elephant.png",
                @"http://www.ioncannon.net/wp-content/uploads/2011/06/test2.webp",
                @"http://www.ioncannon.net/wp-content/uploads/2011/06/test9.webp",
                @"http://littlesvr.ca/apng/images/SteamEngine.webp",
                @"http://littlesvr.ca/apng/images/world-cup-2014-42.webp",
                @"https://isparta.github.io/compare-webp/image/gif_webp/webp/2.webp",
                @"https://nokiatech.github.io/heif/content/images/ski_jump_1440x960.heic",
                @"https://nokiatech.github.io/heif/content/image_sequences/starfield_animation.heic",
                @"https://s2.ax1x.com/2019/11/01/KHYIgJ.gif",
                @"https://raw.githubusercontent.com/icons8/flat-color-icons/master/pdf/stack_of_photos.pdf",
                @"https://nr-platform.s3.amazonaws.com/uploads/platform/published_extension/branding_icon/275/AmazonS3.png",
                @"https://res.cloudinary.com/dwpjzbyux/raw/upload/v1666474070/RawDemo/raw_vebed5.NEF",
                @"https://placehold.co/200x200.jpg",
                nil];
    [imageView tl_loadImageWithURL: [NSURL URLWithString: objects.firstObject] placeholder:[NSURL URLWithString: objects.lastObject] ];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
