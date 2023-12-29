//
//  View.swift
//  SwiftUITemplate
//
//  Created by apple on 17/04/2023.
//

import SwiftUI
extension View {
    func navigationBar(@ViewBuilder leading: @escaping () -> some View,
                       @ViewBuilder middle: @escaping () -> some View,
                       @ViewBuilder trailing: @escaping () -> some View) -> some View {
        modifier(ViewWithNavigationBar(leading: leading, middle: middle, trailing: trailing))
    }

    func navigationBar(@ViewBuilder leading: @escaping () -> some View,
                       @ViewBuilder middle: @escaping () -> some View,
                       @ViewBuilder trailing: @escaping () -> some View,
                       backgroundColor: Color = .white) -> some View {
        modifier(ViewWithNavigationBar(leading: leading, middle: middle, trailing: trailing, backgroundColor: backgroundColor))
    }

    func navigationBar(title: String) -> some View {
        navigationBar(
            leading: { EmptyView() },
            middle: {
                Text(title)
                    .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
            },
            trailing: { EmptyView() }
        )
    }

    func size(_ size: CGFloat) -> some View {
        frame(width: size, height: size)
    }

    func navigationBar(title: String,
                       isLeadingIcon: Bool = true,
                       isPresent: Bool = false,
                       backButtonTitle: String,
                       presentationMode: Binding<PresentationMode>,
                       @ViewBuilder trailing: @escaping () -> some View,
                       backgroundColor: Color = .white) -> some View {
        navigationBar(
            leading: { Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                isLeadingIcon ? HStack(spacing: 4) {
                    Image(systemName: isPresent ? "xmark" : "arrow.left")
                        .scaleEffect(1.2)
                        .foregroundColor(ColorAssets.neutralRawDarkGrey.swiftUIColor)
                    Text(backButtonTitle)
                } : nil
            }
            .buttonStyle(PlainButtonStyle())
            },
            middle: {
                Text(title)
                    .foregroundColor(ColorAssets.neutralRawDarkGrey.swiftUIColor)
                    .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
            },
            trailing: {
                trailing()
            },
            backgroundColor: backgroundColor
        )
    }

    func navigationBar(backButtonTitle: String,
                       isPresent: Bool = false,
                       presentationMode: Binding<PresentationMode>,
                       @ViewBuilder middle: @escaping () -> some View,
                       @ViewBuilder trailing: @escaping () -> some View) -> some View {
        navigationBar {
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: isPresent ? "xmark" : "arrow.left")
                        .scaleEffect(1.2)
                        .foregroundColor(ColorAssets.neutralRawDarkGrey.swiftUIColor)
                    Text(backButtonTitle)
                }
            }
            .buttonStyle(PlainButtonStyle())
        } middle: {
            middle()
        } trailing: {
            trailing()
        }
    }

    func navigation<Item>(item: Binding<Item?>,
                          isAdditionalSwipeBack: Bool = true,
                          @ViewBuilder destination: (Item) -> some View) -> some View {
        let isActive = Binding(
            get: { item.wrappedValue != nil },
            set: { value in
                if !value {
                    item.wrappedValue = nil
                }
            }
        )
        return navigation(isActive: isActive, isAdditionalSwipeBack: isAdditionalSwipeBack) {
            item.wrappedValue.map(destination)
        }
    }

    func navigation(isActive: Binding<Bool>,
                    isAdditionalSwipeBack: Bool = true,
                    @ViewBuilder destination: () -> some View) -> some View {
        overlay(
            NavigationLink(
                destination: isActive.wrappedValue ? destination().addSwipeBack(canDismiss: isAdditionalSwipeBack) : nil,
                isActive: isActive,
                label: { EmptyView() }
            )
        )
    }

    func onSwipeBackGesture(swipeRight: @escaping () -> Void = {}) -> some View {
        simultaneousGesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width > 0, abs(value.translation.height) < 30, value.startLocation.x < CGFloat(50) {
                        swipeRight()
                    }
                }
        )
    }

    func addSwipeBack(canDismiss: Bool = true, action: @escaping () -> Void = {}) -> some View {
        DestinationView(content: {
            self
        }, action: {
            action()
        }, canDismiss: canDismiss)
    }

    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// MARK: - DestinationView

struct DestinationView<T: View>: View {
    @Environment(\.presentationMode) var presentationMode
    var content: () -> T
    var action: () -> Void
    var canDismiss: Bool
    var body: some View {
        content().onSwipeBackGesture {
            action()
            if canDismiss {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

public extension View {
    func gradientForeground(colors: [Color]) -> some View {
        overlay(
            LinearGradient(
                colors: colors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .mask(self)
    }
}
