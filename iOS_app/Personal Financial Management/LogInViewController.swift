//
//  ViewController.swift
//  Personal Financial Management
//
//  Created by chsun on 6/25/16.
//  Copyright © 2016 Chang Sun. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {
    @IBOutlet weak var idField: UITextField!
    @IBOutlet weak var pwdField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func loginBttnClk(_ sender: UIButton) {
        let logControl: RESTService = RESTService()
        if(idField.text!.isEmpty || pwdField.text!.isEmpty){
            print("The inputs are missing")
        }
        else{
            logControl.loginVerify(idField.text!, pwd:pwdField.text!)
            print("Button clicked")
        }
    }

    @IBAction func switchRegistrationView(_ sender: UIButton) {
        let stroyBoard = UIStoryboard(name: "Main" , bundle: nil);
        let regView = stroyBoard.instantiateViewController(withIdentifier: "regView")
        self.present(regView, animated: true, completion: nil)
    }
    
    

}

