//
//  ViewController.swift
//  Snapchat
//
//  Created by Elvis Quecara Cruz on 7/11/23.
//

import UIKit
import FirebaseAuth

class  iniciarSesionViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func iniciarSesionTapped(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text! ){(user, error) in
            print("Intentado Iniciar Sesion")
            if error != nil{
                print("Se presento el siguiente error: \(error)")
            }else{
                print("Inicio de sesion exitoso")
            }
        }
    }
    
    
}

