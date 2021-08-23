//
//  ViewController.swift
//  Techtagram
//
//  Created by 河村大介 on 2021/08/24.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var cameraImageView: UIImageView!
    
    // 画像加工するための元となる画像
    var originalImage: UIImage!
    
    // 画像加工するためのフィルターの宣言
    var filter: CIFilter!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func takePhoto() {
        
        // カメラが使えるか確認
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            // カメラ起動
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            
            picker.allowsEditing = true
            
            present(picker, animated: true, completion: nil)
            
        } else {
            // カメラが使えない
            print("カメラが使えません。")
            
        }
    
    }
    
    // カメラ、カメラロールの使用が終わった後に、洗濯した画像をアプリに表示させるためのメソッド
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        cameraImageView.image = info[.editedImage] as? UIImage
        
        originalImage = cameraImageView.image
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func savePhoto() {
        UIImageWriteToSavedPhotosAlbum(cameraImageView.image!, nil, nil, nil)
    }
    
    @IBAction func colorFilter() {
        
        let filterImage: CIImage = CIImage(image: originalImage)!
        
        // 色調整フィルター
        filter = CIFilter(name: "CIColorControls")!
        filter.setValue(filterImage, forKey: kCIInputImageKey)
        
        // 彩度の調整
        filter.setValue(1.0, forKey: "inputSaturation")
        
        // 明度の調整
        filter.setValue(0.5, forKey: "inputBrightness")
        
        // コントラストの調整
        filter.setValue(2.5, forKey: "inputContrast")
        
        let ctx = CIContext(options: nil)
        let cgImage = ctx.createCGImage(filter.outputImage!, from: filter.outputImage!.extent)
        cameraImageView.image = UIImage(cgImage: cgImage!)
    
    }
    
    @IBAction func openAlbum() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            // カメラロールを選択して表示するまでの一連の流れ
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            
            present(picker, animated: true, completion: nil)
        }
    }
    
    @IBAction func snsPhoto() {
        
        // 投稿に一緒に載せるコメント
        let shareText = "写真加工いぇい！"
        
        // 投稿する画像の選択
        let shareImage = cameraImageView.image!
        
        // 投稿するコメントと画像の準備
        let activityItem: [Any] = [shareText, shareImage]
        
        
        let activityController = UIActivityViewController(activityItems: activityItem, applicationActivities: nil)
        
        
        let excludedActivityType = [UIActivity.ActivityType.postToWeibo, .saveToCameraRoll, .print]
        
        activityController.excludedActivityTypes = excludedActivityType
        
        present(activityController, animated: true, completion: nil)
    
    }


}

