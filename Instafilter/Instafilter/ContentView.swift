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
import StoreKit

struct ContentView: View {
    @State private var processedImage: Image?
    @State private var filterIntensity = 0.5
    @State private var selectedItem: PhotosPickerItem?
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    @State private var showingFilters = false
    @State private var filterRadius = 100.0
    @State private var filterAngle = 0.0
    
    
    @AppStorage("filterCount") var filterCount = 0
    @Environment(\.requestReview) var requestReview
    
    let context = CIContext()
    
    func changeFilter() {
        showingFilters = true
    }
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys

        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(filterIntensity * 10, forKey: kCIInputScaleKey) }
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(
                filterRadius,
                forKey: kCIInputRadiusKey
            )
        }
        if inputKeys.contains(kCIInputAngleKey) {
            currentFilter.setValue(filterAngle, forKey: kCIInputAngleKey)
        }
        
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
    
    @MainActor func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()
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
                if processedImage != nil {
                    if currentFilter.inputKeys.contains(kCIInputIntensityKey) {
                        HStack {
                            Text("Intensity")
                            Slider(
                                value: $filterIntensity,
                                in: 0...1,
                                onEditingChanged: { editing in
                                    if !editing {
                                        applyProcessing()
                                    }
                                }
                            )
                        }
                    }

                    if currentFilter.inputKeys.contains(kCIInputRadiusKey) {
                        HStack {
                            Text("Radius")
                            Slider(
                                value: $filterRadius,
                                in: 0...100,
                                onEditingChanged: { editing in
                                    if !editing {
                                        applyProcessing()
                                    }
                                }
                            )
                        }
                    }

                    if currentFilter.inputKeys.contains(kCIInputAngleKey) {
                        HStack {
                            Text("Angle")
                            Slider(
                                value: $filterAngle,
                                in: -Double.pi...Double.pi,
                                onEditingChanged: { editing in
                                    if !editing {
                                        applyProcessing()
                                    }
                                }
                            )
                        }
                    }

                    HStack {
                        Button("Change Filter", action: changeFilter)
                        // change filter
                    }
                    
                    Spacer()
                    
                    if let processedImage {
                        ShareLink(item: processedImage, preview: SharePreview("Instafilter image", image: processedImage))
                    }
                }
                    
            }
            .onChange(of: selectedItem, loadImage)
            .padding([.horizontal, .bottom])
            .navigationTitle("Instafilter")
            .confirmationDialog("Select a filter", isPresented: $showingFilters) {
                Button("Crystallize") { setFilter(CIFilter.crystallize()) }
                Button("Edges") { setFilter(CIFilter.edges()) }
                Button("Gaussian Blur") { setFilter(CIFilter.gaussianBlur()) }
                Button("Pixellate") { setFilter(CIFilter.pixellate()) }
                Button("Sepia Tone") { setFilter(CIFilter.sepiaTone()) }
                Button("Unsharp Mask") { setFilter(CIFilter.unsharpMask()) }
                Button("Vignette") { setFilter(CIFilter.vignette()) }
                
                Button("Bloom") {
                    setFilter(CIFilter.bloom())
                }
                Button("Motion Blur") {
                    setFilter(CIFilter.motionBlur())
                }
                Button("Hue Adjust") {
                    setFilter(CIFilter.hueAdjust())
                }
                
                
                Button("Cancel", role: .cancel) { }
            }
        }
    }
}

#Preview {
    ContentView()
}
