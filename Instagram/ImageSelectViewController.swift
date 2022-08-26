//
//  ImageSelectViewController.swift
//  Instagram
//
//  Created by 鈴木健太 on 2022/08/15.
//

import UIKit
import CLImageEditor

class ImageSelectViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate, CLImageEditorDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func handleLibraryButton(_ sender: Any) {
//        ライブラリ(photolaibrary)（カメラロール）を指定してピッカーを開く　画像の一覧から選ぶライブラリを設定
        
//カメラ機能があるかどうかを判定する。Queries whether the device supports picking media using the specified source type.指定されたソースタイプを使用したpicking mediaに対応してるかどうかを問い合わせる
//        Returns
//        true if the device supports the specified source type; false if the specified source type is not available.
//        isSourceTypeAvailableメソッドは、bool型を返すから、ifでreturn trueだったら、if文内を実行　(elseでfalseも実行できる）
//        ちなみに、こいつはcalss func（型メソッド）だから、UIImagePickerController().isSourceTypeAvailableとは書かない。
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .photoLibrary
            self.present(pickerController, animated: true, completion: nil)
//            An image picker controller manages user interactions and delivers the results of those interactions to a delegate object.
//            present()メソッドの第一引数の型は、UIViewController。pickerCOntrollerはUIImagePickerControllerだが、UIimagePickerControllerクラスはUIViewCntorollerクラスを継承しているため、第一引数に指定可能。
            
        }
    }
    
    @IBAction func handleCameraButton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .camera
            self.present(pickerController, animated: true, completion: nil)
        }

    }
    
    @IBAction func handleCancelButton(_ sender: Any) {
//        画面を閉じる Dismisses the view controller that was presented modally by the view controller.
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
//    写真を撮影、選択した時に呼ばれるデリゲートメソッド
//    infoは辞書　let dictionary: [String: Int] = ["key1": 1, "key2": 2]
//    dictionary["key1"] //1 (Optional<Int>型)
//    dictionary["key2"] //2 (Optional<Int>型)
//    dictionary["key3"] //nil
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        UIimagePickerContollerを閉じる
        picker.dismiss(animated: true, completion: nil)
//        画像加工処理　infoKeyはユーザーが選択したメディアに関する情報を編集辞書から取得するために使用するキー。
        if info[UIImagePickerController.InfoKey.originalImage] != nil{
//            撮影された、選択された画像を取り出す originalImageはUIImagePickerController型　取り出した画像はAny型
//            上位のAny型からダウンキャストして下位のUIImage型に変更
            let image = info[.originalImage] as! UIImage
//            辞書（info)は取り出した時、オプショナルで取り出される。
//            後でCLImageEditorライブラリで画像加工する。→ CLImageEditor（画像加工画面）を生成して画面遷移する処理を追加する
            print("DEBUG_PRINT: image = \(image)")
//            CLImageEditorにimageを渡して、加工画面を起動
            let editor = CLImageEditor(image: image)!
            editor.delegate = self
            self.present(editor, animated: true, completion: nil)
        }
    }
    
//    CLImageEditorのdelegateメソッドの実装　CLImageEditorで加工編集が完了すると呼び出される
//    この中で投稿画面を生成して加工済みの画像を渡してモーダル画面遷移する。
    func imageEditor(_ editor: CLImageEditor!, didFinishEditingWith image: UIImage!) {
//        投稿画面を開く
         let postViewController: PostViewController = self.storyboard?.instantiateViewController(withIdentifier: "Post") as! PostViewController
        postViewController.image = image!
        editor.present(postViewController, animated: true, completion: nil)
    }
    
//    CLImageEditorの編集がキャンセルされた時に呼び出されるメソッド（加工画面でキャンセルボタンをタップした時）
    func imageEditorDidCancel(_ editor: CLImageEditor!) {
//        CLImageEditor画面を閉じる
        editor.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        UIImagePickerCOntrollerを閉じる
        picker.dismiss(animated: true, completion: nil)
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
