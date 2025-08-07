//
//  ColorMixerFilter.swift
//  FFmpegDemo
//
//  Created by Dan Phi on 7/8/25.
//


enum ColorMixerFilter: String {
    /// Sepia
    case sepia     = "colorchannelmixer=.393:.769:.189:0:.349:.686:.168:0:.272:.534:.131:0:0:0:0:1"
    /// Grayscale (B&W)
    case grayscale = "colorchannelmixer=.333:.333:.333:0:.333:.333:.333:0:.333:.333:.333:0:0:0:0:1"
    /// Cool tone (bluish)
    case coolTone  = "colorchannelmixer=.8:.2:0:0:.2:.8:0:0:0:.2:.8:0:0:0:0:1"
    /// Warm tone (reddish)
    case warmTone  = "colorchannelmixer=1.2:0:0:0:0:1:0:0:0:0:1.2:0:0:0:0:1"
    /// Vintage (light sepia)
    case vintage   = "colorchannelmixer=.9:.5:.1:0:.3:.9:.1:0:.2:.3:.8:0:0:0:0:1"
}
