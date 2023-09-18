//
//  File.swift
//  
//
//  Created by Ian on 29/06/2022.
//

#if os(iOS)
import SwiftUI
import PhotosUI

@available(iOS 14.0, macOS 11, *)
public extension View {
    func mediaPicker(
        isPresented: Binding<Bool>,
        allowedMediaTypes: MediaTypeOptions,
        allowsMultipleSelection: Bool,
        onCompletion: @escaping (Result<[URL], Error>) -> Void
    ) -> some View {
        sheet(isPresented: isPresented) {
            MediaPickerWrapper(
                isPresented: isPresented,
                allowedMediaTypes: allowedMediaTypes,
                allowsMultipleSelection: allowsMultipleSelection,
                onCompletion: onCompletion
            )
        }
    }
}

@available(iOS 14.0, macOS 11, *)
fileprivate struct MediaPickerWrapper: View {
    @State private var isLoading: Bool = false
    @State private var progress: Progress = Progress()

    var configuration = PHPickerConfiguration(photoLibrary: .shared())
    @Binding var isPresented: Bool
    var allowedContentTypes: [UTType]
    var onCompletion: (Result<[URL], Error>) -> Void
    
    init(
        isPresented: Binding<Bool>,
        allowedMediaTypes: MediaTypeOptions,
        allowsMultipleSelection: Bool,
        onCompletion: @escaping (Result<[URL], Error>) -> Void
    ) {
        configuration.selectionLimit = allowsMultipleSelection ? 0 : 1
        configuration.filter = PHPickerFilter.from(allowedMediaTypes)
        configuration.preferredAssetRepresentationMode = .compatible

        self._isPresented = isPresented
        self.allowedContentTypes = allowedMediaTypes.typeIdentifiers
        self.onCompletion = onCompletion
    }
    
    var body: some View {
        MediaPickerRepresentable(
            configuration: configuration,
            isPresented: $isPresented,
            isLoading: $isLoading,
            progress: $progress,
            allowedContentTypes: allowedContentTypes,
            onCompletion: onCompletion
        )
        .overlay(isLoading ? loadingView : nil)
        .onDisappear {
            progress.cancel()
        }

    }
    
    var loadingView: some View {
        NavigationView {
            ProgressView(progress)
                .progressViewStyle(.linear)
                .padding()
                .navigationTitle("Importing Media...")
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
}

@available(iOS 14.0, macOS 11, *)
fileprivate struct MediaPickerRepresentable: UIViewControllerRepresentable {
    var configuration: PHPickerConfiguration
    @Binding var isPresented: Bool
    @Binding var isLoading: Bool
    @Binding var progress: Progress
    var allowedContentTypes: [UTType]
    var onCompletion: (Result<[URL], Error>) -> Void

    func makeUIViewController(context: Context) -> PHPickerViewController {
        let controller = PHPickerViewController(configuration: configuration)
        controller.delegate = context.coordinator

        return controller
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        // do nothing
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: PHPickerViewControllerDelegate {
        let parent: MediaPickerRepresentable
        var pathURLs: [URL] = []
        var error: Error?

        init(_ picker: MediaPickerRepresentable) {
            self.parent = picker
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            guard !results.isEmpty else {
                parent.isPresented = false
                return
            }
            handleResults(for: results)
        }

        var filesProgressCount: Int = 0 {
            didSet {
                if filesProgressCount == 0 {
                    finaliseResults()
                }
            }
        }

        private func handleResults(for results: [PHPickerResult]) {
            withAnimation {
                parent.isLoading = true
            }
            parent.progress.totalUnitCount = Int64(results.count)
            for result in results {
                let contentTypes = parent.allowedContentTypes
                for contentType in contentTypes {
                    let itemProvider = result.itemProvider
                    if itemProvider.hasItemConformingToTypeIdentifier(contentType.identifier) {
                        loadFile(for: itemProvider, ofType: contentType)
                        filesProgressCount += 1
                    }
                }
            }
        }

        private func loadFile(for itemProvider: NSItemProvider, ofType contentType: UTType) {
            let progress: Progress = itemProvider.loadFileRepresentation(forTypeIdentifier: contentType.identifier) { url, error in
                guard let url = url, error == nil else {
                    return
                }
                self.copyFile(from: url)
            }
            parent.progress.addChild(progress, withPendingUnitCount: 1)
        }

        private func copyFile(from url: URL) {
            MediaPicker.copyContents(of: url) { localURL, error in
                guard let localURL = localURL, error == nil else {
                    self.error = error
                    return
                }
                DispatchQueue.main.async {
                    self.pathURLs.append(localURL)
                    self.filesProgressCount -= 1
                }

            }
        }

        func finaliseResults() {
            withAnimation {
                parent.isLoading = false
            }
            if pathURLs.isEmpty {
                if let err = error {
                    parent.onCompletion(.failure(err))
                }
            } else {
                parent.onCompletion(.success(pathURLs))
            }
            parent.isPresented = false
        }
    }
}

@available(iOS 14.0, macOS 11, *)
fileprivate extension PHPickerFilter {
    static func from(_ mediaOptions: MediaTypeOptions) -> Self {
        var filters: [PHPickerFilter] = []
        if mediaOptions.contains(.images) {
            filters.append(.images)
        } else if mediaOptions.contains(.livePhotos) {
            filters.append(.livePhotos)
        }
        if mediaOptions.contains(.videos) {
            filters.append(.videos)
        }
        return PHPickerFilter.any(of: filters)
    }
}
#endif

