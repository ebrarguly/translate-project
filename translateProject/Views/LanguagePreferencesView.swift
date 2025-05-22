import SwiftUI

struct LanguagePreferencesView: View {
    @State private var searchText = ""
    @State private var selectedLanguages: Set<Language> = []
    @State private var navigateToTranslation = false
    
    var filteredLanguages: [Language] {
        if searchText.isEmpty {
            return Language.availableLanguages
        }
        return Language.availableLanguages.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Tercih Ettiğiniz Dilleri Seçin")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 20)
                
                Text("En az 2 dil seçmelisiniz")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                // Arama çubuğu
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Dil ara...", text: $searchText)
                        .foregroundColor(.white)
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal)
                
                // Seçili diller
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(Array(selectedLanguages)) { language in
                            HStack {
                                Text(language.flag)
                                Text(language.name)
                                    .foregroundColor(.white)
                                Button(action: {
                                    selectedLanguages.remove(language)
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(20)
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Dil listesi
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(filteredLanguages) { language in
                            Button(action: {
                                if selectedLanguages.contains(language) {
                                    selectedLanguages.remove(language)
                                } else {
                                    selectedLanguages.insert(language)
                                }
                            }) {
                                HStack {
                                    Text(language.flag)
                                        .font(.title2)
                                    Text(language.name)
                                        .foregroundColor(.white)
                                    Spacer()
                                    if selectedLanguages.contains(language) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.red)
                                    }
                                }
                                .padding()
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(12)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Devam et butonu
                Button(action: {
                    saveSelectedLanguages()
                    navigateToTranslation = true
                }) {
                    Text("Devam Et")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(selectedLanguages.count >= 2 ? Color.red : Color.gray)
                        .cornerRadius(12)
                }
                .padding()
                .disabled(selectedLanguages.count < 2)
            }
        }
        .fullScreenCover(isPresented: $navigateToTranslation) {
            TranslationView()
        }
    }
    
    private func saveSelectedLanguages() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(Array(selectedLanguages)) {
            UserDefaults.standard.set(encoded, forKey: "selectedLanguages")
        }
    }
}
