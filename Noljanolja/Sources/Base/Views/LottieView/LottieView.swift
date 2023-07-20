//
//  LottieView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 02/04/2023.
//

import Lottie
import SwiftUI

// MARK: - LottieView

struct LottieView: UIViewRepresentable {
    private(set) var animation: LottieAnimation?
    @Binding var isPlay: Bool
    @Binding var contentMode: UIView.ContentMode
    @Binding var loopMode: LottieLoopMode

    private let animationView = LottieAnimationView()

    init(animation: LottieAnimation? = nil,
         isPlay: Binding<Bool> = .constant(true),
         contentMode: Binding<UIView.ContentMode> = .constant(.scaleAspectFit),
         loopMode: Binding<LottieLoopMode> = .constant(.loop)) {
        self.animation = animation
        self._isPlay = isPlay
        self._contentMode = contentMode
        self._loopMode = loopMode
    }

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)

        animationView.animation = animation
        animationView.contentMode = contentMode
        animationView.loopMode = loopMode

        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        if isPlay {
            animationView.play()
        } else {
            animationView.stop()
        }
    }
}

// MARK: - LottieView_Previews

struct LottieView_Previews: PreviewProvider {
    static var previews: some View {
        LottieView(animation: nil, isPlay: .constant(true))
    }
}
