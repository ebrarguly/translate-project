import SwiftUI

struct LanguagePickerView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedLanguage: Language?
    let languages: [Language]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.background.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Text("Dil Seçin")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.theme.textPrimary)
                        
                        Spacer()
                        
                        Button("Kapat") {
                            dismiss()
                        }
                        .foregroundColor(Color.theme.primary)
                    }
                    .padding()
                    .background(Color.theme.surface)
                    
                    // Language List
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(languages) { language in
                                Button(action: {
                                    selectedLanguage = language
                                    dismiss()
                                }) {
                                    HStack(spacing: 16) {
                                        Text(language.flag)
                                            .font(.title2)
                                        
                                        Text(language.name)
                                            .foregroundColor(Color.theme.textPrimary)
                                        
                                        Spacer()
                                        
                                        if selectedLanguage?.id == language.id {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(Color.theme.primary)
                                        }
                                    }
                                    .padding(.horizontal)
                                    .frame(height: 56)
                                }
                                
                                Divider()
                                    .background(Color.theme.surface)
                            }
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}
