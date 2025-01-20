import SwiftUI

struct SavingsGoalView: View {
    @Binding var goals: [SavingsGoal]
    @State private var showingAddGoal = false
    @State private var showingAddTransaction = false
    @State private var selectedGoal: SavingsGoal?
    @EnvironmentObject var settings: AppSettings
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                TotalProgressCard(goals: goals)
                    .padding(.horizontal)
                
                LazyVStack(spacing: 15) {
                    ForEach(goals) { goal in
                        SavingsGoalCard(goal: goal)
                            .padding(.horizontal)
                            .contextMenu {
                                Button {
                                    selectedGoal = goal
                                    showingAddTransaction = true
                                } label: {
                                    Label("Para Ekle", systemImage: "plus.circle")
                                }
                                
                                Button(role: .destructive) {
                                    withAnimation {
                                        goals.removeAll { $0.id == goal.id }
                                    }
                                } label: {
                                    Label("Sil", systemImage: "trash")
                                }
                            }
                            .onTapGesture {
                                selectedGoal = goal
                                showingAddTransaction = true
                            }
                    }
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("Birikim Hedefleri")
        .toolbar {
            Button {
                showingAddGoal = true
            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
            }
        }
        .sheet(isPresented: $showingAddGoal) {
            AddSavingsGoalView(goals: $goals)
        }
        .sheet(item: $selectedGoal) { goal in
            AddTransactionView(goal: goal, goals: $goals)
        }
    }
}

struct AddTransactionView: View {
    @Environment(\.dismiss) var dismiss
    let goal: SavingsGoal
    @Binding var goals: [SavingsGoal]
    
    @State private var amount = ""
    @State private var notes = ""
    @State private var date = Date()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Tutar", text: $amount)
                        .keyboardType(.decimalPad)
                    DatePicker("Tarih", selection: $date, displayedComponents: .date)
                    TextField("Not", text: $notes)
                }
                
                Section {
                    HStack {
                        Text("Mevcut Birikim")
                        Spacer()
                        Text(goal.currentAmount.formatted(.currency(code: "TRY")))
                    }
                    HStack {
                        Text("Hedef")
                        Spacer()
                        Text(goal.targetAmount.formatted(.currency(code: "TRY")))
                    }
                }
            }
            .navigationTitle("Para Ekle")
            .navigationBarItems(
                leading: Button("İptal") {
                    dismiss()
                },
                trailing: Button("Ekle") {
                    if let amountValue = Double(amount) {
                        let transaction = SavingsTransaction(
                            amount: amountValue,
                            date: date,
                            notes: notes.isEmpty ? nil : notes
                        )
                        
                        if let index = goals.firstIndex(where: { $0.id == goal.id }) {
                            goals[index].transactions.append(transaction)
                            goals[index].currentAmount += amountValue
                        }
                        
                        dismiss()
                    }
                }
                .disabled(amount.isEmpty)
            )
        }
    }
}

struct TotalProgressCard: View {
    let goals: [SavingsGoal]
    @EnvironmentObject var settings: AppSettings
    
    var totalTarget: Double {
        goals.reduce(0) { $0 + $1.targetAmount }
    }
    
    var totalCurrent: Double {
        goals.reduce(0) { $0 + $1.currentAmount }
    }
    
    var progress: Double {
        guard totalTarget > 0 else { return 0 }
        return min(totalCurrent / totalTarget, 1)
    }
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Toplam Birikim")
                        .font(.headline)
                    Text(totalCurrent.formatted(.currency(code: settings.currency.rawValue)))
                        .font(.title2)
                        .bold()
                }
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(Color.blue.opacity(0.2), lineWidth: 8)
                        .frame(width: 60, height: 60)
                    
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(Color.blue, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                        .frame(width: 60, height: 60)
                        .rotationEffect(.degrees(-90))
                    
                    Text("\(Int(progress * 100))%")
                        .font(.caption)
                        .bold()
                }
            }
            
            ProgressView(value: progress, total: 1.0)
                .tint(.blue)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemBackground))
                .shadow(color: .gray.opacity(0.2), radius: 5)
        )
    }
}

struct SavingsGoalCard: View {
    let goal: SavingsGoal
    @EnvironmentObject var settings: AppSettings
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(goal.title)
                        .font(.headline)
                    
                    if let deadline = goal.deadline {
                        Text(deadline.formatted(date: .abbreviated, time: .omitted))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                Text("\(Int(goal.progress * 100))%")
                    .font(.title3)
                    .bold()
                    .foregroundColor(goal.progress >= 1 ? .green : .blue)
            }
            
            ProgressView(value: goal.progress, total: 1.0)
                .tint(goal.progress >= 1 ? .green : .blue)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Mevcut")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(goal.currentAmount.formatted(.currency(code: settings.currency.rawValue)))
                        .font(.subheadline)
                        .bold()
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Hedef")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(goal.targetAmount.formatted(.currency(code: settings.currency.rawValue)))
                        .font(.subheadline)
                        .bold()
                }
            }
            
            if let notes = goal.notes {
                Text(notes)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemBackground))
                .shadow(color: .gray.opacity(0.2), radius: 5)
        )
    }
}

struct AddSavingsGoalView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var goals: [SavingsGoal]
    
    @State private var title = ""
    @State private var targetAmount = ""
    @State private var currentAmount = ""
    @State private var notes = ""
    @State private var deadline: Date = Date()
    @State private var hasDeadline = false
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Hedef Adı", text: $title)
                    TextField("Hedef Tutar", text: $targetAmount)
                        .keyboardType(.decimalPad)
                    TextField("Mevcut Tutar", text: $currentAmount)
                        .keyboardType(.decimalPad)
                }
                
                Section {
                    Toggle("Son Tarih", isOn: $hasDeadline)
                    if hasDeadline {
                        DatePicker("Tarih", selection: $deadline, displayedComponents: .date)
                    }
                }
                
                Section {
                    TextField("Notlar", text: $notes)
                }
            }
            .navigationTitle("Yeni Hedef")
            .navigationBarItems(
                leading: Button("İptal") {
                    dismiss()
                },
                trailing: Button("Ekle") {
                    if let targetValue = Double(targetAmount) {
                        let goal = SavingsGoal(
                            title: title,
                            targetAmount: targetValue,
                            currentAmount: Double(currentAmount) ?? 0,
                            deadline: hasDeadline ? deadline : nil,
                            notes: notes.isEmpty ? nil : notes
                        )
                        goals.append(goal)
                        dismiss()
                    }
                }
                .disabled(title.isEmpty || targetAmount.isEmpty)
            )
        }
    }
}
