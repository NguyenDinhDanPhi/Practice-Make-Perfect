//
//  VideoManager.swift
//  UpLoad and Edit video
//
//  Created by Dan Phi on 30/7/25.
//


import UIKit
import AVFoundation
// MARK: - VideoManager
final class VideoManager {
    static let shared = VideoManager()
    private init() {}

    private let fileManager = FileManager.default
    private var documentsURL: URL {
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    func saveVideo(at sourceURL: URL) throws {
        // Bạn có thể đổi tên file thành timestamp để dễ đọc:
        let ext = sourceURL.pathExtension
        let name = "video_\(Int(Date().timeIntervalSince1970)).\(ext)"
        let dest = documentsURL.appendingPathComponent(name)
        
        if fileManager.fileExists(atPath: dest.path) {
            try fileManager.removeItem(at: dest)
        }
        try fileManager.copyItem(at: sourceURL, to: dest)
    }

    /// Trả về mảng `Video` thay vì chỉ URL
    func fetchVideos() -> [Video] {
        guard let files = try? fileManager.contentsOfDirectory(at: documentsURL,
                                                              includingPropertiesForKeys: nil,
                                                              options: []) else {
            return []
        }
        return files
            .filter { ["mov","mp4","m4v"].contains($0.pathExtension.lowercased()) }
            .map    { Video(url: $0) }
    }
}

struct Video {
    let url: URL
}

