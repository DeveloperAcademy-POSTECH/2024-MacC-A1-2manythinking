//
//  AppDelegate.swift
//  TMT
//
//  Created by Choi Minkyeong on 11/26/24.
//

import SwiftUI
import UserNotifications

// TODO: Foreground 상태일때도 알림 처리가 필요할까?
class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 알림 대리자 설정
        UNUserNotificationCenter.current().delegate = self
        
        // 알림 권한 요청
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
//            if let error = error {
//                print("알림 권한 요청 실패: \(error.localizedDescription)")
//            }
//            print("알림 권한 허용 여부: \(granted)")
//        }
//        
        return true
    }
    
    // 포그라운드 알림 처리
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}
