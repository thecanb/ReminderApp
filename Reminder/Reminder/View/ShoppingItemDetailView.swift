import SwiftUI

struct ShoppingItemDetailView: View {
    @Binding var item: ShoppingItem
    @State private var showingImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var showingEditSheet = false
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Text("Ürün Adı")
                    Spacer()
                    Text(item.title)
                        .foregroundColor(.secondary)
                }
                
                if let price = item.price {
                    HStack {
                        Text("Fiyat")
                        Spacer()
                        Text(price)
                            .foregroundColor(.blue)
                    }
                }
                
                HStack {
                    Text("Adet")
                    Spacer()
                    Stepper("\(item.quantity)", value: $item.quantity, in: 1...99)
                }
                
                if let notes = item.notes {
                    HStack {
                        Text("Notlar")
                        Spacer()
                        Text(notes)
                            .foregroundColor(.secondary)
                    }
                }
                
                Link("Ürün Sayfasını Aç", destination: item.url)
            }
            
            Section("Ürün Fotoğrafı") {
                if let imageData = item.imageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 200)
                }
                
                Button {
                    showingImagePicker = true
                } label: {
                    Label(item.imageData == nil ? "Fotoğraf Ekle" : "Fotoğrafı Değiştir",
                          systemImage: "photo.on.rectangle.angled")
                }
            }
            
            Section {
                Toggle("Tamamlandı", isOn: $item.isCompleted)
            }
        }
        .navigationTitle("Ürün Detayı")
        .toolbar {
            Button {
                showingEditSheet = true
            } label: {
                Text("Düzenle")
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $selectedImage)
                .onChange(of: selectedImage) { newImage in
                    if let image = newImage {
                        item.imageData = image.jpegData(compressionQuality: 0.8)
                    }
                }
        }
        .sheet(isPresented: $showingEditSheet) {
            EditShoppingView(item: $item)
        }
    }
}

#Preview {
    NavigationView {
        ShoppingItemDetailView(item: .constant(
            ShoppingItem(
                title: "Test Item",
                url: URL(string: "https://example.com")!,
                notes: "Test notes",
                price: "299₺",
                quantity: 2,
                imageData: UIImage(systemName: "photo")?.pngData()
            )
        ))
    }
} 
