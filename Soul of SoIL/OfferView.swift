import SwiftUI

struct OfferView: View {
    let offer: Offer
    let providerName: String
    let providerContact: String?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Offer Title
                Text(offer.title)
                    .font(.largeTitle)
                    .padding(.top)
                
                // Offer Type
                Text("Type: \(offer.type)")
                    .font(.title2)
                    .foregroundColor(.gray)
                
                // Provider Information
                VStack(alignment: .leading, spacing: 10) {
                    Text("Provided by:")
                        .font(.headline)
                    Text(providerName)
                        .font(.body)
                    
                    if let contact = providerContact {
                        Text("Contact: \(contact)")
                            .font(.body)
                            .foregroundColor(.blue)
                            .onTapGesture {
                                if let url = URL(string: "tel://\(contact)"), UIApplication.shared.canOpenURL(url) {
                                    UIApplication.shared.open(url)
                                }
                            }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                
                // Description
                VStack(alignment: .leading, spacing: 10) {
                    Text("Description:")
                        .font(.headline)
                    Text(offer.description)
                        .font(.body)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Offer Details")
    }
} 