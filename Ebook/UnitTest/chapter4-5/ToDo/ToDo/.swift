import Foundation

extension FileManager {
    func documentsURL(name: String) -> URL {
        guard let documentsURL = self.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Could not find Documents directory")
        }
        return documentsURL.appendingPathComponent(name)
    }
}
