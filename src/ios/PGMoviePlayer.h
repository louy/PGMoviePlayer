//
//  PGMoviePlayer.h
//  Abu Dhabi TV
//
//  Created by Louy on ٢٦‏/٣‏/٢٠١٤.
//
//

#import <Cordova/CDV.h>
#import <MediaPlayer/MediaPlayer.h>

@interface PGMoviePlayer : CDVPlugin
{
    MPMoviePlayerViewController *movieController;
    NSString* callbackId;
}

- (void)init:(CDVInvokedUrlCommand*)command;
- (void)play:(CDVInvokedUrlCommand*)command;
- (void)stop:(CDVInvokedUrlCommand*)command;

@end
