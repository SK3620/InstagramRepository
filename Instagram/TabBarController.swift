//
//  TabBarController.swift
//  Instagram
//
//  Created by 鈴木健太 on 2022/08/15.
//

import UIKit
import Firebase

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        タブアイコンの色 alpha0.0~1.0 不透明度値　the opacity value of the color object
        self.tabBar.tintColor = UIColor(red: 1.0, green: 0.44, blue: 0.11, alpha: 1.0)
        // タブバーの背景色を設定
               let appearance = UITabBarAppearance()
//        UITabBarAppearance オブジェクトを作成したら、このクラスのメソッドとプロパティを使用して、タブバーのアイテムの外観を指定します。タブバーの背景や影の属性は、UI(Tab)BarAppearance から継承したプロパティで設定します。
              appearance.backgroundColor =  UIColor(red: 0.96, green: 0.91, blue: 0.87, alpha: 1)
               self.tabBar.standardAppearance = appearance
               self.tabBar.scrollEdgeAppearance = appearance
               // UITabBarControllerDelegateプロトコルのメソッドをこのクラスで処理する。
               self.delegate = self
           }

           // タブバーのアイコンがタップされた時に呼ばれるdelegateメソッドを処理する。
//    指定されたviewControllerにタブ切り替え(画面切り替え)していいかどうかを問い合わせるメソッドで、
//    return true でリターンすればタブ切り替えが行われますが、
//    return false でリターンすればタブ切り替えは行われません。
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is ImageSelectViewController {
            // ImageSelectViewControllerは、タブ切り替えではなくモーダル画面遷移する
            let imageSelectViewController = storyboard!.instantiateViewController(withIdentifier: "ImageSelect")
            present(imageSelectViewController, animated: true)
            return false
        } else {
            // その他のViewControllerは通常のタブ切り替えを実施
            return true
        }
    }
    
//    TabBarControllerが表示される度にログイン状態を確認する処理を viewDidAppear(_:) メソッドの中に記述（tabbarController画面に戻ってくるたびに）
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        currentUserがnilならログインしていない
//        Firebase/Authは、ユーザー登録やログイン認証を管理するアプリ。
        if Auth.auth().currentUser == nil{
//            ログインしていない時の処理
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
                        self.present(loginViewController!, animated: true, completion: nil)
        }
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
