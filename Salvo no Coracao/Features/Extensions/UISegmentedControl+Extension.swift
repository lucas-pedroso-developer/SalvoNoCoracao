//
//  UISegmentedControl+Extension.swift
//  Salvo no Coracao
//
//  Created by Lucas Pedroso on 29/11/25.
//

import SwiftUI

extension UISegmentedControl {
    static func applyBlueTint() {
        let appearance = UISegmentedControl.appearance()
        appearance.selectedSegmentTintColor = UIColor.systemBlue
        appearance.setTitleTextAttributes(
            [.foregroundColor: UIColor.white],
            for: .selected
        )
        appearance.setTitleTextAttributes(
            [.foregroundColor: UIColor.systemBlue],
            for: .normal
        )
    }
}
