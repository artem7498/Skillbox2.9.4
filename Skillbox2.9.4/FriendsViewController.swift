//
//  FriendsViewController.swift
//  Skillbox2.9.4
//
//  Created by Артём on 2/3/21.
//

import UIKit
import VK_ios_sdk
import FBSDKCoreKit
import FBSDKShareKit

class FriendsViewController: UIViewController {
    
    var friendss: [Friends] = []

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFriendsVK()
        loadFriendsFB()
        print("ggg \(friendss.count)")
    }
    
    
    func loadFriendsFB(){
        if AccessToken.current != nil{
            let params = ["fields": "id, first_name, last_name"]
            let request = GraphRequest(graphPath: "me/friends", parameters: params).start { (connection:        GraphRequestConnection?, result, error) in
                if error != nil {
                    print(error!)
                }
                else {
                    print(result!)
                    //Do further work with response
                }
            }
        }
        
        
        
//        GraphRequest(graphPath: "/me/friends", parameters: params).start { (connection, result , error) -> Void in
//
//                if error != nil {
//                    print(error!)
//                }
//                else {
//                    print(result!)
//                    //Do further work with response
//                }
//            }
    }
    
    
    func loadFriendsVK(){
        let request: VKRequest = VKRequest(method: "friends.get", parameters: ["fields":"count"])
//        (method: "friends.get", andParameters: ["fields":"count"], andHttpMethod:"GET")
        request.execute { (response) -> Void in
            if let json = response?.json as? NSDictionary,
                let jsonDict = json["items"] as? NSArray{
                
                    for dict in jsonDict{
                        if let category = Friends(data: dict as! NSDictionary)
                        {self.friendss.append(category)}
                        print(self.friendss.count)
                    }
                }
            DispatchQueue.main.async { [self] in
                tableView.reloadData()
            }
            print(response?.json ?? "empty")
        } errorBlock: { (error)-> Void in
            print("error")
        }

    }
    

}

extension FriendsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendss.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FriendsTableViewCell
        
        let model = friendss[indexPath.row]
        
        cell.nameLabel.text = model.name
        cell.lastNameLAbel.text = model.lastName
        return cell
    }
    
    
}
