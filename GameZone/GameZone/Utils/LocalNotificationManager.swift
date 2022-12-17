//
//  LocalNotificationManager.swift
//  GameZone
//
//  Created by Emin Saygı on 17.12.2022.
//

import UserNotifications

class LocalNotificationManager {
    static let shared = LocalNotificationManager()

    private init() {}

    func checkPermission() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestPermission()
            case .authorized:
                print("Bildirim izinleri alındı")
            case .denied:
                print("Bildirim izinleri alınamadı")
            default:
                break
            }
        }
    }

    func requestPermission() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (granted, error) in
            if granted {
                print("Bildirim izinleri alındı")
            } else {
                print("Bildirim izinleri alınamadı")
            }
        }
    }

    func sendNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Game Zone"
        content.body = " Heyy! Oyunları incelemek ister misin.."

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: true)

        let request = UNNotificationRequest(identifier: "bildirim-id", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }
}
