//
//  VideoManager.swift
//  UpLoad and Edit video
//
//  Created by Dan Phi on 30/7/25.
//


import UIKit

// MARK: - VideoManager
final class VideoManager {
    static let shared = VideoManager()
    private init() {}

    private let fileManager = FileManager.default
    private var documentsURL: URL {
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    // Save picked video to documents directory
    func saveVideo(at sourceURL: URL) throws {
        let destinationURL = documentsURL.appendingPathComponent(sourceURL.lastPathComponent)
        if fileManager.fileExists(atPath: destinationURL.path) {
            try fileManager.removeItem(at: destinationURL)
        }
        try fileManager.copyItem(at: sourceURL, to: destinationURL)
    }

    // List saved videos
    func fetchVideos() -> [URL] {
        guard let files = try? fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options: []) else {
            return []
        }
        return files.filter { ["mov", "mp4", "m4v"].contains($0.pathExtension.lowercased()) }
    }
}
