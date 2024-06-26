//
//  ViewController.swift
//  webhook
//
//  Created by 이지훈 on 6/24/24.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    
    let userNotificationCenter = UNUserNotificationCenter.current()
    var datePicker: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 알림 권한 요청
        userNotificationCenter.delegate = self
        requestNotificationAuthorization()
        
        // 날짜 선택기 설정
        setupDatePicker()
    }

    func setupDatePicker() {
        datePicker = UIDatePicker(frame: CGRect(x: 20, y: 100, width: view.bounds.width - 40, height: 200))
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.timeZone = TimeZone(identifier: "Asia/Seoul")  // 한국 시간대 설정
        view.addSubview(datePicker)
        
        let button = UIButton(frame: CGRect(x: 20, y: 320, width: view.bounds.width - 40, height: 50))
        button.setTitle("Set Notification", for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(scheduleNotification), for: .touchUpInside)
        view.addSubview(button)
    }
    
    @objc func scheduleNotification() {
        let selectedDate = datePicker.date
        if selectedDate > Date() {
            sendNotification(at: selectedDate)
        } else {
            print("Please select a future date and time.")
        }
    }

    func sendNotification(at date: Date) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "아요사랑해"
        notificationContent.body = "야야야 일어나서 출발해야해 안그러면 너네 다 죽어~~"

        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        let request = UNNotificationRequest(identifier: "scheduledNotification",
                                            content: notificationContent,
                                            trigger: trigger)

        userNotificationCenter.add(request) { error in
            if let error = error {
                print("Notification Error: ", error)
            } else {
                print("Notification scheduled for \(date) with trigger \(triggerDate)")
            }
        }
    }


    func requestNotificationAuthorization() {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        userNotificationCenter.requestAuthorization(options: authOptions) { [weak self] success, error in
            if let error = error {
                print("Error: \(error)")
            } else {
                print("Notification permission granted: \(success)")
                DispatchQueue.main.async {
                    self?.userNotificationCenter.getNotificationSettings { settings in
                        print("Notification settings: \(settings)")
                    }
                }
            }
        }
    }

}

extension ViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
}
