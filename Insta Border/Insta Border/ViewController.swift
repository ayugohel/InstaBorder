//
//  ViewController.swift
//  Insta Border
//
//  Created by Ayushi on 2020-03-28.
//  Copyright © 2020 Ayushi. All rights reserved.
//
//73591

import UIKit

class ViewController: UIViewController {

    // MARK: - Outlets -------

    @IBOutlet weak var btnSelectImg: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var imgPicked: UIImageView!
    
    // MARK: - Variables -------

    let pickerController = UIImagePickerController()
    var viewCenter: CGPoint!
    var arrColor : [UIColor] =
        [UIColor("#ffffff"), UIColor("#dfdfdf"), UIColor("#c6c6c6"), UIColor("#c0bfd9"), UIColor("#c5bfd9"),
         UIColor("#a48495"), UIColor("#baa1ae"), UIColor("#cbbcbc"), UIColor("#df9aff"), UIColor("#c59aff"), UIColor("#d4b4ff"), UIColor("#ff8d86"), UIColor("#ff8693"), UIColor("#ff9abc"), UIColor("#ffad9a"), UIColor("#a3ff9a"),UIColor("#bcff9a"), UIColor("##d5ff9a"),UIColor("#ffe55f"), UIColor("#ffff5f"), UIColor("#e4ff5f"), UIColor("#939721") ]

    // MARK: - Functios -------

    // MARK: Drag ImageView

    @objc func dragView(gesture: UIPanGestureRecognizer) {
        
        let target = gesture.view!

        switch gesture.state {
        
        case .began, .ended:
            viewCenter = target.center
            
        case .changed:
            let translation = gesture.translation(in: self.bgView)
            target.center = CGPoint(x: viewCenter!.x + translation.x, y: viewCenter!.y + translation.y)
            
        default: break
        
        }
        
    }
    
    // MARK: Pinch ImageView

    @objc func didPinch(sender: UIPinchGestureRecognizer) {
        let scale = sender.scale
        imgPicked!.transform = imgPicked.transform.scaledBy(x: scale, y: scale)
        sender.scale = 1
    }
    
    // MARK: for Handle errors while Photo saving

    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        let alert = UIAlertController(title: "", message: "Image saved succesfully...", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    // MARK: - Button Actions -------

    // MARK: to open Photos

    @IBAction func btnPhotosTapped(_ sender: Any) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
        self.pickerController.sourceType = .photoLibrary
        self.present(self.pickerController, animated: true, completion: nil)
    }
    
    // MARK: Photo save in Photos library

    @IBAction func btnSaveTapped(_ sender: Any) {
        let img =  UIImage.init(view: bgView)
        UIImageWriteToSavedPhotosAlbum(img, self, #selector(saveError), nil)
    }
    
    // MARK: - View life cycle Method -------

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        pickerController.delegate = self
        pickerController.mediaTypes = ["public.image"]
        btnSave.isEnabled = false
        
        imgPicked.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.dragView)))
        imgPicked.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(self.didPinch)))
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
}

// MARK: - UIImagePickerControllerDelegate protocol -------

extension ViewController : UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {    }

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        picker.dismiss(animated: true, completion: nil)

        if let image = info[.originalImage] as? UIImage {
            imgPicked.image = image
            imgPicked.contentMode = .scaleAspectFit
            btnSave.isEnabled = true
        }
    }
}


// MARK: - Class UICollectionViewCell -------

class ColorCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
}

// MARK: - UICollectionViewDataSource protocol -------

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrColor.count
    }

    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath as IndexPath) as! ColorCell

        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 10 //cell.layer.bounds.height / 2
//        cell.label.text = String(indexPath.row + 1)
        cell.backgroundColor = arrColor[indexPath.row]

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        bgView.backgroundColor = arrColor[indexPath.row]
    }
}
