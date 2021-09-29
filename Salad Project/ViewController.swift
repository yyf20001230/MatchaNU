//
//  ViewController.swift
//  Salad Project
//
//  Created by Yunfan Yang on 9/28/21.
//

import UIKit
import MessageUI

class ViewController: UIViewController, MFMailComposeViewControllerDelegate{
    
    override func viewDidLoad(){
        super.viewDidLoad()
        print(0)
        let Button = UIButton(frame: CGRect(x : 0, y : 0, width: 220, height: 50))
        view.addSubview(Button)
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["you@yoursite.com"])
            mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)

            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }

}

