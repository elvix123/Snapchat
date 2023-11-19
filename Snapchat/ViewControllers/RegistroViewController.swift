//
//  RegistroViewController.swift
//  Snapchat
//
//  Created by Elvis Quecara Cruz on 18/11/23.
//

import UIKit
import Firebase

class RegistroViewController: UIViewController {

    @IBOutlet weak var crearusuarioTextField: UITextField!
    @IBOutlet weak var crearcontraseñaTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func volverinicioTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "volveriniciosegue", sender: nil)
    }

    @IBAction func crearusuarioTapped(_ sender: Any) {
        Auth.auth().createUser(withEmail: crearusuarioTextField.text!, password: crearcontraseñaTextField.text!, completion: { (user, error) in
            print("Intentando crear un usuario")
            if let error = error {
                print("Se presento un error: \(error.localizedDescription)")
                
                // Mostrar una alerta en caso de error al crear el usuario
                let alert = UIAlertController(title: "Error al crear usuario", message: error.localizedDescription, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                
            } else {
                print("El usuario fue creado exitosamente")
                
                Database.database().reference().child("usuario").child(user!.user.uid).child("email").setValue(user!.user.email)
                
                // Mostrar una alerta en caso de éxito al crear el usuario
                let alert = UIAlertController(title: "Usuario creado", message: "¡Registro exitoso!", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                    // Volver a la pantalla anterior
                    self.performSegue(withIdentifier: "volveriniciosegue", sender: nil)
                })
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
}
