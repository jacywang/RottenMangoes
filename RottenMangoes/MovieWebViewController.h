//
//  MovieWebViewController.h
//  RottenMangoes
//
//  Created by JIAN WANG on 5/27/15.
//  Copyright (c) 2015 JWANG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieWebViewController : UIViewController

@property (nonatomic, strong) NSString *urlString;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
