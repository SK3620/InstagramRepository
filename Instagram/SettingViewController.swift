//
//  SettingViewController.swift
//  Instagram
//
//  Created by 鈴木健太 on 2022/08/15.
//

import UIKit
import Firebase
import SVProgressHUD

class SettingViewController: UIViewController {

    @IBOutlet weak var displayNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        表示名を取得してtextfiledに設定
        let user = Auth.auth().currentUser
        if let user = user {
            displayNameTextField.text = user.displayName
        }
    }
    
//    表示名変更ボタン
    @IBAction func handleChangeButton(_ sender: Any) {
        if let displayName = displayNameTextField.text{
            
//            表示名が入力されていない時は、HUDを出して、何もしない
            if displayName.isEmpty{
                SVProgressHUD.showError(withStatus: "表示名を入力して下さい")
                return
            }
            
//            表示名を設定する
            let user = Auth.auth().currentUser
            if let user = user {
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = displayName
                changeRequest.commitChanges { error in
                    if let error = error {
                        SVProgressHUD.showError(withStatus: "表示名の変更に失敗しました。")
                        print("DEBUG_PRINT: " + error.localizedDescription)
                        return
                    }
                    print("DEBUG_PRINT: [displayName = \(user.displayName!)]の設定に成功しました。")
                    
//                    HUDで完了を知らせる
                    SVProgressHUD.showSuccess(withStatus: "表示名を変更しました")
                }
            }
        }
        self.view.endEditing(true)
    }
    
    
    
    @IBAction func handleLogoutButton(_ sender: Any) {
//        ログアウトする
        try! Auth.auth().signOut()
        
//        ログイン画面を表示する
        let loginViewContrller = self.storyboard?.instantiateViewController(withIdentifier: "Login")
        self.present(loginViewContrller!, animated: true, completion: nil)
        
//        ログイン画面から戻ってきた時のためにホーム画面(index=0)を選択している状態にしておく
        tabBarController?.selectedIndex = 0
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
