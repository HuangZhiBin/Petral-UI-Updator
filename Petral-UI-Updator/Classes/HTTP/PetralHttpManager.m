//
//  PetralHttpManager.m
//  Petral_Example
//
//  Created by huangzhibin on 2019/8/6.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

#import "PetralHttpManager.h"
#import "HTTPServer.h"
#import "PetralHttpConnection.h"
#import <UIKit/UIKit.h>
#import "ZYSuspensionView.h"
#import <ifaddrs.h>
#import <arpa/inet.h>

@interface PetralHttpManager ()<ZYSuspensionViewDelegate>
{
    HTTPServer *httpServer;
}
@end

@implementation PetralHttpManager

static PetralHttpManager* _instance = nil;

+(instancetype) sharedInstance {
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init];
        
    }) ;
    
    return _instance ;
}

+(id) allocWithZone:(struct _NSZone *)zone {
    return [PetralHttpManager sharedInstance] ;
}

-(id) copyWithZone:(struct _NSZone *)zone {
    return [PetralHttpManager sharedInstance] ;
}

- (void)startServer:(NSString*) rootDirectory {
    // Configure our logging framework.
    
    self.rootDirectory = rootDirectory;
    NSString *ip = [self getIPAddress];
    UInt16 port = 12345;
    self.url = [NSString stringWithFormat:@"%@:%d", ip, port];
    
    // Initalize our http server
    httpServer = [[HTTPServer alloc] init];
    
    // Tell the server to broadcast its presence via Bonjour.
    [httpServer setType:@"_http._tcp."];
    
    // Normally there's no need to run our server on any specific port.
    [httpServer setPort:port];
    
    // We're going to extend the base HTTPConnection class with our MyHTTPConnection class.
    [httpServer setConnectionClass:[PetralHttpConnection class]];
    
    // Serve files from our embedded Web folder
    NSString *webPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Web"];
    webPath = rootDirectory;//@"/Users/bin/Downloads/LocalHTTPServer-master/LocalHTTPServer/";
    NSLog(@"Setting document root: %@", webPath);
    [httpServer setDocumentRoot:webPath];
    
    NSError *error = nil;
    if(![httpServer start:&error])
    {
        NSLog(@"Error starting HTTP Server: %@", error);
    }
    else{
        ZYSuspensionView *sus2 = [[ZYSuspensionView alloc] initWithFrame:CGRectMake(UIScreen.mainScreen.bounds.size.width-40, 300, 40, 40)
                                                                   color:[UIColor orangeColor]
                                                                delegate:self];
        sus2.leanType = ZYSuspensionViewLeanTypeEachSide;
//        [sus2 setTitle:@"reload" forState:UIControlStateNormal];
        [sus2 setImage:[UIImage imageNamed:@"float_button_refresh"] forState:UIControlStateNormal];
        [sus2 show];
        
//        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://127.0.0.1:12345/ViewController.xml"]];
//        NSLog(@"data=%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    }
}

#pragma mark - ZYSuspensionViewDelegate
- (void)suspensionViewClick:(ZYSuspensionView *)suspensionView
{
    UIViewController *ctrl = [self getCurrentVC];
    if(ctrl != nil){
        SEL selector = NSSelectorFromString(@"resetUI");
        if([ctrl respondsToSelector:selector]){
            [ctrl performSelector:selector];
        }
    }
    
    NSLog(@"click %@",suspensionView.titleLabel.text);
}

- (UIViewController *)getCurrentVC{
    return [self getCurrentVCFrom:nil];
}

- (UIViewController *)getCurrentVCFrom:(UIViewController * __nullable)rootVC
{
    if(!rootVC){
        rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    }
    UIViewController *currentVC = nil;
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        rootVC = [rootVC presentedViewController];
    }
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
    } else {
        // 根视图为非导航类
        currentVC = rootVC;
    }
    return currentVC;
}

// Get IP Address
- (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}
/*
 var httpServer: HTTPServer!;
 
 func startServer(rootDirectory: String){
 httpServer = HTTPServer.init();
 httpServer.setType("_http._tcp.");
 httpServer.setPort(12345);
 httpServer.setConnectionClass(PetralHttpConnection.classForCoder());
 let webPath = rootDirectory;
 // Serve files from our embedded Web folder
 httpServer.setDocumentRoot(webPath);
 do{
 try httpServer.start();
 
 let data = try Data.init(contentsOf: URL.init(string: "http://127.0.0.1:12345/ViewController.xml")!);
 print("data=\(NSString.init(data: data, encoding: String.Encoding.utf8.rawValue) ?? "nil")");
 
 //            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://127.0.0.1:12345/ViewController.xml"]];
 //            NSLog(@"data=%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
 }catch{
 print("Error starting HTTP Server: \(error)");
 }
 }
 */

@end
