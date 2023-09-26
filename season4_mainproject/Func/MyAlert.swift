//
//  DefaultAlert.swift
//  Ethan's TodoList
//
//  Created by TJ on 2023/08/28.
//

import Foundation
import UIKit

class MyAlert{
    func showDefaultAlert(on viewController: UIViewController, content: String) {
        let resultAlert = UIAlertController(title: "결과", message: content, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "네", style: .default)
        
        resultAlert.addAction(okAction)
        viewController.present(resultAlert, animated: true)
    }
    
    func showPopAlert(on viewController: UIViewController, content: String) {
        let resultAlert = UIAlertController(title: "결과", message: content, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "네", style: .default, handler: {ACTION in
            viewController.navigationController?.popViewController(animated: true)
        })
        resultAlert.addAction(okAction)
        viewController.present(resultAlert, animated: true)
    }
    
    func showSegAlert(on viewController: UIViewController, content: String, seg: String) {
        let resultAlert = UIAlertController(title: "결과", message: content, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "네", style: .default, handler: {ACTION in
            viewController.performSegue(withIdentifier: seg, sender: nil)
        })
        resultAlert.addAction(okAction)
        viewController.present(resultAlert, animated: true)
    }
    
    func showMoveTabAlert(on viewController: UIViewController, content: String, index: Int) {
        let resultAlert = UIAlertController(title: "결과", message: content, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "네", style: .default, handler: {ACTION in
            if let tabBarController = viewController.tabBarController {
                tabBarController.selectedIndex = index
            }

        })
        resultAlert.addAction(okAction)
        viewController.present(resultAlert, animated: true)
    }

}

