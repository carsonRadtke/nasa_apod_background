using Newtonsoft.Json;
using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Net.Http;
using System.Runtime.InteropServices;
using System.Threading.Tasks;

namespace nasa_apod_background
{
    class Program
    {
        // constants to connect to NASA's API
        const string endpoint = "https://api.nasa.gov";
        const string apiKey = "<REDACTED>"; // can use 'DEMO_KEY' for testing/low frequency requests

        // constants for user32.dll
        const int SPI_SETDESKWALLPAPER = 0x0014;
        const int SPIF_UPDATEINIFILE = 0x01;
        const int SPIF_SENDWININICHANGE = 0x02;

        // function to change background
        [DllImport("user32.dll", CharSet = CharSet.Auto)]
        static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);

        static async Task Main()
        {
            HttpResponseMessage httpResponseMessage;
            APODObject apodResponse;
            string content;

            using (HttpClient client = new HttpClient())
            {
                // compute date offset and filename
                string dateString = DateTime.Now.ToString("yyyy-MM-dd");
                string fileName = Path.Combine(Path.GetTempPath(), "wallpaper.bmp");

                // send api request
                httpResponseMessage = await client.GetAsync(string.Format("{0}/planetary/apod?date={1}&api_key={2}&hd=true", endpoint, dateString, apiKey));
                httpResponseMessage.EnsureSuccessStatusCode();

                // read api request
                content = await httpResponseMessage.Content.ReadAsStringAsync();

                // convert api request to object
                apodResponse = JsonConvert.DeserializeObject<APODObject>(content);

                // only care about images, skip anything != image
                if (apodResponse.media_type == "image")
                {
                    // request the image
                    httpResponseMessage = await client.GetAsync(apodResponse.hdurl);
                    httpResponseMessage.EnsureSuccessStatusCode();

                    // convert image data into bitmap
                    using (Stream imageStream = await httpResponseMessage.Content.ReadAsStreamAsync())
                    using (Image image = Image.FromStream(imageStream))
                    {
                        // save image
                        image.Save(fileName, ImageFormat.Bmp);

                        // set background
                        SystemParametersInfo(SPI_SETDESKWALLPAPER, 3, fileName, SPIF_UPDATEINIFILE | SPIF_SENDWININICHANGE);
                    }
                }
            }
        }

        /// <summary>
        /// Class (struct) to represent a response object from the API
        /// </summary>
        private class APODObject
        {
            public string copyright;
            public string date;
            public string explanation;
            public string hdurl;
            public string media_type;
            public string service_version;
            public string title;
            public string url;
        }
    }
}
