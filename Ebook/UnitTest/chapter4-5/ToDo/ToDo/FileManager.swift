//
//  FileManager.swift
//  ToDo
//
//  Created by dan phi on 11/5/25.
//
import Foundation

extension FileManager {
    func documentsURL(name: String) -> URL {
        guard let documentsURL = urls(for:
                .documentDirectory,
                                      in: .userDomainMask).first else {
            fatalError()
        }
        return documentsURL.appendingPathComponent(name)
    }
}
