//
//  UpdateCurrentUserView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 04/03/2023.
//
//

import Kingfisher
import PhotosUI
import SwiftUI
import SwiftUINavigation

// MARK: - UpdateCurrentUserView

struct UpdateCurrentUserView<ViewModel: UpdateCurrentUserViewModelType>: View {
    // MARK: Dependencies

    @StateObject private var viewModel: ViewModel

    // MARK: State

    private let nameMaxLength = 20

    @State private var isNameEditing = false
    @State private var imageSourceType: ImagePickerView.SourceType? = nil
    @State private var isDatePickerShown = false
    @EnvironmentObject private var progressHUBState: ProgressHUBState

    init(viewModel: ViewModel = UpdateCurrentUserViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        buildContentView()
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Update Profile")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                }
            }
            .onChange(of: viewModel.state.isProgressHUDShowing) {
                progressHUBState.isLoading = $0
            }
            .alert(item: $viewModel.state.alertState) { Alert($0) { _ in } }
            .actionSheet(item: $viewModel.state.actionSheetType) {
                buildActionSheet($0)
            }
            .popover(item: $imageSourceType) { buildImagePicker($0) }
            .popover(isPresented: $isDatePickerShown) { buildDatePickerView() }
    }

    private func buildContentView() -> some View {
        VStack(spacing: 52) {
            buildAvatarView()

            VStack(spacing: 20) {
                buildNameView()
                buildDOBAndGenderView()
            }

            buildActionView()

            Spacer()
        }
        .padding(16)
        .padding(.top, 24)
    }

    private func buildAvatarView() -> some View {
        ZStack(alignment: .bottomTrailing) {
            IfLet(
                $viewModel.state.image,
                then: {
                    Image(uiImage: $0.wrappedValue)
                        .resizable()
                },
                else: {
                    KFImage(URL(string: viewModel.state.avatar))
                        .placeholder {
                            ImageAssets.icAvatarPlaceholder.swiftUIImage
                        }
                        .resizable()
                }
            )
            .scaledToFill()
            .frame(width: 112, height: 112)
            .background(Color.white)
            .cornerRadius(56)

            Button(
                action: { viewModel.send(.openAvatarActionSheet) },
                label: {
                    Image(systemName: "camera.fill")
                        .resizable()
                        .scaledToFit()
                        .padding(6)
                        .frame(width: 32, height: 32)
                        .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
                        .background(ColorAssets.neutralLightGrey.swiftUIColor)
                        .cornerRadius(22)
                }
            )
        }
    }

    private func buildNameView() -> some View {
        VStack(spacing: 0) {
            Text("Name")
                .font(.system(size: 12))
                .foregroundColor(
                    isNameEditing
                        ? ColorAssets.primaryYellow3.swiftUIColor
                        : ColorAssets.neutralDeepGrey.swiftUIColor
                )
                .frame(maxWidth: .infinity, alignment: .leading)

            TextField(
                "Name",
                text: $viewModel.state.name.max(nameMaxLength),
                isEditing: $isNameEditing
            )
            .textFieldStyle(TappableTextFieldStyle())
            .font(.system(size: 16))
            .frame(height: 38)
            .padding(0)
            .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)

            Divider()
                .frame(height: 2)
                .overlay(
                    isNameEditing
                        ? ColorAssets.primaryYellow3.swiftUIColor
                        : ColorAssets.neutralDeepGrey.swiftUIColor
                )

            HStack(spacing: 0) {
                Text("Required")
                Spacer()
                Text("\(viewModel.state.name?.count ?? 0)/\(nameMaxLength)")
            }
            .font(.system(size: 12))
            .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
            .padding(.top, 8)
            .padding(.horizontal, 12)
        }
    }

    private func buildDOBAndGenderView() -> some View {
        HStack(spacing: 16) {
            Button(
                action: { isDatePickerShown = true },
                label: {
                    VStack {
                        HStack(spacing: 16) {
                            Text(
                                viewModel.state.dob?.string(withFormat: "dd/MM/yyyy")
                                    ?? "Day of Birth"
                            )
                            .font(.system(size: 16))
                            .foregroundColor(
                                isDatePickerShown
                                    ? ColorAssets.primaryYellow3.swiftUIColor
                                    : viewModel.state.dob != nil
                                    ? ColorAssets.neutralDarkGrey.swiftUIColor
                                    : ColorAssets.neutralDeepGrey.swiftUIColor
                            )

                            Spacer()

                            Image(systemName: "arrowtriangle.down.fill")
                                .resizable()
                                .frame(width: 10, height: 5)
                                .scaledToFill()
                        }
                        .foregroundColor(
                            viewModel.state.dob != nil
                                ? ColorAssets.neutralDarkGrey.swiftUIColor
                                : ColorAssets.neutralDeepGrey.swiftUIColor
                        )
                        .frame(height: 38)
                        .padding(.horizontal, 16)

                        Divider()
                            .frame(height: 2)
                            .overlay(
                                isDatePickerShown
                                    ? ColorAssets.primaryYellow3.swiftUIColor
                                    : viewModel.state.dob != nil
                                    ? ColorAssets.neutralDarkGrey.swiftUIColor
                                    : ColorAssets.neutralDeepGrey.swiftUIColor
                            )
                    }
                }
            )

            Button(
                action: { viewModel.send(.openGenderActionSheet) },
                label: {
                    VStack {
                        HStack(spacing: 16) {
                            Text(
                                viewModel.state.gender?.rawValue.lowercased().capitalized
                                    ?? "Gender"
                            )
                            .font(.system(size: 16))
                            .foregroundColor(
                                viewModel.state.actionSheetType == .gender
                                    ? ColorAssets.primaryYellow3.swiftUIColor
                                    : viewModel.state.gender != nil
                                    ? ColorAssets.neutralDarkGrey.swiftUIColor
                                    : ColorAssets.neutralDeepGrey.swiftUIColor
                            )

                            Spacer()

                            Image(systemName: "arrowtriangle.down.fill")
                                .resizable()
                                .frame(width: 10, height: 5)
                                .scaledToFill()
                        }
                        .foregroundColor(
                            viewModel.state.dob != nil
                                ? ColorAssets.neutralDarkGrey.swiftUIColor
                                : ColorAssets.neutralDeepGrey.swiftUIColor
                        )
                        .frame(height: 38)
                        .padding(.horizontal, 16)

                        Divider()
                            .frame(height: 2)
                            .overlay(
                                viewModel.state.actionSheetType == .gender
                                    ? ColorAssets.primaryYellow3.swiftUIColor
                                    : viewModel.state.gender != nil
                                    ? ColorAssets.neutralDarkGrey.swiftUIColor
                                    : ColorAssets.neutralDeepGrey.swiftUIColor
                            )
                    }
                }
            )
        }
    }

    private func buildActionView() -> some View {
        Button(
            "OK",
            action: { viewModel.send(.updateCurrentUser) }
        )
        .buttonStyle(PrimaryButtonStyle())
    }

    private func buildDatePickerView() -> some View {
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
                        .font(.system(size: 18, weight: .bold))
                    Spacer()
                    Spacer()
                        .frame(width: 44, height: 44)
                }
                .frame(height: 44)
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)

                Divider()
                    .background(Color.gray)

                DatePicker(
                    "",
                    selection: Binding<Date>(
                        get: { viewModel.state.dob ?? Date() },
                        set: {
                            viewModel.state.dob = $0
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
                    .default(Text("Male")) { viewModel.state.gender = .male },
                    .default(Text("Female")) { viewModel.state.gender = .female },
                    .default(Text("Other")) { viewModel.state.gender = .other },
                    .cancel(Text("Cancel"))
                ]
            )
        }
    }

    func buildImagePicker(_ sourceType: ImagePickerView.SourceType) -> some View {
        ImagePickerView(selection: $viewModel.state.image, sourceType: sourceType)
    }
}

// MARK: - UpdateCurrentUserView_Previews

struct UpdateCurrentUserView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateCurrentUserView()
    }
}
