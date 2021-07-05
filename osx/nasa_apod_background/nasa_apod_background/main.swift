import Foundation
import AppKit

let endpoint: String = "https://api.nasa.gov"
let apiKey: String = "<REDACTED>" /* use 'DEMO_KEY' */

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
    
    let group = DispatchGroup()
    group.enter()
    
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        
        if (error == nil) {
            ret = APODObject.fromJSON(json: data!)
        }
        
        group.leave()
        
    }
    
    task.resume()
    group.wait()
    
    return ret
}

func saveImage(url: String) -> URL?
{
    var fileName: URL? = URL(fileURLWithPath: String(format: "%@wallpaper.bmp", NSTemporaryDirectory()))
    
    let group = DispatchGroup()
    group.enter()
    
    let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
        
        if (error == nil) {
            
            do {
                try data?.write(to: fileName!)
            }
            catch {
                fileName = nil
            }
            
        }
        
        group.leave()
        
    }
    
    task.resume()
    group.wait()
    
    return fileName
}

func setBackground(path: URL?) -> Void
{
    do
    {
        if (path != nil) {
            let imgURL = path!
            let workspace: NSWorkspace = NSWorkspace.shared
            
            if let screen: NSScreen = NSScreen.main
            {
                try workspace.setDesktopImageURL(imgURL, for: screen, options: [:])
            }
        }
    }
    catch
    { }
}

func main() -> Void
{
    let apodObject: APODObject? = getAPODResponse()

    if (apodObject != nil && apodObject!.media_type == "image")
    {
        let imagePath: URL? = saveImage(url: (apodObject?.hdurl ?? apodObject?.url)!)

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
