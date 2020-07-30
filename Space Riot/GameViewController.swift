//
//  GameViewController.swift
//  Corona shooter
//
//  Created by alex on 9.06.20.
//  Copyright © 2020 alex. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation
import Foundation
import FBSDKLoginKit
import FirebaseDatabase
import GoogleMobileAds

let bannerAdsTopId: String = "ca-app-pub-3940256099942544/6300978111"
let bannerAdsBottomId: String = "ca-app-pub-3940256099942544/6300978111"
let interstitialId: String = "ca-app-pub-3940256099942544/4411468910"

class GameViewController: UIViewController, LoginButtonDelegate {

    static var instance: GameViewController!
    var backingAudio: AVAudioPlayer!
    var bannerViewBottom: GADBannerView!
    var interstitial: GADInterstitial!
    let request = GADRequest()

    // Facebook login
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        print("login OK")
//        FetchProfile()
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("Logout OK")
    }
    
    func loginButtonWillLogin(_ loginButton: FBLoginButton) -> Bool {
        return true
    }
    
    func FetchProfile(){
        print("Profile fetch")
        let parameter = ["fields": "email, first_name, last_name, picture.type(large)"]
        GraphRequest(graphPath: "me", parameters: parameter).start { (connection, result, error) in
            if(error != nil){
                print(error as Any)
                return
            }
            if let data = result as? NSDictionary{
                print(data["email"] as Any)
                print(data["first_name"] as Any)
                print(data["last_name"] as Any)
                if let picture = data["picture"] as? NSDictionary, let data = picture["data"] as? NSDictionary{
                    print(data["height"] as Any)
                    print(data["width"] as Any)
                    print(data["url"] as Any)
                }
            }
        }
    }
    
    // Facebook login end
    
    override func viewDidLoad() {
        super.viewDidLoad()        

        GameViewController.instance = self

        // Firebase start
        
        let ref = Database.database().reference()
        ref.child("someid/name").setValue("Hello world")
        
        if let token = AccessToken.current, !token.isExpired{
            // user is log in
//            FetchProfile()
        }
        
        // firebase end
        
        // Facebook login button
        
        let loginButton = FBLoginButton()
        loginButton.center = view.center
//        view.addSubview(loginButton)
        loginButton.permissions = ["public_profile", "email", "user_friends"]
        loginButton.delegate = self
        
        // Facebook login button end
        
        if let view = self.view as! SKView? {
            
            let filePath = Bundle.main.path(forResource: "font music", ofType: "mp3")
            let audioNSURL = URL(fileURLWithPath: filePath!)
            
            do{
                backingAudio = try AVAudioPlayer(contentsOf: audioNSURL)
            }
            catch{
                return(print("cannot find audio"))
            }
            
            backingAudio.numberOfLoops = -1
            backingAudio.play()
            
            let deviceWidth = UIScreen.main.bounds.width * UIScreen.main.scale
            let deviceHeight = UIScreen.main.bounds.height * UIScreen.main.scale
            let DeviceAspectRatio = Double(deviceHeight / deviceWidth)
            
            let width = 1536.0
            let height = width * DeviceAspectRatio

            //        Google ads

            bannerViewBottom = GADBannerView(adSize: kGADAdSizeBanner)
            bannerViewBottom.adUnitID = bannerAdsBottomId
            bannerViewBottom.rootViewController = self
            bannerViewBottom.load(GADRequest())
            view.addSubview(bannerViewBottom)
            bannerViewBottom.translatesAutoresizingMaskIntoConstraints = false
            bannerViewBottom.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive=true
            bannerViewBottom.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive=true
            bannerViewBottom.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive=true

            loadAds()

            //        Google ads
            
            // Load the SKScene from 'LoginWindow' width: 1536, height: 2048
            let scene = Menu(size: CGSize(width: width, height: height), form: "welcome")
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            
            // Present the scene
            view.presentScene(scene)
            
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
            view.showsPhysics = true
        }
    }

    func loadAds(){
        interstitial = GADInterstitial(adUnitID: interstitialId )
        interstitial.load(request)
    }
        
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
