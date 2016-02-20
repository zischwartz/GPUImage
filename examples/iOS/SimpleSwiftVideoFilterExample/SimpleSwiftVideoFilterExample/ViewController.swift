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

//        this works too, slightly slower it seems? unlike guy says
//        output = MyRawDataOutput(imageSize: CGSizeMake(352, 288), resultsInBGRAFormat: true)

        output!.newFrameAvailableBlock = { () in
            print((NSDate().timeIntervalSinceReferenceDate-self.last_time.timeIntervalSinceReferenceDate)*1000)
            self.rawBytesForImage = self.output!.rawBytesForImage
            self.last_time = NSDate()
//            print(self.rawBytesForImage?.memory)

            //http://stackoverflow.com/a/31109955/83859
            let buffer = UnsafeMutableBufferPointer(start: self.rawBytesForImage!, count: Int(352*288*4))
//            print(buffer[0])
//            print(buffer[1])
//            print("  -")
            

            // also WORKS
//            var data = NSData(bytes: self.rawBytesForImage!, length: Int(352*288*4))

        }
        
//        https://github.com/BradLarson/GPUImage/blob/master/framework/Source/GPUImageLookupFilter.h
//        answer: http://stackoverflow.com/questions/33731637/how-to-create-gpuimage-lookup-png-resource

        
        videoCamera?.addTarget(output)
        videoCamera?.startCameraCapture()
        

        
    }
    
}


struct LastImageData {
    var lastImage:UnsafeMutablePointer<GLubyte>? = nil
    var lastImageSize = CGSizeZero
    var lastImageSizeInBytes:Int = 0
}

var lastImageData = LastImageData()

class MyRawDataOutput : GPUImageRawDataOutput {
    
    var rawInputFilter:GPUImageRawDataInput?
    var last_time = NSDate()
    
    override func newFrameReadyAtTime(frameTime:CMTime, atIndex:Int) {
        super.newFrameReadyAtTime(frameTime, atIndex: atIndex)
        self.lockFramebufferForReading()
        print("YOOO")
        print((NSDate().timeIntervalSinceReferenceDate-self.last_time.timeIntervalSinceReferenceDate)*1000)
        self.last_time = NSDate()
//        print(frameTime)
        
        let data = self.rawBytesForImage
        lastImageData.lastImageSize = self.maximumOutputSize()
        
        if lastImageData.lastImage == nil {
            lastImageData.lastImageSizeInBytes = Int(self.bytesPerRowInOutput() * UInt(lastImageData.lastImageSize.height))
            lastImageData.lastImage = UnsafeMutablePointer<GLubyte>.alloc(lastImageData.lastImageSizeInBytes)
        }
//        memcpy(lastImageData.lastImage!, data, UInt(lastImageData.lastImageSizeInBytes))
        
        self.unlockFramebufferAfterReading()
        
        self.rawInputFilter?.updateDataFromBytes(data, size:lastImageData.lastImageSize)
        self.rawInputFilter?.processDataForTimestamp(frameTime)
        
        //Save image in the album for debug
//        ImageSaver.saveImage(self.lastImage!, width: Int32(self.lastImageSize.width), height: Int32(self.lastImageSize.height))
    }
}

//        Generated from obj c here: https://github.com/BradLarson/GPUImage/issues/946

//        var rawDataOutput: GPUImageRawDataOutput = GPUImageRawDataOutput(imageSize: CGSizeMake(640.0, 480.0), resultsInBGRAFormat: true)
//        self.rawDataOutput = rawDataOutput
//        var outputBytes: GLubyte = rawDataOutput.rawBytesForImage()
//        var bytesPerRow: Int = rawDataOutput.bytesPerRowInOutput()
//        var dataForRawBytes: NSData = NSData.dataWithBytes(outputBytes, length: 480)
//        targetUIImageView.image = UIImage.imageWithData(dataForRawBytes)


//            UTF8String
//            print(self.rawBytesForImage?.successor().memory)
//            for b in self.rawBytesForImage!.memory.stride(through: 10, by: 1) {
//                print(b)
//            }

//            print(self.output!.rawBytesForImage.successor().memory)

//            public var rawBytesForImage: UnsafeMutablePointer<GLubyte> { get }


      