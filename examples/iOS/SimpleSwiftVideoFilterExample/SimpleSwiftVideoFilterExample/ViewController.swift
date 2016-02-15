import UIKit
import GPUImage

class ViewController: UIViewController {
    
    var videoCamera:GPUImageVideoCamera?
    var filter:GPUImagePixellateFilter?
    var output:GPUImageRawDataOutput?
    var bytes:GLubyte?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hello world")

        videoCamera = GPUImageVideoCamera(sessionPreset: AVCaptureSessionPreset352x288, cameraPosition: .Back)
        videoCamera!.outputImageOrientation = .Portrait;
        filter = GPUImagePixellateFilter()
        videoCamera?.addTarget(filter)
        filter?.addTarget(self.view as! GPUImageView)
        
        
        output = GPUImageRawDataOutput(imageSize: CGSizeMake(352, 288), resultsInBGRAFormat: true)
        output!.newFrameAvailableBlock = { () in
            print("hey!")
            //bytes = output!.rawBytesForImage()
        }
        
        
        
        videoCamera?.addTarget(output)
        
//        Generated from obj c here: https://github.com/BradLarson/GPUImage/issues/946 
        
//        var rawDataOutput: GPUImageRawDataOutput = GPUImageRawDataOutput(imageSize: CGSizeMake(640.0, 480.0), resultsInBGRAFormat: true)
//        self.rawDataOutput = rawDataOutput
//        var outputBytes: GLubyte = rawDataOutput.rawBytesForImage()
//        var bytesPerRow: Int = rawDataOutput.bytesPerRowInOutput()
//        var dataForRawBytes: NSData = NSData.dataWithBytes(outputBytes, length: 480)
//        targetUIImageView.image = UIImage.imageWithData(dataForRawBytes)


        
        

//        output?.newFrameReadyAtTime(<#T##frameTime: CMTime##CMTime#>, atIndex: <#T##Int#>)
//        { (output_2: GPUImageRawDataOutput, error: NSError) in
//            print("hey")
//        }

        //        output     public var newFrameAvailableBlock: (() -> Void)!

        
//        rawDataOutput setNewFrameAvailableBlock:^{
//            // Handle raw data processing here
//            }
        
//        GPUImageRawDataOutput rawDataOutput = [[GPUImageRawDataOutput alloc] initWithImageSize:CGSizeMake(352, 288) resultsInBGRAFormat:YES];

        
        videoCamera?.startCameraCapture()
        

        
    }
}