//
//  ResetPasswordView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 08/02/2023.
//  
//

import SwiftUI

struct ResetPasswordView: View {
    @StateObject private var viewModel: ResetPasswordViewModel

    init(viewModel: ResetPasswordViewModel = ResetPasswordViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView()
    }
}
