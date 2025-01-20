import SwiftUI

struct AddGroupView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var groups: [ReminderGroup]
    
    @State private var title = ""
    @State private var selectedColor = Color.blue
    @State private var selectedIcon = "list.bullet"
    @State private var searchText = ""
    
    let colors: [[Color]] = [
        // Ana Renkler
        [.red, .orange, .yellow, .green, .blue, .purple, .pink],
        
        // Pastel Tonlar
        [
            Color(red: 1.0, green: 0.8, blue: 0.8),   // Pastel Kırmızı
            Color(red: 1.0, green: 0.9, blue: 0.8),   // Pastel Turuncu
            Color(red: 1.0, green: 1.0, blue: 0.8),   // Pastel Sarı
            Color(red: 0.8, green: 1.0, blue: 0.8),   // Pastel Yeşil
            Color(red: 0.8, green: 0.9, blue: 1.0),   // Pastel Mavi
            Color(red: 0.9, green: 0.8, blue: 1.0),   // Pastel Mor
            Color(red: 1.0, green: 0.8, blue: 0.9)    // Pastel Pembe
        ],
        
        // Koyu Tonlar
        [
            Color(red: 0.6, green: 0.0, blue: 0.0),   // Koyu Kırmızı
            Color(red: 0.6, green: 0.3, blue: 0.0),   // Koyu Turuncu
            Color(red: 0.6, green: 0.6, blue: 0.0),   // Koyu Sarı
            Color(red: 0.0, green: 0.5, blue: 0.0),   // Koyu Yeşil
            Color(red: 0.0, green: 0.0, blue: 0.6),   // Koyu Mavi
            Color(red: 0.3, green: 0.0, blue: 0.6),   // Koyu Mor
            Color(red: 0.6, green: 0.0, blue: 0.3)    // Koyu Pembe
        ],
        
        // Modern Renkler
        [.mint, .teal, .cyan, .indigo, .brown],
        
        // Gri Tonları
        [
            Color(white: 0.3),  // Koyu Gri
            Color(white: 0.5),  // Orta Gri
            Color(white: 0.7)   // Açık Gri
        ]
    ]
    
    let icons = [
        // Genel
        "list.bullet", "star", "heart", "bell", "flag",
        "bookmark", "tag", "folder", "tray",
        
        // Ev & Yaşam
        "house", "bed.double", "lamp.table", "washer",
        "key", "lock", "door.left.hand.closed",
        
        // Alışveriş & Para
        "cart", "bag", "creditcard", "giftcard",
        "banknote", "wallet.pass", "basket",
        
        // Seyahat & Ulaşım
        "airplane", "car", "bus", "tram", "bicycle",
        "figure.walk", "map", "location",
        
        // Sağlık & Spor
        "heart.text.square", "cross.case",
        "pills", "bandage", "stethoscope",
        "figure.run", "dumbbell", "tennis.racket",
        
        // Eğitim & İş
        "book", "graduationcap", "pencil.and.ruler",
        "briefcase", "case", "newspaper",
        
        // Teknoloji
        "desktopcomputer", "laptopcomputer", "keyboard",
        "printer", "phone",
        
        // Eğlence
        "tv", "gamecontroller", "music.note",
        "theatermasks", "ticket", "film",
        
        // Yemek & İçecek
        "fork.knife", "cup.and.saucer", "wineglass",
        "birthday.cake", "takeoutbag.and.cup.and.straw",
        
        // Doğa & Hava
        "leaf", "tree", "cloud", "sun.max",
        "moon.stars", "snowflake", "umbrella",
        
        // Sosyal & İletişim
        "person", "person.2", "person.3",
        "envelope", "message", "phone.circle",
        
        // Takvim & Zaman
        "calendar", "clock", "alarm", "timer",
        "hourglass", "stopwatch",
        
        // Dosya & Belgeler
        "doc", "doc.text", "note.text",
        "clipboard", "paperclip", "archivebox"
    ]
    
    var filteredIcons: [String] {
        if searchText.isEmpty {
            return icons
        }
        return icons.filter { $0.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Grup Adı", text: $title)
                }
                
                Section("Renk") {
                    ForEach(colors.indices, id: \.self) { section in
                        LazyVGrid(columns: [
                            GridItem(.adaptive(minimum: 44))
                        ], spacing: 10) {
                            ForEach(colors[section], id: \.self) { color in
                                Circle()
                                    .fill(color)
                                    .frame(width: 44, height: 44)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.primary, lineWidth: selectedColor == color ? 2 : 0)
                                    )
                                    .onTapGesture {
                                        selectedColor = color
                                    }
                            }
                        }
                        .padding(.vertical, 5)
                        
                        if section < colors.count - 1 {
                            Divider()
                        }
                    }
                }
                
                Section("İkon") {
                    TextField("İkon Ara", text: $searchText)
                        .textInputAutocapitalization(.never)
                    
                    LazyVGrid(columns: [
                        GridItem(.adaptive(minimum: 44))
                    ], spacing: 10) {
                        ForEach(filteredIcons, id: \.self) { icon in
                            Image(systemName: icon)
                                .font(.title2)
                                .frame(width: 44, height: 44)
                                .background(selectedIcon == icon ? selectedColor.opacity(0.2) : Color.clear)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(selectedIcon == icon ? selectedColor : Color.clear, lineWidth: 2)
                                )
                                .onTapGesture {
                                    selectedIcon = icon
                                }
                        }
                    }
                }
            }
            .navigationTitle("Yeni Grup")
            .navigationBarItems(
                leading: Button("İptal") {
                    dismiss()
                },
                trailing: Button("Ekle") {
                    let group = ReminderGroup(
                        id: UUID(),
                        title: title,
                        color: selectedColor,
                        icon: selectedIcon
                    )
                    groups.append(group)
                    dismiss()
                }
                .disabled(title.isEmpty)
            )
        }
    }
}

#Preview {
    AddGroupView(groups: .constant([]))
}
