import SwiftUI

struct TranslationHistory: Identifiable {
    let id = UUID()
    let sourceText: String
    let translatedText: String
    let sourceLanguage: String
    let targetLanguage: String
    let date: Date
    var isFavorite: Bool
}

private struct TranslationsKey: EnvironmentKey {
    static let defaultValue: [TranslationHistory] = []
}

extension EnvironmentValues {
    var translations: [TranslationHistory] {
        get { self[TranslationsKey.self] }
        set { self[TranslationsKey.self] = newValue }
    }
}

struct HistoryView: View {
    @State private var searchText = ""
    @State private var translations: [TranslationHistory] = []
    
    var filteredTranslations: [TranslationHistory] {
        if searchText.isEmpty {
            return translations
        } else {
            return translations.filter { translation in
                translation.sourceText.localizedCaseInsensitiveContains(searchText) ||
                translation.translatedText.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        ZStack {
            Color.theme.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Üst başlık
                HStack {
                    NavigationLink(destination: TranslationView()) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color.theme.textPrimary)
                            .font(.title2)
                    }
                    
                    Text("Çeviri Geçmişi")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.theme.textPrimary)
                    Spacer()
                }
                .padding()
                .background(Color.theme.surface)
                
                // Arama ve liste
                VStack(spacing: 20) {
                    SearchBar(text: $searchText)
                        .padding(.horizontal)
                        .padding(.top, 20)
                    
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredTranslations) { translation in
                                TranslationHistoryRow(translation: translation)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            // Örnek veriler
            translations = [
                TranslationHistory(
                    sourceText: "Hello, how are you?",
                    translatedText: "Merhaba, nasılsınız?",
                    sourceLanguage: "İngilizce",
                    targetLanguage: "Türkçe",
                    date: Date(),
                    isFavorite: true
                ),
                TranslationHistory(
                    sourceText: "Bu bir test çevirisidir",
                    translatedText: "This is a test translation",
                    sourceLanguage: "Türkçe",
                    targetLanguage: "İngilizce",
                    date: Date().addingTimeInterval(-86400),
                    isFavorite: false
                )
            ]
        }
    }
    
    private func deleteTranslation(at offsets: IndexSet) {
        // Burada gerçek uygulamada veritabanı güncellemesi yapılacak
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color.theme.textSecondary)
            
            TextField("Çeviri ara...", text: $text)
                .foregroundColor(Color.theme.textPrimary)
                .font(.system(size: 16, weight: .medium))
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color.theme.textSecondary)
                }
            }
        }
        .padding(12)
        .background(Color.theme.surface)
        .cornerRadius(15)
    }
}

struct TranslationHistoryRow: View {
    let translation: TranslationHistory
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(translation.sourceText)
                    .font(.headline)
                    .foregroundColor(Color.theme.textPrimary)
                Spacer()
                Text(translation.date, style: .date)
                    .font(.caption)
                    .foregroundColor(Color.theme.textSecondary)
            }
            
            Text(translation.translatedText)
                .font(.subheadline)
                .foregroundColor(Color.theme.textSecondary)
            
            HStack {
                Text("\(translation.sourceLanguage) → \(translation.targetLanguage)")
                    .font(.caption)
                    .foregroundColor(Color.theme.primary)
                
                Spacer()
                
                Button(action: {
                    // Favori işlemi
                }) {
                    Image(systemName: translation.isFavorite ? "star.fill" : "star")
                        .foregroundColor(Color.theme.accent)
                }
            }
        }
        .padding()
        .background(Color.theme.surface)
        .cornerRadius(12)
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HistoryView()
        }
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

