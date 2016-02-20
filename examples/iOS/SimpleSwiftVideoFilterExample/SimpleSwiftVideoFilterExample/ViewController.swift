import UIKit
import GPUImage

class ViewController: UIViewController {
    
    var videoCamera:GPUImageVideoCamera?
    var filter:GPUImagePixellateFilter?
    var output:GPUImageRawDataOutput?
    var rawBytesForImage: UnsafeMutablePointer<GLubyte>?
    
    //    Long
    //    http://stackoverflow.com/a/27671003/83859

    //    Short
    //    http://stackoverflow.com/a/26644308/83859

    //    https://github.com/BradLarson/GPUImage/issues/1905

    let interval = 200
    var last_time = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hello world")
//        Don't forget to deallocate memory

        videoCamera = GPUImageVideoCamera(sessionPreset: AVCaptureSessionPreset352x288, cameraPosition: .Back)
        videoCamera!.outputImageOrientation = .Portrait;
        filter = GPUImagePixellateFilter()
        videoCamera?.addTarget(filter)
        filter?.addTarget(self.view as! GPUImageView)
        
//        Works
        output = GPUImageRawDataOutput(imageSize: CGSizeMake(352, 288), resultsInBGRAFormat: true)
        
        output!.newFrameAvailableBlock = { () in
            print((NSDate().timeIntervalSinceReferenceDate-self.last_time.timeIntervalSinceReferenceDate)*1000)
            self.rawBytesForImage = self.output!.rawBytesForImage
            self.last_time = NSDate()
//            print(self.rawBytesForImage?.memory)
            
            let buffer = UnsafeMutableBufferPointer(start: self.rawBytesForImage!, count: Int(352*288*4))
//            print(buffer[0])
//            print(buffer[1])

            // WORKS
//            var data = NSData(bytes: self.rawBytesForImage!, length: Int(352*288*4))


            //http://stackoverflow.com/a/31109955/83859
//            print(data[0])
//            print(data[1])

//            UTF8String
//            print(self.rawBytesForImage?.successor().memory)
//            for b in self.rawBytesForImage!.memory.stride(through: 10, by: 1) {
//                print(b)
//            }

            //            print(self.output!.rawBytesForImage.successor().memory)

//            public var rawBytesForImage: UnsafeMutablePointer<GLubyte> { get }

        }
        

        
        videoCamera?.addTarget(output)
        
//        Generated from obj c here: https://github.com/BradLarson/GPUImage/issues/946 
        
//        var rawDataOutput: GPUImageRawDataOutput = GPUImageRawDataOutput(imageSize: CGSizeMake(640.0, 480.0), resultsInBGRAFormat: true)
//        self.rawDataOutput = rawDataOutput
//        var outputBytes: GLubyte = rawDataOutput.rawBytesForImage()
//        var bytesPerRow: Int = rawDataOutput.bytesPerRowInOutput()
//        var dataForRawBytes: NSData = NSData.dataWithBytes(outputBytes, length: 480)
//        targetUIImageView.image = UIImage.imageWithData(dataForRawBytes)


        
        



        //        output     public var newFrameAvailableBlock: (() -> Void)!

        
//        rawDataOutput setNewFrameAvailableBlock:^{
//            // Handle raw data processing here
//            }
        
//        GPUImageRawDataOutput rawDataOutput = [[GPUImageRawDataOutput alloc] initWithImageSize:CGSizeMake(352, 288) resultsInBGRAFormat:YES];

        
        videoCamera?.startCameraCapture()
        

        
    }
}