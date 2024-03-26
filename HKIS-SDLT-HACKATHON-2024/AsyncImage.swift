//
//  AsyncImage.swift
//  HKIS-SDLT-HACKATHON-2024
//
//  Created by Micah Chen on 3/20/24.
//

import SwiftUI

struct AsyncImage: View {
    @StateObject private var loader: ImageLoader

    var placeholder: Image

    init(url: String, placeholder: Image = Image(systemName: "photo")) {
        _loader = StateObject(wrappedValue: ImageLoader(url: url))
        self.placeholder = placeholder
    }

    var body: some View {
        image
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 200, height: 200)
            .clipped()
    }

    private var image: Image {
        if let image = loader.image {
            return Image(uiImage: image)
        } else {
            return placeholder
        }
    }
}

class ImageLoader: ObservableObject {
    @Published var image: UIImage?

    init(url: String) {
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }.resume()
    }
}
