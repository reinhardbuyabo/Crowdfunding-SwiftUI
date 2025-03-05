import SwiftUI

struct CreateCampaignsView: View {
    @ObservedObject var viewModel: CampaignsViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var owner = ""
    @State private var title = ""
    @State private var description = ""
    @State private var startDate = Date()
    @State private var endDate = Date().addingTimeInterval(30 * 24 * 60 * 60) // 30 days from now
    @State private var goal = ""
    @State private var image: String?
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Owner Name", text: $owner)
                TextField("Campaign Title", text: $title)
                TextField("Description", text: $description)
                DatePicker("Deadline", selection: $endDate, displayedComponents: .date)
                TextField("Funding Goal", text: $goal)
                    .keyboardType(.decimalPad)
                TextField("Image URL (Optional)", text: Binding(
                    get: { image ?? "" },
                    set: { image = $0.isEmpty ? nil : $0 }
                ))
            }
            .navigationTitle("Create Campaign")
            .navigationBarItems(
                leading: Button("Cancel") { presentationMode.wrappedValue.dismiss() },
                trailing: Button("Create") {
                    guard let goalAmount = Double(goal) else { return }
                    viewModel.createCampaign(
                        owner: owner,
                        title: title,
                        description: description,
                        target: goalAmount,
                        deadline: endDate,
                        image: image
                    )
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(title.isEmpty || description.isEmpty || goal.isEmpty || owner.isEmpty)
            )
        }
    }
}

#Preview {
    CreateCampaignsView(viewModel: CampaignsViewModel())
}
