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

var bannerAdsTopId: String = "ca-app-pub-3940256099942544/6300978111"
var bannerAdsBottomId: String = "ca-app-pub-3940256099942544/6300978111"
var interstitialId: String = "ca-app-pub-3940256099942544/4411468910"

class GameViewController: UIViewController, LoginButtonDelegate, GADBannerViewDelegate {
    
    static var instance: GameViewController!
    var backingAudio: AVAudioPlayer!
    var bannerViewBottom: GADBannerView!
    var interstitial: GADInterstitial!
    var request = GADRequest()
    var loginButton = FBLoginButton()
    var loginType: Int = 0
    var defaults = UserDefaults()
    var token: String?
    
    // Facebook login
        
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        print("* login OK")
        token = result?.token?.tokenString
        if(token != nil){
            loginType = 1
            Animations.changeSceneAnimationWithDelay(fromScene: LogInScene.instance!, toScene: MainMenu.self, delay: 0)
            LogInScene.instance = nil
        }        
        var parameters = ["fields":"email, name"]
        var request = FBSDKLoginKit.GraphRequest(graphPath: "me",parameters: parameters, tokenString: token, version: nil, httpMethod: .get)
        request.start(completionHandler: {connection, result, error in
            print("* \(result)")
        })        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("* Logout OK")
        loginType = 0
    }
            
    func loginButtonWillLogin(_ loginButton: FBLoginButton) -> Bool {
        return true
    }
    
    func getFacebookLoginData(){
        if var token = AccessToken.current, !token.isExpired {
            // User is logged in, do work such as go to next view controller.
            var token = token.tokenString
            var parameters = ["fields":"email, name, picture.type(large)"]
            var request = FBSDKLoginKit.GraphRequest(graphPath: "me",parameters: parameters, tokenString: token, version: nil, httpMethod: .get)
            request.start(completionHandler: {connection, result, error in
                var data = result as! [String: Any]
                print("* \(data)")
            })                        
        }
    }
            
    // Facebook login end
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GameViewController.instance = self
        
        // Firebase start
        
        var ref = Database.database().reference()
        ref.child("someid/name").setValue("Hello world")
                
        // firebase end
        
        // Facebook login button
        
        if var token = AccessToken.current, !token.isExpired {
            // User is logged in, do work such as go to next view controller.
            loginType = 1
        }
                        
        loginButton.delegate = self
        loginButton.permissions = ["public_profile", "email"]
        
        // Facebook login button end
        
        if var view = self.view as! SKView? {
            
            var filePath = Bundle.main.path(forResource: "font music", ofType: "mp3")
            var audioNSURL = URL(fileURLWithPath: filePath!)
            
            do{
                backingAudio = try AVAudioPlayer(contentsOf: audioNSURL)
            }
            catch{
                return(print("cannot find audio"))
            }
            
            backingAudio.numberOfLoops = -1
            backingAudio.play()
            
            var deviceWidth = UIScreen.main.bounds.width * UIScreen.main.scale
            var deviceHeight = UIScreen.main.bounds.height * UIScreen.main.scale
            var DeviceAspectRatio = Double(deviceHeight / deviceWidth)
            
            var width = 1536.0
            var height = width * DeviceAspectRatio
            
            //        Google ads
            bannerViewBottom = GADBannerView(adSize: kGADAdSizeBanner)
            bannerViewBottom.adUnitID = bannerAdsBottomId
            bannerViewBottom.delegate = self
            bannerViewBottom.rootViewController = self
            bannerViewBottom.load(GADRequest())
            loadAds()
                        
            // Google ads
            
            // Load the SKScene from 'LoginWindow' width: 1536, height: 2048
            var menuForm = WelcomeScene(size: CGSize(width: width, height: height))
            // Set the scale mode to scale to fit the window
                                    
//            menuForm.scaleMode = .aspectFill
            
            // Present the scene
            view.presentScene(menuForm)
            
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
            view.showsPhysics = true
        }
    }
    
    // google ads delegates
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("* adViewDidReceiveAd")
        MainMenu.instance?.MoveMeniBar(space: 200)
        view.addSubview(bannerViewBottom)
        bannerViewBottom.translatesAutoresizingMaskIntoConstraints = false
        bannerViewBottom.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive=true
        bannerViewBottom.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive=true
        bannerViewBottom.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive=true
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("* adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("* adViewWillPresentScreen")
    }
    
    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("* adViewWillDismissScreen")
    }
    
    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("* adViewDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("* adViewWillLeaveApplication")
    }
    
    // end google ads delegates
    
    
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
