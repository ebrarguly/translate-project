import SwiftUI

struct HelpSupportView: View {
    @Environment(\.dismiss) var dismiss
    
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
                        
                        Text("Yardım ve Destek")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.theme.textPrimary)
                        
                        Spacer()
                    }
                    .padding()
                    .background(Color.theme.surface)
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            // SSS Bölümü
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Sıkça Sorulan Sorular")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.theme.textPrimary)
                                
                                FAQItem(
                                    question: "Çeviri nasıl yapılır?",
                                    answer: "Metin çevirisi için ana ekranda metni girin ve çeviri butonuna basın. Konuşma çevirisi için mikrofon simgesine tıklayın."
                                )
                                
                                FAQItem(
                                    question: "Dil nasıl değiştirilir?",
                                    answer: "Dil seçim butonlarına tıklayarak kaynak ve hedef dilleri değiştirebilirsiniz."
                                )
                                
                                FAQItem(
                                    question: "Çeviri geçmişi nasıl görüntülenir?",
                                    answer: "Alt menüden 'Geçmiş' sekmesine tıklayarak önceki çevirilerinizi görebilirsiniz."
                                )
                            }
                            .padding()
                            
                            // İletişim Bölümü
                            VStack(alignment: .leading, spacing: 16) {
                                Text("İletişim")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.theme.textPrimary)
                                
                                ContactButton(
                                    icon: "envelope.fill",
                                    title: "E-posta",
                                    subtitle: "destek@translateapp.com"
                                )
                                
                                ContactButton(
                                    icon: "phone.fill",
                                    title: "Telefon",
                                    subtitle: "+90 555 123 4567"
                                )
                            }
                            .padding()
                        }
                    }
                }
            }
        }
    }
}

struct FAQItem: View {
    let question: String
    let answer: String
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(question)
                        .font(.headline)
                        .foregroundColor(Color.theme.textPrimary)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(Color.theme.primary)
                }
            }
            
            if isExpanded {
                Text(answer)
                    .font(.subheadline)
                    .foregroundColor(Color.theme.textSecondary)
                    .padding(.top, 4)
            }
        }
        .padding()
        .background(Color.theme.surface)
        .cornerRadius(12)
    }
}

struct ContactButton: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(Color.theme.primary)
                .frame(width: 30)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(Color.theme.textPrimary)
                
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(Color.theme.textSecondary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.theme.surface)
        .cornerRadius(12)
    }
} 