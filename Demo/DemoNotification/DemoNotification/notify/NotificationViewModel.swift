//
//  NotificationViewModel.swift
//  DemoNotification
//
//  Created by dan phi on 13/4/25.
//

import Foundation
import Combine
class NotificationViewModel {
    @Published var inboxNotices: InboxNoticesResponse?
    private var cancellables = Set<AnyCancellable>()

    func loadNotificationListFromFile() {
            guard let filePath = Bundle.main.path(forResource: "mockup_noti_SAMPLE", ofType: "json") else {
                print("❌ Không tìm thấy file trong bundle")
                return
            }

            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: filePath))
                let decoder = JSONDecoder()
                let result = try decoder.decode(InboxNoticesResponse.self, from: data)

                self.inboxNotices = result
                print("✅ Load thành công \(result.data.count) thông báo")
            } catch {
                print("❌ Decode lỗi:", error)
            }
        }
}
