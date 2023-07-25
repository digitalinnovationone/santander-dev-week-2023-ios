//
//  SVGProcessor.swift
//  Santander
//
//  Created by Robson Moreira on 24/07/23.
//

import SwiftUI
import Combine
import PocketSVG
import Kingfisher

struct AsyncImage<Content>: View where Content: View {
    
    @StateObject fileprivate var loader: ImageLoader
    
    @ViewBuilder private var content: (AsyncImagePhase) -> Content
    
    init(from url: URL?, frame: CGSize = .zero, @ViewBuilder content: @escaping (AsyncImagePhase) -> Content) {
        _loader = .init(wrappedValue: ImageLoader(url: url, frame: frame))
        self.content = content
    }
    
    var body: some View {
        content(loader.phase).task {
            loader.load()
        }
    }
}

enum AsyncImagePhase {
    case empty
    case success(Image)
    case failure(Error)
}

fileprivate class ImageLoader: ObservableObject {
    
    private enum LoaderError: Swift.Error {
        case missingURL
        case failedToDecodeFromData
    }
    
    private var url: URL?
    private var frame = CGSize.zero
    
    @Published var phase = AsyncImagePhase.empty
    
    init(url: URL?, frame: CGSize = .zero) {
        self.url = url
        self.frame = frame
    }
    
    func load() {
        guard let url = url else {
            phase = .failure(LoaderError.missingURL)
            return
        }
        
        let processor = SVGProcessor(size: frame)
        KingfisherManager.shared.retrieveImage(with: url, options: [.processor(processor), .forceRefresh]) { [weak self] result in
            switch (result){
            case .success(let value):
                self?.phase = .success(Image(uiImage: value.image))
            case .failure(let error):
                self?.phase = .failure(error)
            }
        }
    }
}

fileprivate struct SVGProcessor: ImageProcessor {
    
    let identifier = "svgprocessor"
    var size: CGSize = CGSize(width: 0, height: 0)
    
    init(size: CGSize) {
        self.size = size
    }
    
    func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> UIImage? {
        switch item {
        case .image(let image):
            return image
        case .data(let data):
            if let svgString = String(data: data, encoding: .utf8){
                let path = SVGBezierPath.paths(fromSVGString: svgString)
                let layer = SVGLayer()
                layer.paths = path
                let frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
                layer.frame = frame
                let img = self.snapshotImage(for: layer)
                return img
            }
            return nil
        }
    }
    
    func snapshotImage(for view: CALayer) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        view.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
