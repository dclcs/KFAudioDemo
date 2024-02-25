//
//  TestImageLoaderViewController.m
//  AVDemo
//
//  Created by cl d on 2023/12/31.
//

#import "TestImageLoaderViewController.h"
#import <ToyImageLoader/UIImageView+Loader.h>
#import <ToyImageLoader/TILImageManager.h>
#import <ToyImageLoader/UIView+Loader.h>
@interface TestImageLoaderViewController ()

@end

@implementation TestImageLoaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    UIImageView *imageView = [UIImageView new];
    imageView.frame = CGRectMake(100, 300, 100, 100);
//    imageView.backgroundColor = UIColor.blueColor;
    NSMutableArray<NSString *> *objects = [NSMutableArray arrayWithObjects:
                                           @"https://i1.hdslb.com/bfs/face/75d844cc2e9add3d34e8b0245ad8e7c7a1c9e6e2.jpg",
//                   @"https://nr-platform.s3.amazonaws.com/uploads/platform/published_extension/branding_icon/275/AmazonS3.png",
//                @"https://www.httpwatch.com/httpgallery/authentication/authenticatedimage/default.aspx?0.35786508303135633",     // requires HTTP auth, used to demo the NTLM auth
                                           @"https://i0.hdslb.com/bfs/sycp/creative_img/202402/3883da9be7e2b385426f06988f2e1003.jpg@336w_190h_!web-video-ad-cover.webp",
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
//    [imageView tl_loadImageWithURL: [NSURL URLWithString: objects.firstObject] placeholder:[UIImage imageNamed:@"placeholder"]];
    if (!imageView.til_imageIndicator) {
        imageView.til_imageIndicator = TILWebImageProgressIndicator.defaultIndicator;
    }
    [imageView tl_setImageWithURL:[NSURL URLWithString: objects.firstObject] placeholderImage:[UIImage imageNamed:@"placeholder"]];

    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    [btn addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    btn.backgroundColor = UIColor.redColor;
    
    [self.view addSubview:imageView];
    
}


- (void)btnClicked
{
    [TILImageManager.sharedManager.imageCache clearWithCacheType:TILImageCacheTypeAll completion:nil];
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
