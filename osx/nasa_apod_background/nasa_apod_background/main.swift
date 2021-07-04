import Foundation
import AppKit

let endpoint: String = "https://api.nasa.gov"
let apiKey: String = "DEMO_KEY" /* use 'DEMO_KEY' */

let urlFormatString = "%@/planetary/apod?date=%@&api_key=%@&hd=true"
let dateFormatString = "yyyy-MM-dd"

func getURL() -> String
{
    let dateFormatter: DateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateFormatString
    
    let dateString: String = dateFormatter.string(from: Date())
    let urlString: String = String(format: urlFormatString, endpoint, dateString, apiKey)
    
    return urlString
}

func getAPODResponse() -> APODObject?
{
    let url = URL(string: getURL())!
    
    var ret: APODObject = APODObject()
    
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        
        if (error == nil) {
            ret = APODObject.fromJSON(json: data!)
        }
        
    }
    
    task.resume()
    
    while (!task.progress.isFinished) { }
    
    return ret
}

func saveImage(url: String) -> NSURL
{
    let fileName: NSURL = NSURL(fileURLWithPath: String(format: "%@wallpaper.bmp", NSTemporaryDirectory()))
    
    return fileName
}

func setBackground(path: NSURL) -> Void
{
    do
    {
        let imgURL: URL = NSURL.fileURL(withPath: path.absoluteString!)
        let workspace: NSWorkspace = NSWorkspace.shared
        
        if let screen: NSScreen = NSScreen.main
        {
            try workspace.setDesktopImageURL(imgURL, for: screen, options: [:])
        }
    }
    catch
    {
        print(error)
    }
}

func main() -> Void
{
    let apodObject: APODObject? = getAPODResponse()

    if (apodObject != nil && apodObject!.media_type == "image")
    {
        let imagePath: NSURL = saveImage(url: apodObject!.hdurl!)

        setBackground(path: imagePath)
    }
}

class APODObject : Decodable
{
    init()
    {
        copyright = nil
        date = nil
        explanation = nil
        hdurl = nil
        media_type = nil
        service_version = nil
        title = nil
        url = nil
    }
    
    static func fromJSON(json: Data) -> APODObject {
        
        let decoder = JSONDecoder()
        
        var ret: APODObject
        
        do {
            ret = try decoder.decode(APODObject.self, from: json)
        } catch {
            ret = APODObject()
        }
        
        return ret
        
    }
    
    let copyright: String?
    let date: String?
    let explanation: String?
    let hdurl: String?
    let media_type: String?
    let service_version: String?
    let title: String?
    let url: String?
}

main();
