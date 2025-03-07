// Profile View (Hardcoded Ada Lovelace's Profile)

import SwiftUI

// Profile View (Improved UI with more details)
struct ProfileView: View {
    @State private var isLoggedIn = true
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.gray)
            
            Text("Ada Lovelace")
                .font(.title)
                .bold()
            
            Text("Mathematician, writer, and first computer programmer.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Divider()
            
            List {
                HStack {
                    Image(systemName: "envelope.fill")
                        .foregroundColor(.blue)
                    Text("ada.lovelace@example.com")
                }
                
                HStack {
                    Image(systemName: "location.fill")
                        .foregroundColor(.red)
                    Text("London, UK")
                }
            }
            .frame(height: 120)
            
            Spacer()
            Button(action: {
                        isLoggedIn = false
                    }) {
                        Text("Log Out")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                    .padding()
        }
        .padding()
        .navigationTitle("Profile")
    }
}
