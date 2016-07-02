//
//  RegViewController.swift
//  Personal Financial Management
//
//  Created by chsun on 6/29/16.
//  Copyright © 2016 Chang Sun. All rights reserved.
//

import UIKit

class RegViewController: UIViewController {
    @IBOutlet weak var emailAddr: UITextField!
    @IBOutlet weak var pwdFirst: UITextField!
    @IBOutlet weak var pwdRepeat: UITextField!
    
    let serviceHandler = RESTService()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func regBtnClk(sender: UIButton) {
        
        //Prepare aler windown
        let altAction: UIAlertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        
        let pwdAlert:UIAlertController = UIAlertController(title: "Please Attention", message: "Password can't be blank", preferredStyle:.Alert)
        pwdAlert.addAction(altAction)
        
        //E-mail validtion
        if((nil == emailAddr.text) || emailAddr.text!.isEmpty){
            pwdAlert.message = "Please input email address"
            presentViewController(pwdAlert, animated: true, completion: nil)
            return
        }
        
        //Password validation
        if ((nil == pwdFirst.text) || pwdFirst.text!.isEmpty){
            self.presentViewController(pwdAlert, animated: true, completion: nil)
            return
        }
        else if(pwdFirst.text != pwdRepeat.text){
            pwdAlert.message = "Passwords are not same"
            presentViewController(pwdAlert, animated: true, completion: nil)
            return
        }

        serviceHandler.regNewUser(emailAddr.text!, pwd: pwdFirst!.text!)
        
        //Switch back to the login window is sign-up succeeds
        let storyBoard = UIStoryboard(name: "Main" , bundle: nil);
        let logViewController = storyBoard.instantiateViewControllerWithIdentifier("logWindow")
        self.presentViewController(logViewController, animated: true, completion: nil)
    }
}
