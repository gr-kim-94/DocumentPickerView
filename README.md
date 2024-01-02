# DocumentPickerView
- SwiftUI
- UIDocumentPickerViewController
- Local File URL -> File Data ( [Providing access to directories](https://developer.apple.com/documentation/uikit/view_controllers/providing_access_to_directories) )

## ViewModel
````
class ViewModel: ObservableObject {
  private var cancelBag = Set<AnyCancellable>()
  
  @Published var isDocumentPresented: Bool = false
  @Published var selectedFileData: Data?
  
  override init() {
      super.init()
      
      $selectedFileData
          .sink(receiveValue: { [weak self] newValue in
              if let data = newValue {
                // Handler File Data
              }
          })
          .store(in: &cancelBag)
  }
}
````

## View
````
@StateObject var viewModel: ViewModel = ViewModel()

var body: some View {
    ZStack {
        Button {
            viewModel.isDocumentPresented = true
        } label: {
            Image("Upload")
                .foregroundColor(.primary_80_100)
                .frame(width: 44, height: 44)
        }
    }
    .fullScreenCover(isPresented: $viewModel.isDocumentPresented) {
        DocumentPickerView(isPresented: $viewModel.isDocumentPresented, data: $viewModel.selectedFileData)
    }
}

````

