//
//  ElegirUsuarioViewController.swift
//  Snapchat
//
//  Created by Elvis Quecara Cruz on 18/11/23.
//

import UIKit
import Firebase


class ElegirUsuarioViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    
    
   

    @IBOutlet weak var listaUsuarios: UITableView!
    
    
    
    var usuarios:[Usuario] = []
    var imagenURL = ""
    var descrip = ""
    var imagenID = ""
    var audioname = ""
    var audioURL: URL?
    
    
    
    override func viewDidLoad() {
        print("ElegirUsuarioViewController - viewDidLoad")
        super.viewDidLoad()
        listaUsuarios.delegate = self
        listaUsuarios.dataSource = self
        Database.database().reference().child("usuario").observe(DataEventType.childAdded,
            with: {(snapshot) in
                print(snapshot)
            
        let usuario = Usuario()
            usuario.email = (snapshot.value as! NSDictionary)["email" ] as! String
            usuario.uid = snapshot.key
            self.usuarios.append(usuario)
            self.listaUsuarios.reloadData()
        }
        )

        // Do any additional setup after loading the view.
    }
    
   

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Número de filas: \(usuarios.count)")
        return usuarios.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        
        let user = usuarios[indexPath.row]
        cell.textLabel?.text =  user.email
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let usuario = usuarios[indexPath.row]
        
        
        
        
        let snap = ["from": Auth.auth().currentUser?.email, "descripcion": descrip, "imagenURL": imagenURL, "imagenID" : imagenID, "nameaudio": audioname,  "audioURL": audioURL?.absoluteString]
        
        
        Database.database().reference().child("usuario").child(usuario.uid).child("snaps")
            .childByAutoId().setValue(snap)
        navigationController?.popViewController(animated: true)
    }
   
   
    
    

}
