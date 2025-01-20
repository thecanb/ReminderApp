import Foundation
import UserNotifications

class NotificationManager: NSObject {
    static let shared = NotificationManager()
    
    private override init() {
        super.init()
        // Bildirim merkezini yapılandır
        UNUserNotificationCenter.current().delegate = self
        
        // Bildirim aksiyonlarını ayarla
        let completeAction = UNNotificationAction(
            identifier: "COMPLETE_ACTION",
            title: "Tamamlandı",
            options: .foreground
        )
        
        let snoozeAction = UNNotificationAction(
            identifier: "SNOOZE_ACTION",
            title: "15 Dakika Ertele",
            options: .foreground
        )
        
        let category = UNNotificationCategory(
            identifier: "REMINDER_CATEGORY",
            actions: [completeAction, snoozeAction],
            intentIdentifiers: [],
            options: []
        )
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
    
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
            if success {
                print("Bildirim izni verildi")
            } else if let error = error {
                print("Bildirim izni hatası: \(error.localizedDescription)")
            }
        }
    }
    
    func scheduleNotification(for reminder: Reminder) {
        guard let dueDate = reminder.dueDate else { return }
        
        // Önceki bildirimleri temizle
        if let oldId = reminder.notificationId {
            cancelNotification(withId: oldId)
        }
        
        let content = UNMutableNotificationContent()
        content.title = reminder.title
        content.body = reminder.notes ?? "Anımsatıcınız var!"
        content.sound = .default
        
        // Önceliğe göre bildirim kategorisi
        switch reminder.priority {
        case .high:
            content.title = "⚠️ " + content.title
            content.sound = UNNotificationSound.default
        case .normal:
            content.sound = UNNotificationSound.default
        case .low:
            content.sound = nil // Sessiz bildirim
        }
        
        // Özel bildirim aksiyonları ekle
        content.categoryIdentifier = "REMINDER_CATEGORY"
        
        // 30 dakika önce bildirim
        let earlyDate = dueDate.addingTimeInterval(-1800) // 30 dakika önce
        if earlyDate > Date() {
            scheduleSpecificNotification(for: reminder, at: earlyDate, with: content, isEarly: true)
        }
        
        // Tam zamanında bildirim
        if dueDate > Date() {
            scheduleSpecificNotification(for: reminder, at: dueDate, with: content, isEarly: false)
        }
    }
    
    private func scheduleSpecificNotification(for reminder: Reminder, at date: Date, with content: UNNotificationContent, isEarly: Bool) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let identifier = "\(reminder.id.uuidString)-\(isEarly ? "early" : "exact")"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Bildirim planlanırken hata: \(error.localizedDescription)")
            } else {
                print("Bildirim başarıyla planlandı: \(identifier)")
            }
        }
    }
    
    func cancelNotification(withId id: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }
    
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func checkPendingNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            print("Bekleyen bildirimler:")
            for request in requests {
                print("ID: \(request.identifier)")
                if let trigger = request.trigger as? UNCalendarNotificationTrigger {
                    print("Tetikleme tarihi: \(trigger.nextTriggerDate() ?? Date())")
                }
            }
        }
    }
    
    func resetBadgeCount() async {
        do {
            try await UNUserNotificationCenter.current().setBadgeCount(0)
            
            // Bekleyen tüm bildirimleri güncelle
            let requests = await UNUserNotificationCenter.current().pendingNotificationRequests()
            for request in requests {
                let content = request.content.mutableCopy() as! UNMutableNotificationContent
                content.badge = nil
                
                let newRequest = UNNotificationRequest(
                    identifier: request.identifier,
                    content: content,
                    trigger: request.trigger
                )
                
                try await UNUserNotificationCenter.current().add(newRequest)
            }
            
            // Mevcut bildirimleri güncelle
            let delivered = await UNUserNotificationCenter.current().deliveredNotifications()
            for notification in delivered {
                let content = notification.request.content.mutableCopy() as! UNMutableNotificationContent
                content.badge = nil
                
                let newRequest = UNNotificationRequest(
                    identifier: notification.request.identifier,
                    content: content,
                    trigger: notification.request.trigger
                )
                
                try await UNUserNotificationCenter.current().add(newRequest)
            }
            
            print("Badge ve bildirimler başarıyla sıfırlandı")
        } catch {
            print("Badge sıfırlama hatası: \(error.localizedDescription)")
        }
    }
}

// Bildirim delegate'i
extension NotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // Uygulama açıkken bildirimleri göster ama badge'i güncelleme
        completionHandler([.banner, .sound])
        
        // Badge'i sıfırla
        Task {
            await resetBadgeCount()
        }
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let identifier = response.notification.request.identifier
        
        switch response.actionIdentifier {
        case "COMPLETE_ACTION":
            print("Anımsatıcı tamamlandı: \(identifier)")
            // TODO: Anımsatıcıyı tamamlandı olarak işaretle
            
        case "SNOOZE_ACTION":
            // 15 dakika sonraya yeni bildirim planla
            if let originalDate = (response.notification.request.trigger as? UNCalendarNotificationTrigger)?.nextTriggerDate() {
                let newDate = originalDate.addingTimeInterval(15 * 60)
                let content = response.notification.request.content
                scheduleSpecificNotification(
                    for: Reminder(title: content.title), // Geçici reminder
                    at: newDate,
                    with: content,
                    isEarly: false
                )
            }
            
        default:
            break
        }
        
        completionHandler()
    }
} 
