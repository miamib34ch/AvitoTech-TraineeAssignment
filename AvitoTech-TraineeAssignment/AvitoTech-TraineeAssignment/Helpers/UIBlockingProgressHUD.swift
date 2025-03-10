//
//  UIBlockingProgressHUD.swift
//  AvitoTech-TraineeAssignment
//
//  Created by Богдан Полыгалов on 30.08.2023.
//

import UIKit
import ProgressHUD

enum UIBlockingProgressHUD {
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }

    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.show()
    }

    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}
