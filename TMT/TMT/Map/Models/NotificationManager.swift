//
//  NotificationManager.swift
//  TMT
//
//  Created by Choi Minkyeong on 11/28/24.
//


import Foundation
import UserNotifications

class NotificationManager: ObservableObject {
    
    static let shared = NotificationManager()
    
    /// 알림 권한 요청
    func requestNotificationPermission() async {
        do {
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
            print("알림 권한 요청 결과: \(granted)")
        } catch {
            print("알림 권한 요청 실패: \(error)")
        }
    }
    
    /// 알림 요청
    func scheduleBusArrivalNotification() {
        let content = UNMutableNotificationContent()
        content.title = "BusStop"
        content.body = "You have arrived at your destination."
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "busArrival", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error)")
            } else {
                print("Notification scheduled successfully.")
            }
        }
    }
}
