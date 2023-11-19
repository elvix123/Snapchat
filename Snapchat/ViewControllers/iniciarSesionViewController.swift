import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

import UIKit
import FirebaseAuth
import GoogleSignIn
import Firebase



class iniciarSesionViewController: UIViewController{

    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func iniciarSesionTapped(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!)
        { (user, error) in print("Intentado Iniciar Sesion")
            if error != nil{
                let alert = UIAlertController(title: "Error de Inicio de Sesión", message: "Debe crear primero una cuenta.", preferredStyle: .alert)

                           // Create button to navigate to the registration screen
                           let createAction = UIAlertAction(title: "Crear", style: .default) { (_) in
                               self.performSegue(withIdentifier: "registrarusuariosegue", sender: nil)
                           }
                           alert.addAction(createAction)

                           // Create cancel button to dismiss the alert
                           let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
                           alert.addAction(cancelAction)

                           // Present the alert
                           self.present(alert, animated: true, completion: nil)
            }else{
                print("Inicio de Sesion Exitoso")
                self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
            }
            
        }
    }
    
    @IBAction func signInButton(_ sender: Any) {
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            guard error == nil else {
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                return
            }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            Auth.auth().signIn(with: credential) { result, error in
                if let error = error {
                    
                    print("Error al iniciar sesión con Google: \(error.localizedDescription)")
                    
                } else {
                    
                    print("Inicio de sesión exitoso con Google")
                }
            }
            
        }
    }
}
    
    
    
    
        

    

    
        
    
    
   
    
    
    

