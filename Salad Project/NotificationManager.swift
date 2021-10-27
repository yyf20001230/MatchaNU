//
//  NotificationManager.swift
//  Salad Project
//
//  Created by Yunfan Yang on 10/26/21.
//

import Foundation
import UserNotifications
import UIKit

final class NotificationManager: ObservableObject{
    @Published private(set) var notifications: [UNNotificationRequest] = []
    @Published private(set) var authorizationStatus: UNAuthorizationStatus?
    
    func reloadAuthorizationStatus(){
        UNUserNotificationCenter.current().getNotificationSettings{ settings in
            DispatchQueue.main.async {
                self.authorizationStatus = settings.authorizationStatus
            }
        }
    }
    
    func requestAuthorization(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]){ isGranted, _ in
            DispatchQueue.main.async {
                self.authorizationStatus = isGranted ? .authorized : .denied
            }
        }
    }
    
    func reloadLocalNotifications(){
        print("reload notification")
        UNUserNotificationCenter.current().getPendingNotificationRequests{ notifications in
            DispatchQueue.main.async {
                self.notifications = notifications
            }
        }
    }
    
    func createNotification(title: String, body: String, hour: Int, min: Int, weekday: Int, completion: @escaping (Error?) -> Void){
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = min
        dateComponents.weekday = weekday
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.sound = .default
        notificationContent.body = body
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content:  notificationContent, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: completion)
        
        
        print(title)
        print(body)
        print(hour)
        print(min)
        print(weekday)
        
    }
    
    func deleteLocalNotifications(identifiers: [String]){
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
    }
    
    func emptyLocalNotifications(){
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
