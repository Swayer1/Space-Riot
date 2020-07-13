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

class GameViewController: UIViewController, LoginButtonDelegate {

    var backingAudio: AVAudioPlayer!
    static var bannerViewTop: GADBannerView!
    static var bannerViewBottom: GADBannerView!
    static var interstitial: GADInterstitial!

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
//            backingAudio.play()
            
            let deviceWidth = UIScreen.main.bounds.width * UIScreen.main.scale
            let deviceHeight = UIScreen.main.bounds.height * UIScreen.main.scale
            let DeviceAspectRatio = Double(deviceHeight / deviceWidth)
            
            let width = 1536.0
            let height = width * DeviceAspectRatio

            //        Google ads

            GameViewController.bannerViewTop = GADBannerView(adSize: kGADAdSizeBanner)
            GameViewController.bannerViewTop.adUnitID = "ca-app-pub-3940256099942544/6300978111"
            GameViewController.bannerViewTop.rootViewController = self
            GameViewController.bannerViewTop.load(GADRequest())
            view.addSubview(GameViewController.bannerViewTop)
            GameViewController.bannerViewTop.translatesAutoresizingMaskIntoConstraints = false
            GameViewController.bannerViewTop.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive=true
            GameViewController.bannerViewTop.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive=true
            GameViewController.bannerViewTop.topAnchor.constraint(equalTo: view.topAnchor).isActive=true

            GameViewController.bannerViewBottom = GADBannerView(adSize: kGADAdSizeBanner)
            GameViewController.bannerViewBottom.adUnitID = "ca-app-pub-3940256099942544/6300978111"
            GameViewController.bannerViewBottom.rootViewController = self
            GameViewController.bannerViewBottom.load(GADRequest())
            view.addSubview(GameViewController.bannerViewBottom)
            GameViewController.bannerViewBottom.translatesAutoresizingMaskIntoConstraints = false
            GameViewController.bannerViewBottom.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive=true
            GameViewController.bannerViewBottom.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive=true
            GameViewController.bannerViewBottom.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive=true

            GameViewController.interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
            let request = GADRequest()
            GameViewController.interstitial.load(request)
            
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
