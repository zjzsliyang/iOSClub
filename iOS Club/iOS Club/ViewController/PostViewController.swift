//
//  PostViewController.swift
//  iOS Club
//
//  Created by Yang Li on 2018/9/22.
//  Copyright © 2018 Yang LI. All rights reserved.
//

import UIKit
import AVKit
import Gallery
import Lightbox
import AVFoundation
import SVProgressHUD

class PostViewController: UIViewController, GalleryControllerDelegate, LightboxControllerDismissalDelegate {
    
    @IBOutlet weak var postTextField: UITextField!
    @IBOutlet weak var selectedCollectionView: UICollectionView!
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var button: UIButton!
    var gallery: GalleryController!
    let editor: VideoEditing = VideoEditor()
    var selectedImages = [Image]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        Gallery.Config.VideoEditor.savesEditedVideoToLibrary = true
        Gallery.Config.Camera.imageLimit = 6
        
        button = UIButton(type: .system)
        button.frame.size = CGSize(width: 200, height: 50)
        button.setTitle("Open Gallery", for: UIControlState())
        button.addTarget(self, action: #selector(buttonTouched(_:)), for: .touchUpInside)
        
        view.addSubview(button)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        button.center = CGPoint(x: view.bounds.size.width/2, y: 320)
    }
    
    @objc func buttonTouched(_ button: UIButton) {
        gallery = GalleryController()
        gallery.delegate = self
        
        present(gallery, animated: true, completion: nil)
    }
    
    // MARK: - LightboxControllerDismissalDelegate
    
    func lightboxControllerWillDismiss(_ controller: LightboxController) {
        
    }
    
    // MARK: - GalleryControllerDelegate
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
        gallery = nil
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        controller.dismiss(animated: true, completion: nil)
        gallery = nil
        
        
        editor.edit(video: video) { (editedVideo: Video?, tempPath: URL?) in
            DispatchQueue.main.async {
                if let tempPath = tempPath {
                    let controller = AVPlayerViewController()
                    controller.player = AVPlayer(url: tempPath)
                    
                    self.present(controller, animated: true, completion: nil)
                }
            }
        }
    }
    
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        selectedImages = images
        selectedCollectionView.reloadData()
        controller.dismiss(animated: true, completion: nil)
        gallery = nil
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        LightboxConfig.DeleteButton.enabled = true
        
        SVProgressHUD.show()
        Image.resolve(images: images, completion: { [weak self] resolvedImages in
            SVProgressHUD.dismiss()
            self?.showLightbox(images: resolvedImages.compactMap({ $0 }))
        })
    }
    
    // MARK: - Helper
    
    func showLightbox(images: [UIImage]) {
        guard images.count > 0 else {
            return
        }
        
        let lightboxImages = images.map({ LightboxImage(image: $0) })
        let lightbox = LightboxController(images: lightboxImages, startIndex: 0)
        lightbox.dismissalDelegate = self
        
        gallery.present(lightbox, animated: true, completion: nil)
    }
}


extension PostViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = selectedCollectionView.dequeueReusableCell(withReuseIdentifier: "selected", for: indexPath) as! SelectedCell
        selectedImages[indexPath.item].resolve { (image) in
            cell.setSelectedImage(selectedImage: image!)
        }
        return cell
    }
    
}
