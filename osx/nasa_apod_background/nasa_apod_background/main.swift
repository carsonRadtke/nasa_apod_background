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

func getAPODResponse() -> APODObject
{
    let url = getURL()
    
    /* TODO */
    
    return APODObject()
}

func saveImage(url: String) -> NSURL
{
    let fileName: NSURL = NSURL(fileURLWithPath: String(format: "%@wallpaper.bmp", NSTemporaryDirectory()))
    
    /* TODO */
    
    return fileName
}

func setBackground(path: NSURL) -> Void
{
    do
    {
        let imgURL: URL = NSURL.fileURL(withPath: path.absoluteString!)
        let workspace: NSWorkspace = NSWorkspace.shared
        if let screen: NSScreen = NSScreen.main {
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
    let apodObject: APODObject = getAPODResponse()

    if (apodObject.media_type == "image")
    {
        let imagePath: NSURL = saveImage(url: apodObject.hdurl!)

        setBackground(path: imagePath)
    }
}

class APODObject
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
