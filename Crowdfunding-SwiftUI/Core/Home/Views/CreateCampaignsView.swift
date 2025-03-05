import SwiftUI

struct CreateCampaignView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel: CampaignsViewModel
    
    @State private var owner = ""
    @State private var title = ""
    @State private var description = ""
    @State private var target: Double = 0.0
    @State private var deadline = Date()
    @State private var image: String = ""
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    init(viewModel: CampaignsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Campaign Details")) {
                    TextField("Owner", text: $owner)
                    TextField("Title", text: $title)
                    TextField("Description", text: $description)
                    
                    HStack {
                        Text("Target Amount")
                        TextField("Amount", value: $target, format: .number)
                            .keyboardType(.decimalPad)
                    }
                    
                    DatePicker("Deadline", selection: $deadline, displayedComponents: .date)
                    
                    TextField("Image URL (Optional)", text: $image)
                }
                
                Section {
                    Button(action: createCampaign) {
                        Text("Create Campaign")
                            .frame(maxWidth: .infinity)
                    }
                    .disabled(!isFormValid)
                }
            }
            .navigationTitle("Create Campaign")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("Campaign Creation"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    private var isFormValid: Bool {
        !owner.isEmpty && !title.isEmpty && !description.isEmpty && target > 0
    }
    
    private func createCampaign() {
        viewModel.createCampaign(
            owner: owner,
            title: title,
            description: description,
            target: target,
            deadline: deadline,
            image: image.isEmpty ? nil : image
        )
        
        // Show success alert and dismiss view
        alertMessage = "Campaign created successfully!"
        showingAlert = true
        presentationMode.wrappedValue.dismiss()
    }
}

// Preview for development
struct CreateCampaignView_Previews: PreviewProvider {
    static var previews: some View {
        CreateCampaignView(viewModel: CampaignsViewModel())
    }
}
