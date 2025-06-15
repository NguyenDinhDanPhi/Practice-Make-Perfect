import UIKit

protocol CompressionStrategy {
    func compressFile(filePaths: [String])
}

struct ZipCompressionStrategy: CompressionStrategy {
    func compressFile(filePaths: [String]) {
        print("Using Zip")
    }
}
struct RarCompressionStrategy: CompressionStrategy {
    func compressFile(filePaths: [String]) {
        print("Using Rar")
    }
}

struct CompressContent {
    var strategy: CompressionStrategy
    func compressFiles(filePaths: [String]) {
        self.strategy.compressFile(filePaths: filePaths)
    }
}
var filePaths = ["file1.txt", "file2.txt"]
var zip = ZipCompressionStrategy()
var rar = RarCompressionStrategy()
var compress = CompressContent(strategy: zip)
compress.compressFiles(filePaths: filePaths)
//using zip
compress.strategy = rar
compress.compressFiles(filePaths: filePaths)
// using rar
