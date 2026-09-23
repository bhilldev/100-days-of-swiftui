//
//  ResortDetails.swift
//  SnowSeeker
//
//  Created by Brandon Hill on 9/23/26.
//

import SwiftUI

struct ResortDetailsView: View {
    let resort: Resort
    
    var price: String {
        String(repeating: "$", count: resort.price)
    }
    
    var size: String {
        switch resort.size {
        case 1: "Small"
        case 2: "Average"
        default: "Large"
        }
    }
    
    var body: some View {
        Group {
            VStack {
                Text("Size")
                    .font(.caption.bold())
                Text(size)
                    .font(.title3)
            }

            VStack {
                Text("Price")
                    .font(.caption.bold())
                Text(price)
                    .font(.title3)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ResortDetailsView(resort: .example)
}
