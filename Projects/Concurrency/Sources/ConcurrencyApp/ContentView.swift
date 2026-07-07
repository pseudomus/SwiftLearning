import SwiftUI
actor Counter {
    private(set) var value = 0

    func increment() {
        value += 1
    }
}

@MainActor
@Observable
final class ContentViewModel {
    var count = 0
    var isLoading = false

    private let counter = Counter()

    func incrementTapped() async {
        isLoading = true
        defer { isLoading = false }

        // Simula trabalho assíncrono (ex: chamada de rede)
        try? await Task.sleep(for: .milliseconds(300))

        await counter.increment()
        count = await counter.value
    }
}

struct ContentView: View {
    @State private var viewModel = ContentViewModel()

    var body: some View {
        VStack(spacing: 20) {
            Text("\(viewModel.count)")
                .font(.system(size: 64, weight: .bold, design: .rounded))
                .contentTransition(.numericText())
                .animation(.snappy, value: viewModel.count)

            Button {
                Task {
                    await viewModel.incrementTapped()
                }
            } label: {
                Label("Incrementar", systemImage: "plus.circle.fill")
                    .font(.title3)
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.isLoading)

            if viewModel.isLoading {
                ProgressView()
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
