//
//  ImageCacheManager.swift
//  RickAndMortyCleanSwift
//
//  Created by GiN Eugene on 5/2/2025.
//

import UIKit

final class ImageCacheManager {
    static let shared = ImageCacheManager()

    private init() {}

    private func getImageFileURL(for id: Int) -> URL {
        let fileManager = FileManager.default
        let folderURLs = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        return folderURLs[0].appendingPathComponent("char_\(id).jpg")
    }

    func saveImage(_ imageData: Data, id: Int) {
        let fileURL = getImageFileURL(for: id)
        do {
            try imageData.write(to: fileURL)
        } catch {
            print("Failed to save image: \(error)")
        }
    }

    func saveImage(_ image: UIImage, id: Int) {
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            saveImage(imageData, id: id)
        }
    }

    func loadImage(id: Int) -> UIImage? {
        let fileURL = getImageFileURL(for: id)
        return UIImage(contentsOfFile: fileURL.path)
    }
}
