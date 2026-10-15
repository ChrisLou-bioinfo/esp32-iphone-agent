import SwiftUI

/// One compact configuration form shared by onboarding and Settings.
struct ProviderFields: View {
    @ObservedObject var settings: Settings

    var body: some View {
        VStack(spacing: 0) {
            LabeledContent("Provider") {
                Picker("Provider", selection: $settings.selectedProvider) {
                    ForEach(ModelProvider.allCases) { provider in Text(verbatim: provider.title).tag(provider) }
                }
                .labelsHidden().pickerStyle(.menu).tint(.primary).lineLimit(1)
            }
            .frame(minHeight: 44)
            Divider()
            if settings.provider == .others {
                LabeledContent("Base URL") {
                    TextField("Base URL", text: $settings.baseURL, prompt: Text(verbatim: "https://…/v1"))
                        .keyboardType(.URL).multilineTextAlignment(.trailing).labelsHidden()
                }
                .frame(minHeight: 44).padding(.vertical, Space.xs)
                Divider()
            }
            LabeledContent("API key") {
                SecureField("API key", text: $settings.apiKey,
                            prompt: Text(settings.provider == .others ? "Optional" : "Required"))
                    .multilineTextAlignment(.trailing).labelsHidden()
            }
            .frame(minHeight: 44).padding(.vertical, Space.xs)
            Divider()
            LabeledContent("Model") {
                HStack(spacing: Space.xs) {
                    TextField("Model ID", text: $settings.model, prompt: Text("Choose or enter"))
                        .multilineTextAlignment(.trailing).labelsHidden()
                    if settings.loadingModels {
                        ProgressView().frame(minWidth: 44, minHeight: 44)
                    } else {
                        Menu("Choose Model", systemImage: "chevron.up.chevron.down") {
                            ForEach(settings.models, id: \.self) { id in
                                Button { settings.model = id } label: { Text(verbatim: id) }
                            }
                            Divider()
                            Button("Refresh Models", systemImage: "arrow.clockwise") {
                                Task { await settings.loadModels() }
                            }
                            .disabled(!settings.isConfigured)
                        }
                        .labelStyle(.iconOnly).tint(.secondary)
                        .frame(minWidth: 44, minHeight: 44)
                    }
                }
            }
            .frame(minHeight: 44).padding(.vertical, Space.xs)
            if let error = settings.modelsError {
                Text(verbatim: error).font(.footnote).foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .textInputAutocapitalization(.never).autocorrectionDisabled()
        .task(id: settings.baseURL + "\n" + settings.apiKey) {
            guard settings.provider != .others, !settings.apiKey.isEmpty,
                  (try? await Task.sleep(for: .milliseconds(700))) != nil else { return }
            await settings.loadModels()
        }
    }
}
