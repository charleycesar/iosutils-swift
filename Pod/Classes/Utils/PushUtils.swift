//
//  PushUtils.swift
//  Pods
//
//  Created by Livetouch-Mini01 on 06/07/2016.
//
//

import UIKit

//#import "Firebase/Firebase.h"

///REQUER INTEGRAÇÃO COM O FIREBASE ANTES

open class PushUtils: NSObject {
    
//    + (void) start
//    {
//    //    [FIRApp configure];
//    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenRefreshNotification:) name:kFIRInstanceIDTokenRefreshNotification object:nil];
//    [LTPushUtils onPushConnect];
//    }
//    
//    + (void)onPushConnect
//    {
//    //    [[FIRMessaging messaging] connectWithCompletion:^(NSError * _Nullable error)
//    //     {
//    //         if (error != nil)
//    //         {
//    //             NSLog(@"Unable to connect to FCM. %@", error);
//    //         }
//    //         else
//    //         {
//    //             NSLog(@"Connected to FCM.");
//    //         }
//    //     }];
//    }
//    
//    + (void)onPushDisconnect
//    {
//    //    [[FIRMessaging messaging] disconnect];
//    }
//    
//    + (NSString*)getToken
//    {
//    //    FIRInstanceID *fcmInstance = [FIRInstanceID instanceID];
//    //    NSString *token = [fcmInstance token];
//    NSString *token = nil;
//    return token;
//    }
//    
//    + (void)forceTokenRefresh:(NSString*)reason
//    {
//    NSLog(@"Forcing token refresh notification with reason: %@", reason);
//    //    [[NSNotificationCenter defaultCenter] postNotificationName:kFIRInstanceIDTokenRefreshNotification object:nil];
//    }
//    
//    - (void)tokenRefreshNotification:(NSNotification *)notification
//    {
//    //    FIRInstanceID *fcmInstance = [FIRInstanceID instanceID];
//    //    NSString *refreshedToken = [fcmInstance token];
//    NSString *refreshedToken = nil;
//    NSLog(@"InstanceID Token: %@", refreshedToken);
//    
//    if (refreshedToken != nil)
//    {
//    // Contecta ao FCM pois a conexão pode ter falhado por não ter um Token anteriormente.
//    [LTPushUtils onPushConnect];
//    
//    // Chama a função do delegate para rodar o código que quiser depois de ter dado o refresh no token (ex: enviar token para o servidor / salvar nas prefs)
//    [self.delegate onTokenRefresh:refreshedToken];
//    }
//    }
    
}
