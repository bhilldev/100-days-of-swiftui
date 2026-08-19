//
//  ContentView.swift
//  NamesToFacesApp
//
//  Created by Brandon Hill on 8/19/26.
//

import SwiftUI
import PhotosUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    // Automatically fetches contacts sorted alphabetically
    @Query(sort: \Person.name) private var people: [Person]

    // State management for picker and naming modal
    @State private var selectedItem: PhotosPickerItem?
    @State private var tempImageData: Data?
    @State private var photoName = ""
    @State private var showNamePrompt = false

    var body: some View {
        NavigationStack {
            List(people) { person in
                NavigationLink(destination: DetailView(person: person)) {
                    HStack(spacing: 15) {
                        // Display saved image if present
                        if let data = person.photoData, let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                        } else {
                            // Fallback icon if no image exists
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.gray)
                        }
                        
                        Text(person.name)
                            .font(.headline)
                    }
                }
            }
            .navigationTitle("Remember Them")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        Image(systemName: "plus")
                    }
                }
            }
            // Trigger image load when user picks a photo
            .onChange(of: selectedItem) { _, newItem in
                Task {
                    do {
                        if let data = try await newItem?.loadTransferable(type: Data.self) {
                            await MainActor.run {
                                self.tempImageData = data
                                self.showNamePrompt = true
                                print("Successfully loaded image data (\(data.count) bytes)")
                            }
                        } else {
                            print("Error: loadTransferable returned nil")
                        }
                    } catch {
                        print("Failed to load photo: \(error.localizedDescription)")
                    }
                }
            }
            // Naming prompt modal sheet
            .sheet(isPresented: $showNamePrompt) {
                NavigationStack {
                    Form {
                        if let tempImageData, let uiImage = UIImage(data: tempImageData) {
                            Section("Selected Photo") {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxHeight: 200)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        
                        Section("Contact Info") {
                            TextField("Name", text: $photoName)
                        }
                    }
                    .navigationTitle("Add Person")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                resetState()
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Save") {
                                savePerson()
                            }
                            .disabled(photoName.trimmingCharacters(in: .whitespaces).isEmpty)
                        }
                    }
                }
            }
        }
    }

    private func savePerson() {
        guard let tempImageData else {
            print("Error: Attempted to save with no image data")
            return
        }
        
        let newPerson = Person(name: photoName, photoData: tempImageData)
        modelContext.insert(newPerson)
        print("Saved \(photoName) to SwiftData")

        resetState()
    }
    
    private func resetState() {
        selectedItem = nil
        tempImageData = nil
        photoName = ""
        showNamePrompt = false
    }
}
#Preview {
    ContentView()
}
