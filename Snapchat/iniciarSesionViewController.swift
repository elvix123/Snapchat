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
    
    
    
    
        

    

    
        
    
    
   
    
    
    

