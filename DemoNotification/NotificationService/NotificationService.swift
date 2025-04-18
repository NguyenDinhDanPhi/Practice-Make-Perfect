import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest,
                             withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)

        guard let bestAttemptContent = bestAttemptContent else {
            contentHandler(request.content)
            return
        }

        // Lấy image URL từ payload
        if let fcmOptions = request.content.userInfo["fcm_options"] as? [String: Any],
           let imageURLString = fcmOptions["image"] as? String,
           let imageURL = URL(string: imageURLString) {
            downloadImage(from: imageURL) { attachment in
                if let attachment = attachment {
                    bestAttemptContent.attachments = [attachment]
                }
                // Gửi nội dung noti sau khi thêm ảnh
                contentHandler(bestAttemptContent)
            }
        } else {
            // Không có ảnh → gửi noti như cũ
            contentHandler(bestAttemptContent)
        }
    }

    override func serviceExtensionTimeWillExpire() {
        if let contentHandler = contentHandler, let bestAttemptContent = bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

    // MARK: - Tải ảnh và tạo attachment
    private func downloadImage(from url: URL, completion: @escaping (UNNotificationAttachment?) -> Void) {
        URLSession.shared.downloadTask(with: url) { (downloadedUrl, response, error) in
            guard let downloadedUrl = downloadedUrl else {
                completion(nil)
                return
            }

            // Tạo đường dẫn tạm thời với phần mở rộng phù hợp
            let tmpDirectory = URL(fileURLWithPath: NSTemporaryDirectory())
            let uniqueURL = tmpDirectory.appendingPathComponent(UUID().uuidString + ".jpg")

            try? FileManager.default.moveItem(at: downloadedUrl, to: uniqueURL)

            do {
                let attachment = try UNNotificationAttachment(identifier: "image", url: uniqueURL, options: nil)
                completion(attachment)
            } catch {
                completion(nil)
            }
        }.resume()
    }
}
