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
    static func trimVideo(
        inputURL: URL,
        outputURL: URL,
        startTime: Double,
        duration: Double,
        completion: @escaping (Bool, Error?) -> Void
    ) {
        let command = "-y -i \"\(inputURL.path)\" -ss \(startTime) -t \(duration) -c copy \"\(outputURL.path)\""

        runAsync(command: command, completion: completion)
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
    static func cropVideo(
        inputURL: URL,
        outputURL: URL,
        width: Int,
        height: Int,
        x: Int,
        y: Int,
        completion: @escaping (Bool, Error?) -> Void
    ) {
        let filter = "crop=\(width):\(height):\(x):\(y)"
        let command = """
        -y -i "\(inputURL.path)" \
        -vf "\(filter)" \
        -c:v libx264 -crf 18 -preset veryfast \
        -c:a copy "\(outputURL.path)"
        """
        runAsync(command: command, completion: completion)
    }
    
    /// Add text overlay on video.
    /// - Parameters:
    ///   - inputURL: URL of the source video.
    ///   - outputURL: URL where output video will be saved.
    ///   - text: Text to overlay.
    ///   - fontFile: Full path to a .ttf/.ttc font file.
    ///   - fontSize: Font size in points.
    ///   - fontColor: Font color (e.g. "white" or "#FF0000").
    ///   - x: X position in pixels.
    ///   - y: Y position in pixels.
    ///   - completion: Completion handler with success flag and optional error.
    static func addTextOverlay(
        inputURL: URL,
        outputURL: URL,
        text: String,
        fontFile: String,
        fontSize: Int = 24,
        fontColor: String = "white",
        x: Int = 10,
        y: Int = 10,
        completion: @escaping (Bool, Error?) -> Void
    ) {
        let drawText = """
        drawtext=fontfile='\(fontFile)':text='\(text)':\
        fontcolor=\(fontColor):fontsize=\(fontSize):x=\(x):y=\(y)
        """
        let command = """
        -y -i "\(inputURL.path)" \
        -vf "\(drawText)" \
        -c:v libx264 -crf 18 -preset veryfast \
        -c:a copy "\(outputURL.path)"
        """
        runAsync(command: command, completion: completion)
    }
    
    /// Overlay a PNG/JPEG sticker onto the video.
    /// - Parameters:
    ///   - inputURL: URL of the source video.
    ///   - stickerURL: URL of the sticker image (PNG with alpha recommended).
    ///   - outputURL: URL where output video will be saved.
    ///   - x: X position of the sticker in pixels.
    ///   - y: Y position of the sticker in pixels.
    ///   - completion: Completion handler with success flag and optional error.
    static func addStickerOverlay(
        inputURL: URL,
        stickerURL: URL,
        outputURL: URL,
        x: Int = 0,
        y: Int = 0,
        stickerWidth: Int,  
        completion: @escaping (Bool, Error?) -> Void
    ) {
        // Scale sticker to given width (auto height), then overlay
        let filter = "[1:v]scale=\(stickerWidth):-1[st];[0:v][st]overlay=\(x):\(y)"
        let command = """
        -y -i "\(inputURL.path)" \
        -i "\(stickerURL.path)" \
        -filter_complex "\(filter)" \
        -c:v libx264 -crf 18 -preset veryfast \
        -c:a copy "\(outputURL.path)"
        """
        runAsync(command: command, completion: completion)
    }

    
    /// Draw a colored box (rectangle) on the video.
    /// - Parameters:
    ///   - inputURL: URL of the source video.
    ///   - outputURL: URL where output video will be saved.
    ///   - x: X position of the top-left corner.
    ///   - y: Y position of the top-left corner.
    ///   - width: Width of the box in pixels.
    ///   - height: Height of the box in pixels.
    ///   - color: Box color (e.g. "red@0.5" for semi-transparent red).
    ///   - thickness: Line thickness in pixels (0 for filled).
    ///   - completion: Completion handler with success flag and optional error.
    static func drawBoxOverlay(
        inputURL: URL,
        outputURL: URL,
        x: Int,
        y: Int,
        width: Int,
        height: Int,
        color: String = "red@0.5",
        thickness: Int = 5,
        completion: @escaping (Bool, Error?) -> Void
    ) {
        let drawBox = "drawbox=x=\(x):y=\(y):w=\(width):h=\(height):color=\(color):t=\(thickness)"
        let command = """
        -y -i "\(inputURL.path)" \
        -vf "\(drawBox)" \
        -c:v libx264 -crf 18 -preset veryfast \
        -c:a copy "\(outputURL.path)"
        """
        runAsync(command: command, completion: completion)
    }
    
    // MARK: - Private
    
    /// Helper to run an FFmpegKit async command and map the return code.
    private static func runAsync(
        command: String,
        completion: @escaping (Bool, Error?) -> Void
    ) {
        FFmpegKit.executeAsync(command) { session in
            let code = session?.getReturnCode()
            DispatchQueue.main.async {
                if code?.isValueSuccess() == true {
                    completion(true, nil)
                } else {
                    let err = session?.getFailStackTrace() ?? "Unknown error"
                    completion(false, NSError(
                        domain: "FFmpegKit",
                        code: Int(code?.getValue() ?? -1),
                        userInfo: [NSLocalizedDescriptionKey: err]
                    ))
                }
            }
        }
    }
}
