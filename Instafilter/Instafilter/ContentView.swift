//
//  ContentView.swift
//  Instafilter
//
//  Created by Brandon Hill on 7/30/26.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct ContentView: View {
    @State private var image: Image?

    var body: some View {
        VStack {
            if let image {
                image
                    .resizable()
                    .scaledToFit()
            } else {
                ContentUnavailableView {
                    Label("No image", systemImage: "photo")
                } description: {
                    Text("There isn't an image available to process.")
                } actions: {
                    Button("Load Image") {
                        loadImage()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
        .onAppear(perform: loadImage)
    }

    func loadImage() {
        let inputImage = UIImage(named: "Example") ?? UIImage(systemName: "photo")!
        let beginImage = CIImage(image: inputImage)

        let context = CIContext()
        let currentFilter = CIFilter.twirlDistortion()
        currentFilter.inputImage = beginImage

        let amount = 1.0
        let inputKeys = currentFilter.inputKeys

        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(amount, forKey: kCIInputIntensityKey)
        }

        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(amount * 200, forKey: kCIInputRadiusKey)
        }

        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(amount * 10, forKey: kCIInputScaleKey)
        }

        // get a CIImage from our filter or exit if that fails
        guard let outputImage = currentFilter.outputImage else { return }

        // attempt to get a CGImage from our CIImage
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }

        // convert that to a UIImage
        let uiImage = UIImage(cgImage: cgImage)

        // and convert that to a SwiftUI image
        image = Image(uiImage: uiImage)
    }
}

#Preview {
    ContentView()
}
