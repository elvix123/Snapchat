import UIKit
import SDWebImage
import Firebase
import FirebaseStorage
import AVFoundation

class VerSnapViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblMensaje: UILabel!

    var snap = Snap()
    var audioPlayer: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        lblMensaje.text = "Mensaje: " + snap.descrip

        // Load the image using SDWebImage
        if let imageUrl = URL(string: snap.imagenURL) {
            imageView.sd_setImage(with: imageUrl, completed: nil)
        }

        // Load audio data asynchronously
        if let audioURL = URL(string: snap.audioURL) {
            DispatchQueue.global().async {
                do {
                    let audioData = try Data(contentsOf: audioURL)
                    DispatchQueue.main.async {
                        self.audioPlayer = try? AVAudioPlayer(data: audioData)
                    }
                } catch {
                    print("Error loading audio data: \(error.localizedDescription)")
                }
            }
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        // Remove snap from the database
        if let currentUserUID = Auth.auth().currentUser?.uid {
            Database.database().reference().child("usuario").child(currentUserUID).child("snaps").child(snap.id).removeValue()
        }

        // Delete image from storage
        let imageRef = Storage.storage().reference().child("imagenes").child("\(snap.imagenID).jpg")
        imageRef.delete { error in
            if let error = error {
                print("Error deleting image: \(error.localizedDescription)")
            } else {
                print("Image deleted successfully")
            }
        }

        // Stop and release audio player
        audioPlayer?.stop()
        audioPlayer = nil
    }

    @IBAction func reproducirAudioTapped(_ sender: Any) {
        // Check if audioPlayer is not nil and is not currently playing
        if let audioPlayer = audioPlayer, !audioPlayer.isPlaying {
            do {
                try audioPlayer.play()
            } catch {
                print("Error playing audio: \(error.localizedDescription)")
            }
        }
    }
}
