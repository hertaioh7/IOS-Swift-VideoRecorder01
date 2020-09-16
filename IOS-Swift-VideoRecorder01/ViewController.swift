import UIKit

import AVKit

import MobileCoreServices

class ViewController: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate {



    var videoAndImageReview = UIImagePickerController()

    var videoURL: URL?

    override func viewDidLoad() {

        super.viewDidLoad()

    }

    @IBAction func RecordAction(_ sender: UIButton) {

        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {

            print("Camera Available")

            let imagePicker = UIImagePickerController()

            imagePicker.delegate = self

            imagePicker.sourceType = .camera

            imagePicker.mediaTypes = [kUTTypeMovie as String]

            imagePicker.allowsEditing = true

            self.present(imagePicker, animated: true, completion: nil)

        } else {

            print("Camera UnAvaialable")

        }

    }

    func imagePickerController(_ picker: UIImagePickerController,

                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        dismiss(animated: true, completion: nil)

        guard

            let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String,

            mediaType == (kUTTypeMovie as String),

            let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL,

            UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(url.path)

            else {

                return

        }

        // Handle a movie capture

        UISaveVideoAtPathToSavedPhotosAlbum(

            url.path,

            self,

            #selector(video(_:didFinishSavingWithError:contextInfo:)),

            nil)

    }

    @objc func video(_ videoPath: String, didFinishSavingWithError error: Error?, contextInfo info: AnyObject) {

        let title = (error == nil) ? "Success" : "Error"

        let message = (error == nil) ? "Video was saved" : "Video failed to save"

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))

        present(alert, animated: true, completion: nil)

    }

    @IBAction func openImgVideoPicker() {

        videoAndImageReview.sourceType = .savedPhotosAlbum

        videoAndImageReview.delegate = self

        videoAndImageReview.mediaTypes = ["public.movie"]

        present(videoAndImageReview, animated: true, completion: nil)

    }

    func videoAndImageReview(_ picker: UIImagePickerController,

                             didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL

        print("videoURL:\(String(describing: videoURL))")

        self.dismiss(animated: true, completion: nil)

    }

}


