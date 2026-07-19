//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Brandon Hill on 7/17/26.
//

import SwiftUI

struct AddressView: View {
    @Bindable var order: Order

    // Challenge 1: Clean whitespace verification using trimmingCharacters
    var isAddressInvalid: Bool {
        let trimmedName = order.name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedStreet = order.streetAddress.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedCity = order.city.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedZip = order.zip.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return trimmedName.isEmpty || trimmedStreet.isEmpty || trimmedCity.isEmpty || trimmedZip.isEmpty
    }

    var body: some View {
        Form {
            Section {
                TextField("Name", text: $order.name)
                TextField("Street Address", text: $order.streetAddress)
                TextField("City", text: $order.city)
                TextField("Zip", text: $order.zip)
            }

            Section {
                NavigationLink("Check out") {
                    CheckoutView(order: order)
                }
                .simultaneousGesture(TapGesture().onEnded {
                    // Saves data explicitly right when they navigate forward
                    order.saveAddress()
                })
            }
            .disabled(isAddressInvalid)
        }
        .navigationTitle("Delivery details")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear {
            // Backup save rule just in case they back out instead of checking out
            order.saveAddress()
        }
    }
}

#Preview {
    AddressView(order: Order())
}
