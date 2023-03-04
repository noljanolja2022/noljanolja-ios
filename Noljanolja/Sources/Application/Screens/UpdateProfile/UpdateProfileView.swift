//
//  UpdateProfileView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 04/03/2023.
//
//

import Kingfisher
import PhotosUI
import SwiftUI
import SwiftUINavigation

// MARK: - UpdateProfileView

struct UpdateProfileView<ViewModel: UpdateProfileViewModelType>: View {
    // MARK: Dependencies

    @StateObject private var viewModel: ViewModel

    // MARK: State

    @State private var imageSourceType: ImagePickerView.SourceType? = nil
    @State private var isDatePickerShown = false

    init(viewModel: ViewModel = UpdateProfileViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        content
            .actionSheet(item: $viewModel.state.actionSheetType) {
                buildActionSheet($0)
            }
            .popover(item: $imageSourceType) { buildImagePicker($0) }
            .popover(isPresented: $isDatePickerShown) { datePicker }
    }

    var content: some View {
        VStack(spacing: 16) {
            ZStack(alignment: .bottomTrailing) {
                if let image = viewModel.state.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 140, height: 140)
                        .background(Color.gray.opacity(0.5))
                        .cornerRadius(52)
                } else {
                    KFImage(URL(string: "https://sm.ign.com/ign_nordic/cover/a/avatar-gen/avatar-generations_prsz.jpg"))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 140, height: 140)
                        .background(Color.gray.opacity(0.5))
                        .cornerRadius(52)
                }

                Button(
                    action: { viewModel.send(.openAvatarActionSheet) },
                    label: {
                        Image(systemName: "camera")
                            .resizable()
                            .scaledToFit()
                            .padding(8)
                            .frame(width: 44, height: 44)
                            .background(Color.gray)
                            .cornerRadius(22)
                    }
                )
                .foregroundColor(.white)
            }
            ZStack(alignment: .bottom) {
                HStack(spacing: 16) {
                    Image(systemName: "person")
                        .resizable()
                        .frame(width: 20, height: 20)
                    TextField("Name", text: $viewModel.state.name)
                        .textFieldStyle(FullSizeTappableTextFieldStyle())
                }
                .padding(8)
                Divider()
                    .background(Color.black)
            }
            .frame(height: 58)
            .background(ColorAssets.gray.swiftUIColor)
            .cornerRadius(8, corners: [.topLeft, .topRight])

            HStack(spacing: 16) {
                ZStack(alignment: .bottom) {
                    Button(
                        action: { isDatePickerShown = true },
                        label: {
                            HStack {
                                Text(
                                    viewModel.state.birthday?.string(withFormat: "dd/MM/yyyy")
                                        ?? "Day of Birth"
                                )
                                Spacer()
                                Image(systemName: "arrowtriangle.down.fill")
                                    .resizable()
                                    .frame(width: 20, height: 12)
                            }
                            .padding(8)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                            .foregroundColor(.black)
                        }
                    )
                    Divider()
                        .background(Color.black)
                }
                .frame(height: 58)
                .background(ColorAssets.gray.swiftUIColor)
                .cornerRadius(8, corners: [.topLeft, .topRight])

                ZStack(alignment: .bottom) {
                    Button(
                        action: { viewModel.send(.openGenderActionSheet) },
                        label: {
                            HStack {
                                Text(
                                    viewModel.state.gender ?? "Gender"
                                )
                                Spacer()
                                Image(systemName: "arrowtriangle.down.fill")
                                    .resizable()
                                    .frame(width: 20, height: 12)
                            }
                            .padding(8)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                            .foregroundColor(.black)
                        }
                    )
                    Divider()
                        .background(Color.black)
                }
                .frame(height: 58)
                .background(ColorAssets.gray.swiftUIColor)
                .cornerRadius(8, corners: [.topLeft, .topRight])
            }

            Button(
                "OK",
                action: {}
            )
            .buttonStyle(PrimaryButtonStyle())
            .shadow(
                color: ColorAssets.black.swiftUIColor.opacity(0.12), radius: 2, y: 1
            )

            Spacer()
        }
        .padding(16)
    }

    var datePicker: some View {
        VStack(spacing: 0) {
            Spacer()
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Button(
                        action: { isDatePickerShown = false },
                        label: {
                            Image(systemName: "xmark")
                                .resizable()
                                .padding(12)
                                .frame(width: 44, height: 44)
                        }
                    )
                    Spacer()
                    Text("Date of Birth")
                        .font(FontFamily.NotoSans.bold.swiftUIFont(size: 18))
                    Spacer()
                    Spacer()
                        .frame(width: 44, height: 44)
                }
                .frame(height: 44)
                .foregroundColor(ColorAssets.forcegroundPrimary.swiftUIColor)

                Divider()
                    .background(Color.gray)

                DatePicker(
                    "",
                    selection: Binding<Date>(
                        get: { viewModel.state.birthday ?? Date() },
                        set: {
                            viewModel.state.birthday = $0
                            isDatePickerShown = false
                        }
                    ),
                    in: ...Date(),
                    displayedComponents: .date
                )
                .datePickerStyle(GraphicalDatePickerStyle())
                .frame(width: .none)
            }
            .background(Color.white.ignoresSafeArea())
            .cornerRadius(16, corners: [.topLeft, .topRight])
        }
        .background(Color.black.opacity(0.3).ignoresSafeArea())
        .introspectViewController { viewController in
            viewController.view.backgroundColor = .clear
        }
    }

    func buildActionSheet(_ type: ViewModel.State.ActionSheetType) -> ActionSheet {
        switch type {
        case .avatar:
            return ActionSheet(
                title: Text("Set Avatar"),
                buttons: [
                    .default(Text("Open Camera")) { imageSourceType = .camera },
                    .default(Text("Select Photo")) { imageSourceType = .photoLibrary },
                    .cancel(Text("Cancel"))
                ]
            )
        case .gender:
            return ActionSheet(
                title: Text("Gender"),
                buttons: [
                    .default(Text("Male")) { viewModel.state.gender = "Male" },
                    .default(Text("Female")) { viewModel.state.gender = "Female" },
                    .default(Text("Other")) { viewModel.state.gender = "Other" },
                    .cancel(Text("Cancel"))
                ]
            )
        }
    }

    func buildImagePicker(_ sourceType: ImagePickerView.SourceType) -> some View {
        ImagePickerView(selection: $viewModel.state.image, sourceType: sourceType)
    }
}

// MARK: - UpdateProfileView_Previews

struct UpdateProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateProfileView()
    }
}
