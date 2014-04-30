//
//  PGMoviePlayer.m
//  Abu Dhabi TV
//
//  Created by Louy on ٢٦‏/٣‏/٢٠١٤.
//
//

#import "PGMoviePlayer.h"

#import <MediaPlayer/MediaPlayer.h>
#import <Cordova/CDV.h>

@implementation PGMoviePlayer

- (void)init:(CDVInvokedUrlCommand*)command {
    callbackId = command.callbackId;
}
- (void)play:(CDVInvokedUrlCommand*)command {
    NSString* link = [command argumentAtIndex:0];
    
    NSURL *movieURL = [NSURL URLWithString:link];
    movieController = [[MPMoviePlayerViewController alloc] initWithContentURL:movieURL];
    [super.viewController presentMoviePlayerViewControllerAnimated:movieController];
    
    [movieController.moviePlayer play];
    [self sendUpdate:@{@"type":@"start",@"link":link}];
}
- (void)stop:(CDVInvokedUrlCommand*)command {
    if( [self closePlayer] ) {
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
        return;
    }
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
}

- (void)pluginInitialize {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayerExit:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayerFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:nil];

}

- (BOOL) closePlayer
{
    if (movieController != nil)
    {
        [movieController dismissMoviePlayerViewControllerAnimated];
        movieController = nil;
        
        [self sendUpdate:@{@"type":@"stop"}];
        
        return true;
    }
    return false;
}

-(void)moviePlayerExit:(NSNotification*)aNotification{
    [self closePlayer];
}
-(void)moviePlayerFinish:(NSNotification*)aNotification{
    
    NSDictionary *notificationUserInfo = [aNotification userInfo];
    NSNumber *resultValue = [notificationUserInfo objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    MPMovieFinishReason reason = [resultValue intValue];
    if (reason == MPMovieFinishReasonPlaybackError)
    {
        NSError *mediaPlayerError = [notificationUserInfo objectForKey:@"error"];
        if (mediaPlayerError)
        {
            [self sendProblem:@{@"type":@"error",
                           @"code": [@([mediaPlayerError code]) stringValue],
                                @"message": [mediaPlayerError localizedDescription]}];
            NSLog(@"playback failed with error description: %@", [mediaPlayerError localizedDescription]);
        }
        else
        {
            NSLog(@"playback failed without any given reason");
        }
    }

    [self closePlayer];
}

-(void)sendUpdate:(NSDictionary*)dictionary {
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                  messageAsDictionary:dictionary];
    [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
    [self.commandDelegate sendPluginResult:pluginResult
                                callbackId:callbackId];
}

-(void)sendProblem:(NSDictionary*)dictionary {
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                  messageAsDictionary:dictionary];
    [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
    [self.commandDelegate sendPluginResult:pluginResult
                                callbackId:callbackId];
}
@end
