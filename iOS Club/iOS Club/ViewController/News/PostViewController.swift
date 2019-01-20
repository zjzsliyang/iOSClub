//
//  PostViewController.swift
//  Student Club
//
//  Created by Yang Li on 2018/9/22.
//  Copyright © 2018 Yang LI. All rights reserved.
//

import UIKit
import AVKit
import Gallery
import Lightbox
import BMPlayer
import Alamofire
import SwiftyJSON
import AVFoundation
import SVProgressHUD
import NotificationBannerSwift

class PostViewController: UIViewController, GalleryControllerDelegate, LightboxControllerDismissalDelegate, UITextViewDelegate {
    
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var selectedCollectionView: UICollectionView!
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? EmbedPostInfoTableViewController,
            segue.identifier == "postinfo" {
            vc.delegate = self
        }
    }
    
    func uploadPost(postImages: [UIImage], postVideo: URL?, email: String, title: String, content: String, news_privilege: Int, tags: [String]) {
        
        let parameters = [
            "user_email": email,
            "title": title,
            "content": content,
            "news_privilege": String(describing: news_privilege),
            "tags": tags.description,
            "iov": postVideo == nil ? "0": "1"
        ]

        Alamofire.upload(multipartFormData: { multipartFormData in
            if postVideo != nil {
                do {
                    let videoData = try Data(contentsOf: postVideo!)
                    multipartFormData.append(videoData, withName: "files", fileName: (postVideo?.absoluteString)!, mimeType: "video/mp4")
                } catch {
                    log.error("convert video to data error")
                }
            } else {
                for image in postImages {
                    let imgData = image.jpegData(compressionQuality: 1)
                    multipartFormData.append(imgData!, withName: "files", fileName: String(describing: postImages.firstIndex(of: image)) + ".jpg", mimeType: "image/jpg")
                }
            }
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to: backendUrl + "/news/publish"){ (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseString(completionHandler: { (response) in
                    if response.result.value == nil {
                        let banner = NotificationBanner(title: "Post Fail", subtitle: "Time Out", style: .danger)
                        banner.show()
                    }
                    let responseData = response.result.value!
                    do {
                        let responseJson = try JSON(data: responseData.data(using: String.Encoding.utf8)!)
                        if responseJson["code"] == 0 {
                            let banner = NotificationBanner(title: "Post Success", subtitle: nil, style: .success)
                            banner.show()
                        } else {
                            let banner = NotificationBanner(title: "Post Fail", subtitle: responseJson["msg"].rawString(), style: .danger)
                            banner.show()
                        }
                    } catch let error as NSError {
                        log.error(error)
                    }
                })
            case .failure(let encodingError):
                log.error("upload post encoding error: " + String(describing: encodingError))
            }
        }
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        if postTextView.textColor != UIColor.lightGray {
            let suiteDefault = UserDefaults.init(suiteName: groupIdentifier)
            let email = suiteDefault!.value(forKey: "email") as! String
            var postImages = [UIImage]()
            for selectedImage in selectedImages {
                selectedImage.resolve { (image) in
                    postImages.append(image!)
                    if postImages.count == self.selectedImages.count {
                        self.uploadPost(postImages: postImages, postVideo: self.selectedVideo, email: email, title: self.postTitle, content: self.postTextView.text!, news_privilege: self.postPrivilege, tags: self.postTags)
                    }
                }
            }
            if selectedImages.count == 0 {
                self.uploadPost(postImages: postImages, postVideo: selectedVideo, email: email, title: self.postTitle, content: self.postTextView.text!, news_privilege: self.postPrivilege, tags: self.postTags)
            }
        }

        self.dismiss(animated: true, completion: nil)
    }
    
    var button: UIButton!
    var gallery: GalleryController!
    let editor: VideoEditing = VideoEditor()
    var postTitle = ""
    var postTags = [String]()
    var postPrivilege = 0
    var selectedImages = [Image]()
    let videoplayer = BMPlayer()
    var selectedVideo: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        Gallery.Config.VideoEditor.savesEditedVideoToLibrary = false
        Gallery.Config.VideoEditor.maximumDuration = 30
        Gallery.Config.Camera.imageLimit = 6
        
        button = UIButton(type: .system)
        button.frame.size = CGSize(width: 200, height: 50)
        button.setTitle("Open Gallery", for: UIControl.State())
        button.addTarget(self, action: #selector(buttonTouched(_:)), for: .touchUpInside)
        
        postTextView.text = "Content from here..."
        postTextView.textColor = UIColor.lightGray
        
        view.addSubview(button)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if postTextView.textColor == UIColor.lightGray {
            postTextView.text = nil
            postTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if postTextView.text.isEmpty {
            postTextView.text = "Content from here..."
            postTextView.textColor = UIColor.lightGray
        }
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
                    self.present(controller, animated: true, completion: {
                        self.selectedVideo = tempPath
                        self.selectedImages = []
                        self.presentVideo(path: tempPath)
                    })
                }
            }
        }
    }
    
    func presentVideo(path: URL) {
        BMPlayerConf.enableBrightnessGestures = false
        BMPlayerConf.enableVolumeGestures = false
        BMPlayerConf.shouldAutoPlay = false
        BMPlayerConf.topBarShowInCase = .none
        self.view.addSubview(videoplayer)
        videoplayer.gestureRecognizers?.removeAll()
        videoplayer.frame = CGRect(x: selectedCollectionView.frame.minX, y: selectedCollectionView.frame.minY, width: self.view.frame.width - 2 * (selectedCollectionView.frame.minX), height: (self.view.frame.width - 2 * (selectedCollectionView.frame.minX)) / 16 * 9)
        let asset = BMPlayerResource(url: path)
        videoplayer.setVideo(resource: asset)
    }
    
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        selectedImages = images
        selectedVideo = nil
        if self.view.subviews.contains(videoplayer) {
            videoplayer.removeFromSuperview()
        }
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

extension PostViewController: PostInfoProtocol {
    func postTitle(title: String) {
        self.postTitle = title
    }
    
    func postTags(tags: [String]) {
        self.postTags = tags
    }
    
    func postPrivilege(description: String) {
        switch description {
        case "Only my club admin":
            self.postPrivilege = 2
        case "My university members":
            self.postPrivilege = 1
        case "All(including guest)":
            self.postPrivilege = 0
        default:
            self.postPrivilege = 0
        }
    }
}
