//
//  UpdateCurrentUserView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 04/03/2023.
//
//

import PhotosUI
import SDWebImageSwiftUI
import SwiftUI
import SwiftUINavigation
import SwiftUIX

// MARK: - UpdateCurrentUserView

struct UpdateCurrentUserView<ViewModel: UpdateCurrentUserViewModel>: View {
    // MARK: Dependencies

    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: ViewModel
    @StateObject private var keyboard = Keyboard.main
    @State private var isPhoneEditing = false
    @State private var isNameEditing = false
    @State private var isGenderEditing = false
    @State private var isEmailEditing = false

    private let nameMaxLength = 20

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        buildContentView()
            .navigationBar(title: "", backButtonTitle: "", presentationMode: presentationMode, trailing: {})
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
            .isProgressHUBVisible($viewModel.isProgressHUDShowing)
            .alert(item: $viewModel.alertState) { Alert($0) { _ in } }
            .actionSheet(item: $viewModel.actionSheetType) {
                buildActionSheetDestinationView($0)
            }
            .fullScreenCover(
                unwrapping: $viewModel.fullScreenCoverType,
                content: {
                    buildFullScreenCoverDestinationView($0)
                }
            )
    }

    private func buildContentView() -> some View {
        ScrollView {
            VStack(spacing: 52) {
                buildAvatarView()

                VStack(spacing: 12) {
                    buildUserSectionHeaderView()
                    buildNameView()
                    buildPhoneView()
                    buildDateOfBirth()
                    buildGenderView()
                }

                buildActionView()

                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 24)
            .padding(.bottom, 16)
        }
        .background(ColorAssets.neutralLight.swiftUIColor)
        .clipped()
    }

    private func buildAvatarView() -> some View {
        ZStack(alignment: .bottomTrailing) {
            IfLet(
                $viewModel.image,
                then: {
                    Image(uiImage: $0.wrappedValue)
                        .resizable()
                },
                else: {
                    WebImage(url: URL(string: viewModel.avatar))
                        .resizable()
                        .placeholder(ImageAssets.icAvatarPlaceholder.swiftUIImage)
                        .indicator(.activity)
                }
            )
            .scaledToFill()
            .frame(width: 112, height: 112)
            .cornerRadius(56)

            Button(
                action: {
                    viewModel.actionSheetType = .avatar
                },
                label: {
                    ImageAssets.icCameraFill.swiftUIImage
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

    private func buildUserSectionHeaderView() -> some View {
        Text(L10n.updateProfileUserInfo)
            .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
    }

    private func buildNameView() -> some View {
        UpdateCurrentUserInputView(
            content: {
                HStack(spacing: 4) {
                    TextField(
                        text: $viewModel.name.max(nameMaxLength),
                        isEditing: $isNameEditing
                    )
                    .textFieldStyle(TappableTextFieldStyle())
                    .dynamicFont(.systemFont(ofSize: 16))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .introspectTextField { textField in
                        textField.becomeFirstResponder()
                    }

                    Button(
                        action: {
                            viewModel.name = ""
                        },
                        label: {
                            ImageAssets.icClose.swiftUIImage
                                .resizable()
                                .scaledToFit()
                                .padding(6)
                                .frame(width: 24, height: 24)
                                .border(ColorAssets.neutralDarkGrey.swiftUIColor, width: 1, cornerRadius: 12)
                        }
                    )
                }
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                .frame(height: 52)
            },
            title: L10n.updateProfileName,
            description: nil,
            isEditing: isNameEditing,
            errorMessage: {
                if viewModel.name?.isEmpty ?? true || viewModel.name?.isValidName ?? true {
                    return nil
                } else {
                    return L10n.updateProfileNameError
                }
            }()
        )
    }

    private func buildPhoneView() -> some View {
        UpdateCurrentUserInputView(
            content: {
                HStack(spacing: 8) {
                    Button(
                        action: {
                            viewModel.fullScreenCoverType = .selectCountry
                        },
                        label: {
                            HStack(spacing: 8) {
                                Text(viewModel.country.flag)
                                    .dynamicFont(.systemFont(ofSize: 24))
                                    .frame(width: 30, height: 24)
                                    .background(ColorAssets.neutralLightGrey.swiftUIColor)
                                    .cornerRadius(3)
                                Text(viewModel.country.prefix)
                                    .dynamicFont(.systemFont(ofSize: 16))
                                Image(systemName: "chevron.down")
                                    .resizable()
                                    .scaledToFit()
                                    .padding(6)
                                    .frame(width: 24, height: 24)
                                    .tintColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                            }
                            .frame(maxHeight: .infinity)
                        }
                    )
                    .frame(width: 104)

                    TextField(
                        "",
                        text: $viewModel.phoneNumberText,
                        isEditing: $isPhoneEditing
                    )
                    .keyboardType(.phonePad)
                    .textFieldStyle(TappableTextFieldStyle())
                    .dynamicFont(.systemFont(ofSize: 16))
                    .frame(maxHeight: .infinity)

                    Button(
                        action: {
                            viewModel.phoneNumberText = ""
                        },
                        label: {
                            ImageAssets.icClose.swiftUIImage
                                .resizable()
                                .scaledToFit()
                                .padding(6)
                                .frame(width: 24, height: 24)
                                .border(ColorAssets.neutralDarkGrey.swiftUIColor, width: 1, cornerRadius: 12)
                        }
                    )
                }
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                .frame(height: 52)
            },
            title: L10n.updateProfilePhone,
            description: nil,
            isEditing: isPhoneEditing,
            errorMessage: {
                if viewModel.phoneNumberText.isEmpty || viewModel.phoneNumber?.isValidPhoneNumber ?? true {
                    return nil
                } else {
                    return L10n.updateProfilePhoneError
                }
            }()
        )
    }

    private func buildEmail() -> some View {
        UpdateCurrentUserInputView(
            content: {
                HStack(spacing: 4) {
                    TextField(
                        text: $viewModel.email,
                        isEditing: $isNameEditing
                    )
                    .textFieldStyle(TappableTextFieldStyle())
                    .dynamicFont(.systemFont(ofSize: 16))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .introspectTextField { textField in
                        textField.becomeFirstResponder()
                    }

                    Button(
                        action: {
                            viewModel.email = ""
                        },
                        label: {
                            ImageAssets.icClose.swiftUIImage
                                .resizable()
                                .scaledToFit()
                                .padding(6)
                                .frame(width: 24, height: 24)
                                .border(ColorAssets.neutralDarkGrey.swiftUIColor, width: 1, cornerRadius: 12)
                        }
                    )
                }
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                .frame(height: 52)
            },
            title: L10n.updateProfileEmail,
            description: nil,
            isEditing: isEmailEditing,
            errorMessage: {
                if viewModel.email?.isEmpty ?? true || viewModel.email?.isValidEmail ?? true {
                    return nil
                } else {
                    return L10n.updateProfileEmailError
                }
            }()
        )
    }

    private func buildDateOfBirth() -> some View {
        UpdateCurrentUserInputView(
            content: {
                HStack(spacing: 4) {
                    Button(
                        action: {
                            keyboard.dismiss()
                            viewModel.fullScreenCoverType = .datePicker
                        },
                        label: {
                            Text(viewModel.dob?.string(withFormat: "yyyy/MM/dd") ?? "YYYY/MM/DD")
                                .dynamicFont(.systemFont(ofSize: 16))
                                .foregroundColor(
                                    viewModel.dob == nil
                                        ? ColorAssets.neutralDeepGrey.swiftUIColor
                                        : ColorAssets.neutralDarkGrey.swiftUIColor
                                )
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)

                    Button(
                        action: {
                            viewModel.dob = nil
                        },
                        label: {
                            ImageAssets.icClose.swiftUIImage
                                .resizable()
                                .scaledToFit()
                                .padding(6)
                                .frame(width: 24, height: 24)
                                .border(ColorAssets.neutralDarkGrey.swiftUIColor, width: 1, cornerRadius: 12)
                        }
                    )
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                }
                .frame(height: 52)
            },
            title: L10n.updateProfileDob,
            description: nil,
            isEditing: viewModel.fullScreenCoverType == .datePicker,
            errorMessage: nil
        )
    }

    private func buildGenderView() -> some View {
        VStack(spacing: 8) {
            Text(L10n.updateProfileGender)
                .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack(spacing: 12) {
                ForEach(GenderType.allCases.indices, id: \.self) { index in
                    buildGenderItemView(GenderType.allCases[index])
                }
            }
        }
        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
    }

    private func buildGenderItemView(_ gender: GenderType) -> some View {
        Button(
            action: {
                viewModel.gender = gender
            },
            label: {
                Text(gender.title)
                    .dynamicFont(.systemFont(ofSize: 14))
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                    .background(
                        viewModel.gender == gender
                            ? ColorAssets.primaryGreen200.swiftUIColor
                            : ColorAssets.neutralLight.swiftUIColor
                    )
                    .border(
                        viewModel.gender == gender
                            ? ColorAssets.primaryGreen200.swiftUIColor
                            : ColorAssets.neutralDarkGrey.swiftUIColor,
                        width: 1,
                        cornerRadius: 4
                    )
                    .cornerRadius(4)
            }
        )
    }

    private func buildActionView() -> some View {
        Button(
            "OK",
            action: {
                viewModel.validateUpdateCurrentUserAction.send()
            }
        )
        .buttonStyle(PrimaryButtonStyle())
        .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
    }
}

extension UpdateCurrentUserView {
    private func buildActionSheetDestinationView(
        _ type: UpdateCurrentUserActionSheetType
    ) -> ActionSheet {
        switch type {
        case .avatar:
            return ActionSheet(
                title: Text(L10n.updateProfileAvatar),
                buttons: [
                    .default(Text(L10n.updateProfileAvatarOpenCamera)) {
                        keyboard.dismiss()
                        viewModel.fullScreenCoverType = .imagePickerView(.camera)
                    },
                    .default(Text(L10n.updateProfileAvatarSelectPhoto)) {
                        keyboard.dismiss()
                        viewModel.fullScreenCoverType = .imagePickerView(.photoLibrary)
                    },
                    .cancel(Text(L10n.commonCancel))
                ]
            )
        }
    }

    @ViewBuilder
    private func buildFullScreenCoverDestinationView(
        _ type: Binding<UpdateCurrentUserFullScreenCoverType>
    ) -> some View {
        switch type.wrappedValue {
        case let .imagePickerView(sourceType):
            ImagePicker(image: $viewModel.image)
                .sourceType(sourceType)
                .allowsEditing(true)
                .introspectViewController {
                    switch sourceType {
                    case .photoLibrary, .savedPhotosAlbum:
                        break
                    case .camera:
                        $0.view.backgroundColor = .black
                    @unknown default:
                        break
                    }
                }
        case .selectCountry:
            NavigationView {
                SelectCountryView(
                    viewModel: SelectCountryViewModel(
                        selectedCountry: viewModel.country,
                        delegate: viewModel
                    )
                )
            }
            .navigationViewStyle(StackNavigationViewStyle())
        case .datePicker:
            buildDatePickerView()
        }
    }

    private func buildDatePickerView() -> some View {
        BottomSheet {
            VStack(spacing: 12) {
                NavigationBarView(
                    leadingView: {
                        Button(
                            action: {
                                viewModel.fullScreenCoverType = nil
                            },
                            label: {
                                Image(systemName: "xmark")
                                    .resizable()
                                    .frame(maxHeight: .infinity)
                                    .aspectRatio(1, contentMode: .fit)
                                    .padding(16)
                            }
                        )
                    },
                    centerView: {
                        Text(L10n.updateProfileDateOfBirth)
                            .dynamicFont(.systemFont(ofSize: 18, weight: .bold))
                    }
                )
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                .frame(height: 50)

                DatePicker(
                    "",
                    selection: Binding<Date>(
                        get: { viewModel.dob ?? Date() },
                        set: {
                            viewModel.dob = $0
                            viewModel.fullScreenCoverType = nil
                        }
                    ),
                    in: ...Date(),
                    displayedComponents: .date
                )
                .datePickerStyle(GraphicalDatePickerStyle())
            }
            .background(ColorAssets.neutralLight.swiftUIColor.ignoresSafeArea())
        }
    }
}

// MARK: - UpdateCurrentUserView_Previews

struct UpdateCurrentUserView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateCurrentUserView(viewModel: UpdateCurrentUserViewModel())
    }
}
