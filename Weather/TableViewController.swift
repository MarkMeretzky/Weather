//
//  TableViewController.swift
//  Weather
//
//  Created by Mark Meretzky on 10/27/17.
//  Copyright © 2017 NYU School of Professional Studies. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    let cellReuseIdentifier: String = "weather";
 
    //Should be one array of structs instead of six parallel arrays.  Sorry, no time!
    var dateTimeISO: [String] = [];
    var icon: [String] = [];
    var minTempF: [Int] = [];
    var maxTempF: [Int] = [];
    var minTempC: [Int] = [];
    var maxTempC: [Int] = [];
    var fahrenheit: Bool = true;
    
    required init(coder aDecoder: NSCoder) {
        super.init(nibName: nil, bundle: nil);
        
        let id: String = "5ZBNUuaFj9CP6QqQWZybB";
        let secret: String = "UXFJ7VmFStXCExgnMaRPdIMBj5ll3BaKNs8Ml5va";
        let urlString: String = "http://api.aerisapi.com/forecasts/11101?client_id=\(id)&client_secret=\(secret)";
        
        let url: URL? = URL(string: urlString);
        if url == nil {
            print("could not create URL");
            return;
        }
        
        let formatter = DateFormatter();
        formatter.dateStyle = DateFormatter.Style.long;
        
        let sharedSession: URLSession = URLSession.shared;
        
        let downloadTask: URLSessionDownloadTask = sharedSession.downloadTask(
            with: url!,
            completionHandler: {(filename: URL?, response: URLResponse?, error: Error?) in
                
                if (error != nil) {
                    print("could not download data from server: \(error!)");
                    return;
                }
                
                //Arrive here when the data from the forecast server has been
                //downloaded into a file in the iPhone.
                
                //Copy the data from the file into a Data object.
                let data: Data;
                do {
                    try data = Data(contentsOf: filename!);
                } catch {
                    print("could not create Data object");
                    return;
                }
                
                //The data is in JSON format.
                //Copy the data from the Data object into a big Swift dictionary.
                let dictionary: [String: Any];
                do {
                    try dictionary =
                        JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions())
                        as! [String: Any];
                } catch {
                    print("could not create big dictionary: \(error)");
                    return;
                }
                
                //let respin
                
                //print(dictionary["response"]!); //the JSON downloaded from the server
                let response = dictionary["response"]! as! [Any];
                let dict = response[0] as! [String: Any];
                let arrayOfDays = dict["periods"] as! [[String: Any]];
                
                for day in arrayOfDays {
                    self.dateTimeISO.append(day["dateTimeISO"]! as! String);
                    self.icon.append(day["icon"]! as! String);
                    self.minTempF.append(day["minTempF"]! as! Int);
                    self.maxTempF.append(day["maxTempF"]! as! Int);
                    self.minTempC.append(day["minTempF"]! as! Int);
                    self.maxTempC.append(day["maxTempF"]! as! Int);
                }
                
                DispatchQueue.main.async(execute: {() -> Void in
                    self.tableView.reloadData();
                });
 
        });
        
        downloadTask.resume();
    }

    override func viewDidLoad() {
        super.viewDidLoad();
        tableView.register(TableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier);

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dateTimeISO.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)

        // Configure the cell...
        let date: String = dateTimeISO[indexPath.row];
        let tloc = date.index(of: "T")!  //Display only the date.  Chop off the time.
		cell.textLabel!.text = String(date[..<tloc]);
        let iconName: String = icon[indexPath.row];
        print(iconName);
        cell.imageView!.image = UIImage(named: iconName);    //nil if .png file doesn't exist
        
        if fahrenheit {
        	cell.detailTextLabel!.text = "Hi: \(maxTempF[indexPath.row])°F    Lo: \(minTempF[indexPath.row])°F";
        } else {
            cell.detailTextLabel!.text = "Hi: \(maxTempF[indexPath.row])°C    Lo: \(minTempF[indexPath.row])°C";
        }
        return cell;
    }
    
    //If any cell is touched, toggle fahrenheit/celsius.

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        fahrenheit = !fahrenheit;
        tableView.reloadData();
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
