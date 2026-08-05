//
//  ContentView.swift
//  BucketList
//
//  Created by Brandon Hill on 8/5/26.
//

import SwiftUI

enum LoadingState {
    case loading, success, failed
}

struct LoadingView: View {
    @State private var loadingState = LoadingState.loading
    
    var body: some View {
        Text("Loading...")
        switch loadingState {
        case .loading:
            LoadingView()
        case .success:
            SuccessView()
        case .failed:
            FailedView()
        }
    }
}

struct SuccessView: View {
    var body: some View {
        Text("Success!")
    }
}

struct FailedView: View {
    var body: some View {
        Text("Failed.")
    }
}
#Preview {
    LoadingView()
}
