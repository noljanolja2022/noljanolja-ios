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
import SwiftUIX

// MARK: - UpdateCurrentUserView

struct UpdateCurrentUserView<ViewModel: UpdateCurrentUserViewModel>: View {
    // MARK: Dependencies
    
    @StateObject var viewModel: ViewModel
    
    // MARK: State

    @EnvironmentObject private var progressHUBState: ProgressHUBState

    @StateObject private var keyboard = Keyboard.main

    @State private var isNameEditing = false
    
    private let nameMaxLength = 20

    var body: some View {
        buildBodyView()
    }
    
    private func buildBodyView() -> some View {
        buildContentView()
            .navigationBarTitle("", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Update Profile")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                }
            }
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
            .onChange(of: viewModel.isProgressHUDShowing) {
                progressHUBState.isLoading = $0
            }
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
                $viewModel.image,
                then: {
                    Image(uiImage: $0.wrappedValue)
                        .resizable()
                },
                else: {
                    KFImage(URL(string: viewModel.avatar))
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
    
    private func buildNameView() -> some View {
        VStack(spacing: 0) {
            Text("Name")
                .font(.system(size: 12))
                .foregroundColor(
                    isNameEditing
                        ? ColorAssets.primaryMain.swiftUIColor
                        : ColorAssets.neutralDeepGrey.swiftUIColor
                )
                .frame(maxWidth: .infinity, alignment: .leading)
            
            TextField(
                "Name",
                text: $viewModel.name.max(nameMaxLength),
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
                        ? ColorAssets.primaryMain.swiftUIColor
                        : ColorAssets.neutralDeepGrey.swiftUIColor
                )
            
            HStack(spacing: 0) {
                Text("Required")
                Spacer()
                Text("\(viewModel.name?.count ?? 0)/\(nameMaxLength)")
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
                action: {
                    keyboard.dismiss()
                    viewModel.fullScreenCoverType = .datePicker
                },
                label: {
                    buildDateOfBirth()
                }
            )
            
            Button(
                action: {
                    viewModel.actionSheetType = .gender
                },
                label: {
                    buildGenderView()
                }
            )
        }
    }
    
    private func buildDateOfBirth() -> some View {
        VStack {
            HStack(spacing: 16) {
                Text(
                    viewModel.dob?.string(withFormat: "dd/MM/yyyy")
                        ?? "Day of Birth"
                )
                .font(.system(size: 16))
                .foregroundColor(
                    viewModel.fullScreenCoverType == .datePicker
                        ? ColorAssets.primaryMain.swiftUIColor
                        : viewModel.dob != nil
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
                viewModel.dob != nil
                    ? ColorAssets.neutralDarkGrey.swiftUIColor
                    : ColorAssets.neutralDeepGrey.swiftUIColor
            )
            .frame(height: 38)
            .padding(.horizontal, 16)
            
            Divider()
                .frame(height: 2)
                .overlay(
                    viewModel.fullScreenCoverType == .datePicker
                        ? ColorAssets.primaryMain.swiftUIColor
                        : viewModel.dob != nil
                        ? ColorAssets.neutralDarkGrey.swiftUIColor
                        : ColorAssets.neutralDeepGrey.swiftUIColor
                )
        }
    }
    
    private func buildGenderView() -> some View {
        VStack {
            HStack(spacing: 16) {
                Text(
                    viewModel.gender?.rawValue.lowercased().capitalized
                        ?? "Gender"
                )
                .font(.system(size: 16))
                .foregroundColor(
                    viewModel.actionSheetType == .gender
                        ? ColorAssets.primaryMain.swiftUIColor
                        : viewModel.gender != nil
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
                viewModel.dob != nil
                    ? ColorAssets.neutralDarkGrey.swiftUIColor
                    : ColorAssets.neutralDeepGrey.swiftUIColor
            )
            .frame(height: 38)
            .padding(.horizontal, 16)
            
            Divider()
                .frame(height: 2)
                .overlay(
                    viewModel.actionSheetType == .gender
                        ? ColorAssets.primaryMain.swiftUIColor
                        : viewModel.gender != nil
                        ? ColorAssets.neutralDarkGrey.swiftUIColor
                        : ColorAssets.neutralDeepGrey.swiftUIColor
                )
        }
    }
    
    private func buildActionView() -> some View {
        Button(
            "OK",
            action: {
                viewModel.validateUpdateCurrentUserAction.send()
            }
        )
        .buttonStyle(PrimaryButtonStyle())
    }

    private func buildActionSheetDestinationView(
        _ type: UpdateCurrentUserActionSheetType
    ) -> ActionSheet {
        switch type {
        case .avatar:
            return ActionSheet(
                title: Text("Set Avatar"),
                buttons: [
                    .default(Text("Open Camera")) {
                        keyboard.dismiss()
                        viewModel.fullScreenCoverType = .imagePickerView(.camera)
                    },
                    .default(Text("Select Photo")) {
                        keyboard.dismiss()
                        viewModel.fullScreenCoverType = .imagePickerView(.photoLibrary)
                    },
                    .cancel(Text("Cancel"))
                ]
            )
        case .gender:
            return ActionSheet(
                title: Text("Gender"),
                buttons: [
                    .default(Text("Male")) { viewModel.gender = .male },
                    .default(Text("Female")) { viewModel.gender = .female },
                    .default(Text("Other")) { viewModel.gender = .other },
                    .cancel(Text("Cancel"))
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
                                    .aspectRatio(CGSize(width: 1, height: 1), contentMode: .fit)
                                    .padding(16)
                            }
                        )
                    },
                    centerView: {
                        Text("Date of birth")
                            .font(.system(size: 18, weight: .bold))
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
        }
    }
}

// MARK: - UpdateCurrentUserView_Previews

struct UpdateCurrentUserView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateCurrentUserView(viewModel: UpdateCurrentUserViewModel())
    }
}
