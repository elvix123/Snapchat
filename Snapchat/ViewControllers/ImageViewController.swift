// ImageViewController.swift

import UIKit
import FirebaseStorage
import AVFoundation

class ImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imagePicker = UIImagePickerController()
    
    var imagenID = NSUUID().uuidString
    
    var grabarAudio: AVAudioRecorder?
    
    var reproducirAudio: AVAudioPlayer?
    
    var audioURL: URL?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descripcionTextField: UITextField!
    @IBOutlet weak var elegirContactoBoton: UIButton!
    @IBOutlet weak var grabarButton: UIButton!
    @IBOutlet weak var audioTextField: UITextField!
    @IBOutlet weak var reproducirButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        elegirContactoBoton.isEnabled = false
        configurarGrabacion()
        reproducirButton.isEnabled = false
    }
    
    func configurarGrabacion() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: [])
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            
            let basePath: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponents = [basePath, "audio.m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
            
            print("*******************")
            print(audioURL!)
            print("*******************")
            
            var settings: [String: AnyObject] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject?
            settings[AVSampleRateKey] = 44100.0 as AnyObject?
            settings[AVNumberOfChannelsKey] = 2 as AnyObject?
            
            grabarAudio = try AVAudioRecorder(url: audioURL!, settings: settings)
            grabarAudio!.prepareToRecord()
        } catch let error as NSError {
            print(error)
        }
    }
    
    @IBAction func grabarTapped(_ sender: Any) {
        if grabarAudio!.isRecording {
            grabarAudio?.stop()
            grabarButton.setTitle("GRABAR", for: .normal)
            reproducirButton.isEnabled = true
        } else {
            grabarAudio?.record()
            grabarButton.setTitle("DETENER", for: .normal)
            reproducirButton.isEnabled = false
        }
    }
    
    @IBAction func reproducirTapped(_ sender: Any) {
        do {
            try reproducirAudio = AVAudioPlayer(contentsOf: audioURL!)
            reproducirAudio!.play()
            print("Reproduciendo")
        } catch {
            // Handle audio playback error
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            imageView.backgroundColor = UIColor.clear
            elegirContactoBoton.isEnabled = true
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func camaraTapped(_ sender: Any) {
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func elegirContactoTapped(_ sender: Any) {
        self.elegirContactoBoton.isEnabled = false
        
        guard let image = imageView.image,
              let imageData = image.jpegData(compressionQuality: 0.50) else {
            // Handle error: Unable to get image or image data
            return
        }

        let imagenesFolder = Storage.storage().reference().child("imagenes")
        let cargarImagen = imagenesFolder.child("\(imagenID).jpg")
        
        cargarImagen.putData(imageData, metadata: nil) { (metadata, error) in
            if error != nil {
                // Handle image upload error
                self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al subir la imagen. Verifique su conexión a internet y vuelva a intentarlo", accion: "Aceptar")
                self.elegirContactoBoton.isEnabled = true
                return
            } else {
                cargarImagen.downloadURL { (url, error) in
                    guard let imagenURL = url else {
                        // Handle image URL retrieval error
                        self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al obtener la información de la imagen", accion: "Cancelar")
                        self.elegirContactoBoton.isEnabled = true
                        return
                    }
                    
                    // Update the audioURL property before uploading audio
                    self.uploadAudio(imagenURL: imagenURL)
                }
            }
        }
    }
    
    func uploadAudio(imagenURL: URL) {
        guard let audioUrl = audioURL else {
            return
        }
        
        let audiosFolder = Storage.storage().reference().child("audios")
        let audioData = try? Data(contentsOf: audioUrl)
        let uploadAudio = audiosFolder.child("\(imagenID).m4a")
        
        uploadAudio.putData(audioData!, metadata: nil) { (metadata, error) in
            if let error = error {
                // Handle audio upload error
                self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al subir el audio. Verifique su conexión a internet y vuelva a intentarlo", accion: "Aceptar")
                return
            } else {
                uploadAudio.downloadURL { (url, error) in
                    guard let audioDownloadURL = url else {
                        // Handle audio URL retrieval error
                        self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al obtener la URL del audio", accion: "Aceptar")
                        return
                    }
                    
                    // Call the function to perform segue with the obtained audio URL
                    self.performSegue(withIdentifier: "seleccionarContactoSegue", sender: (imagenURL, audioDownloadURL))
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seleccionarContactoSegue" {
            let siguienteVC = segue.destination as! ElegirUsuarioViewController
            
            if let (imagenURL, audioURL) = sender as? (URL, URL) {
                siguienteVC.imagenURL = imagenURL.absoluteString
                siguienteVC.descrip = descripcionTextField.text!
                siguienteVC.audioname = audioTextField.text!
                siguienteVC.imagenID = imagenID
                siguienteVC.audioURL = audioURL
            }
        }
    }
    
    func mostrarAlerta(titulo: String, mensaje: String, accion: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let btnCANCELOK = UIAlertAction(title: accion, style: .default, handler: nil)
        alerta.addAction(btnCANCELOK)
        present(alerta, animated: true, completion: nil)
    }
}
