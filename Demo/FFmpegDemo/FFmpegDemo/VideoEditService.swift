//
//  VideoEditService.swift
//  FFmpegDemo
//
//  Created by Dan Phi on 6/8/25.
//

import Foundation
import ffmpegkit

/// A simple video editing service using FFmpegKit.
final class VideoEditService {
    
    /// Trim a video to specified start time and duration.
    /// - Parameters:
    ///   - inputURL: URL of the source video.
    ///   - outputURL: URL where trimmed video will be saved.
    ///   - startTime: Start time in seconds.
    ///   - duration: Duration in seconds.
    ///   - completion: Completion handler with success flag and optional error.
    static func trimVideo(inputURL: URL, outputURL: URL, startTime: Double, duration: Double, completion: @escaping (Bool, Error?) -> Void) {
        let command = "-y -i \"\(inputURL.path)\" -ss \(startTime) -t \(duration) -c copy \"\(outputURL.path)\""
        FFmpegKit.executeAsync(command) { session in
            let returnCode = session?.getReturnCode()
            if returnCode?.isValueSuccess() == true {
                completion(true, nil)
            } else {
                let err = session?.getFailStackTrace() ?? "Unknown error"
                completion(false, NSError(domain: "FFmpegKit", code: Int(returnCode?.getValue() ?? -1), userInfo: [NSLocalizedDescriptionKey: err]))
            }
        }
    }
    
    /// Crop a video to specified rectangle.
    /// - Parameters:
    ///   - inputURL: URL of the source video.
    ///   - outputURL: URL where cropped video will be saved.
    ///   - width: Crop width in pixels.
    ///   - height: Crop height in pixels.
    ///   - x: X offset from left.
    ///   - y: Y offset from top.
    ///   - completion: Completion handler with success flag and optional error.
    static func cropVideo(inputURL: URL, outputURL: URL, width: Int, height: Int, x: Int, y: Int, completion: @escaping (Bool, Error?) -> Void) {
            let filter = "crop=\(width):\(height):\(x):\(y)"
            let command = "-y -i \"\(inputURL.path)\" -vf \"\(filter)\" -c:a copy \"\(outputURL.path)\""
            FFmpegKit.executeAsync(command) { session in
                let code = session?.getReturnCode()
                if code?.isValueSuccess() == true {
                    completion(true, nil)
                } else {
                    let err = session?.getFailStackTrace() ?? "Unknown error"
                    completion(false, NSError(domain: "FFmpegKit", code: Int(code?.getValue() ?? -1), userInfo: [NSLocalizedDescriptionKey: err]))
                }
            }
        }

    /// Add text overlay on video.
    /// - Parameters:
    ///   - inputURL: URL of the source video.
    ///   - outputURL: URL where output video will be saved.
    ///   - text: Text to overlay.
    ///   - fontSize: Font size.
    ///   - fontColor: Color in hex, e.g. white.
    ///   - x: X position.
    ///   - y: Y position.
    ///   - completion: Completion handler with success flag and optional error.
    static func addTextOverlay(inputURL: URL, outputURL: URL, text: String, fontFile: String, fontSize: Int = 24, fontColor: String = "red", x: Int = 10, y: Int = 10, completion: @escaping (Bool, Error?) -> Void) {
            // Example fontFile: "/System/Library/Fonts/Helvetica.ttc"
            let drawText = "drawtext=fontfile='\(fontFile)':text='\(text)':fontcolor=\(fontColor):fontsize=\(fontSize):x=\(x):y=\(y)"
            let command = "-y -i \"\(inputURL.path)\" -vf \"\(drawText)\" -codec:a copy \"\(outputURL.path)\""
            FFmpegKit.executeAsync(command) { session in
                let code = session?.getReturnCode()
                if code?.isValueSuccess() == true {
                    completion(true, nil)
                } else {
                    let err = session?.getFailStackTrace() ?? "Unknown error"
                    completion(false, NSError(domain: "FFmpegKit", code: Int(code?.getValue() ?? -1), userInfo: [NSLocalizedDescriptionKey: err]))
                }
            }
        }
}

// Example usage:
// let input = URL(fileURLWithPath: "/path/to/input.mp4")
// let outputTrim = URL(fileURLWithPath: "/path/to/trimmed.mp4")
// VideoEditService.trimVideo(inputURL: input, outputURL: outputTrim, startTime: 5, duration: 10) { success, error in
//     if success { print("Trim completed") } else { print("Trim failed: \(error?.localizedDescription ?? "")") }
// }
