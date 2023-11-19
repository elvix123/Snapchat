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
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
