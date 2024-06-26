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
    var textField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 알림 권한 요청
        userNotificationCenter.delegate = self
        requestNotificationAuthorization()
        
        // 텍스트 필드 설정
        setupTextField()
    }

    func setupTextField() {
        textField = UITextField(frame: CGRect(x: 20, y: 100, width: view.bounds.width - 40, height: 40))
        textField.borderStyle = .roundedRect
        textField.placeholder = "알림을 보낼 시간을 초 단위로 입력하세요"
        textField.keyboardType = .numberPad
        view.addSubview(textField)
        
        // 숫자 키보드에 'Done' 버튼 추가
        addDoneButtonOnKeyboard()
    }

    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        textField.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        textField.resignFirstResponder()
        if let text = textField.text, let seconds = Double(text) {
            sendNotification(seconds: seconds) // 사용자가 입력한 초 후에 알림 보내기
        }
    }

    func requestNotificationAuthorization() {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        userNotificationCenter.requestAuthorization(options: authOptions) { success, error in
            if let error = error {
                print("Error: \(error)")
            }
        }
    }

    func sendNotification(seconds: Double) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "알림 테스트"
        notificationContent.body = "이것은 \(seconds)초 후의 알림입니다"

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
        let request = UNNotificationRequest(identifier: "testNotification",
                                            content: notificationContent,
                                            trigger: trigger)

        userNotificationCenter.add(request) { error in
            if let error = error {
                print("Notification Error: ", error)
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


//import UIKit
//import UserNotifications
//
//class ViewController: UIViewController {
//    
//    let userNotificationCenter = UNUserNotificationCenter.current()
//    var datePicker: UIDatePicker!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // 알림 권한 요청
//        userNotificationCenter.delegate = self
//        requestNotificationAuthorization()
//        
//        // 날짜 선택기 설정
//        setupDatePicker()
//    }
//
//    func setupDatePicker() {
//        datePicker = UIDatePicker(frame: CGRect(x: 20, y: 100, width: view.bounds.width - 40, height: 200))
//        datePicker.datePickerMode = .dateAndTime
//        datePicker.preferredDatePickerStyle = .wheels
//        datePicker.timeZone = TimeZone(identifier: "Asia/Seoul")  // 한국 시간대 설정
//        view.addSubview(datePicker)
//        
//        let button = UIButton(frame: CGRect(x: 20, y: 320, width: view.bounds.width - 40, height: 50))
//        button.setTitle("Set Notification", for: .normal)
//        button.backgroundColor = .systemBlue
//        button.addTarget(self, action: #selector(scheduleNotification), for: .touchUpInside)
//        view.addSubview(button)
//    }
//    
//    @objc func scheduleNotification() {
//        let selectedDate = datePicker.date
//        if selectedDate > Date() {
//            sendNotification(at: selectedDate)
//        } else {
//            print("Please select a future date and time.")
//        }
//    }
//
//    func sendNotification(at date: Date) {
//        let notificationContent = UNMutableNotificationContent()
//        notificationContent.title = "아요사랑해"
//        notificationContent.body = "야야야 일어나서 출발해야해 안그러면 너네 다 죽어~~"
//
//        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
//        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
//
//        let request = UNNotificationRequest(identifier: "scheduledNotification",
//                                            content: notificationContent,
//                                            trigger: trigger)
//
//        userNotificationCenter.add(request) { error in
//            if let error = error {
//                print("Notification Error: ", error)
//            } else {
//                print("Notification scheduled for \(date) with trigger \(triggerDate)")
//            }
//        }
//    }
//
//
//    func requestNotificationAuthorization() {
//        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//        userNotificationCenter.requestAuthorization(options: authOptions) { [weak self] success, error in
//            if let error = error {
//                print("Error: \(error)")
//            } else {
//                print("Notification permission granted: \(success)")
//                DispatchQueue.main.async {
//                    self?.userNotificationCenter.getNotificationSettings { settings in
//                        print("Notification settings: \(settings)")
//                    }
//                }
//            }
//        }
//    }
//
//}
//
//extension ViewController: UNUserNotificationCenterDelegate {
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        completionHandler()
//    }
//
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        completionHandler([.alert, .badge, .sound])
//    }
//}
