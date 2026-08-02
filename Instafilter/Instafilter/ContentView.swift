//
//  ContentView.swift
//  Instafilter
//
//  Created by Brandon Hill on 7/30/26.
//

import PhotosUI
import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct ContentView: View {
    @State private var processedImage: Image?
    @State private var filterIntensity = 0.5
    @State private var selectedItem: PhotosPickerItem?
    @State private var currentFilter = CIFilter.sepiaTone()
    let context = CIContext()
    
    func changeFilter() {
        
    }
    func applyProcessing() {
        currentFilter.intensity = Float(filterIntensity)

        guard let outputImage = currentFilter.outputImage else { return }
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }

        let uiImage = UIImage(cgImage: cgImage)
        processedImage = Image(uiImage: uiImage)
    }
    func loadImage() {
        Task {
            guard let imageData = try await selectedItem?.loadTransferable(type: Data.self) else { return }
            guard let inputImage = UIImage(data: imageData) else { return }

            let beginImage = CIImage(image: inputImage)
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            applyProcessing()
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                PhotosPicker(selection: $selectedItem) {
                    if let processedImage {
                        processedImage
                            .resizable()
                            .scaledToFit()
                    } else {
                        ContentUnavailableView("No Picture", systemImage: "photo.badge.plus", description: Text("Import a photo to get started"))
                    }
                }
                    Spacer()
                    
                    HStack {
                        Text("Intensity")
                        Slider(value: $filterIntensity)
                    }
                    .padding(.vertical)
                    
                    HStack {
                        Button("Change Filter", action: changeFilter)
                        // change filter
                    }
                    
                    Spacer()
                    
                    // share the picture
                    Slider(value: $filterIntensity)
                        .onChange(of: filterIntensity, applyProcessing)
            }
            .onChange(of: selectedItem, loadImage)
            .padding([.horizontal, .bottom])
            .navigationTitle("Instafilter")
        }
    }
}

#Preview {
    ContentView()
}
