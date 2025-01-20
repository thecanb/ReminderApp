import SwiftUI

struct ShoppingItemRow: View {
    @Binding var item: ShoppingItem
    
    var body: some View {
        HStack(spacing: 12) {
            Button {
                withAnimation {
                    item.isCompleted.toggle()
                }
            } label: {
                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(item.isCompleted ? .green : .gray)
                    .font(.title2)
            }
            
            if let imageData = item.imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .cornerRadius(8)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .strikethrough(item.isCompleted)
                    .foregroundColor(item.isCompleted ? .secondary : .primary)
                
                if let price = item.price {
                    Text(price)
                        .font(.caption)
                        .foregroundColor(.blue)
                }
                
                if let notes = item.notes {
                    Text(notes)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
                HStack {
                    Stepper("Adet: \(item.quantity)", value: $item.quantity, in: 1...99)
                        .labelsHidden()
                    Text("Adet: \(item.quantity)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            Link(destination: item.url) {
                Image(systemName: "link.circle.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    let testImage = UIImage(systemName: "photo")
    
    return List {
        ShoppingItemRow(item: .constant(
            ShoppingItem(
                title: "Test Item",
                url: URL(string: "https://example.com")!,
                notes: "Test notes",
                price: "299₺",
                quantity: 2,
                imageData: testImage?.pngData()
            )
        ))
        ShoppingItemRow(item: .constant(
            ShoppingItem(
                title: "Completed Item",
                url: URL(string: "https://example.com")!,
                isCompleted: true
            )
        ))
    }
} 
