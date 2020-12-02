//
//  AboutRouter.swift
//  FactorioHelper
//
//  Created by Sergey Vasilenko on 29.11.2020.
//  Copyright © 2020 kudrykun. All rights reserved.
//

import UIKit
import MessageUI

class AboutRouter: NSObject, AboutRouterProtocol {
    weak var view: UIViewController?

    func openFeedbackMail(to email: String, subject: String, text: String) {
        if MFMailComposeViewController.canSendMail() {
            let vc = MFMailComposeViewController()
            vc.mailComposeDelegate = self
            vc.setToRecipients([email])
            vc.setMessageBody(text, isHTML: false)
            vc.setSubject(subject)

            view?.navigationController?.present(vc, animated: true)
        } else {
            // show failure alert
        }
    }
}

extension AboutRouter: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
