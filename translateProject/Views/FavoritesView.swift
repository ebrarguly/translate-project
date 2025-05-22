import SwiftUI

struct FavoritesView: View {
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""
    @State private var translations: [TranslationHistory] = []
    
    var filteredTranslations: [TranslationHistory] {
        if searchText.isEmpty {
            return translations.filter { $0.isFavorite }
        } else {
            return translations.filter { translation in
                translation.isFavorite &&
                (translation.sourceText.localizedCaseInsensitiveContains(searchText) ||
                 translation.translatedText.localizedCaseInsensitiveContains(searchText))
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.background.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Üst başlık
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark")
                                .foregroundColor(Color.theme.textPrimary)
                                .font(.title2)
                        }
                        
                        Spacer()
                        
                        Text("Favoriler")
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
                        
                        if filteredTranslations.isEmpty {
                            VStack(spacing: 16) {
                                Image(systemName: "star.slash")
                                    .font(.system(size: 50))
                                    .foregroundColor(Color.theme.textSecondary)
                                
                                Text("Henüz favori çeviriniz yok")
                                    .font(.headline)
                                    .foregroundColor(Color.theme.textSecondary)
                                
                                Text("Çevirilerinizi favorilere ekleyerek daha sonra kolayca erişebilirsiniz")
                                    .font(.subheadline)
                                    .foregroundColor(Color.theme.textSecondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                            }
                            .padding(.top, 100)
                        } else {
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
            }
        }
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
                    isFavorite: true
                )
            ]
        }
    }
}
