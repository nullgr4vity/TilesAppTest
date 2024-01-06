//
//  ZoomableViewcontroller.swift
//  TilesAppTest
//
//

import UIKit

class ZoomableImageViewController: UIViewController, CALayerDelegate {
    var contentView: ImageContentView!
    
    var imageSize = CGSizeZero
    
    let maxZoomScale = 1.0
    let minZoomScale = 0.2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView = ImageContentView(frame: view.bounds)
        
        view.addSubview(contentView)
        self.imageSize = CGSize(width: 10000, height: 8000);
        contentView.imageSize = imageSize

        contentView.backgroundColor = .white
                
        configureGestures()
        
    }
    
    private func configureGestures() {
        let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(recognizer:)))
        contentView.addGestureRecognizer(pinchRecognizer)
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(recognizer:)))
        contentView.addGestureRecognizer(panRecognizer)
    }
    
    func translate(o: CGPoint, t: CGPoint) -> CGPoint {
        
        var tmp = CGPoint(x: o.x - t.x, y: o.y - t.y)
        
        let maxW = imageSize.width - contentView.bounds.width
        let maxH = imageSize.height - contentView.bounds.height
        
        tmp.x = min(max(tmp.x, 0), maxW)
        tmp.y = min(max(tmp.y, 0), maxH)
        
        return tmp;
    }
    
    @objc func handlePanGesture(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: view)
        recognizer.setTranslation(CGPoint.zero, in: view)
        
        if recognizer.state == .began || recognizer.state == .changed {
                        
            let newOffset = translate(o: contentView.offset, t: translation)

            self.contentView.updateOffset(offset: newOffset)
        }
    }
    
    @objc func handlePinchGesture(recognizer: UIPinchGestureRecognizer) {
        if recognizer.state == .began || recognizer.state == .changed {
            let scale = recognizer.scale
            recognizer.scale = 1.0
            
            let newScale = self.contentView.scale * scale
            
            if (newScale > maxZoomScale) || (newScale < minZoomScale) {
                return
            }
                        
            let offset = contentView.offset
            let fpInView = recognizer.location(in: contentView)
            let fp = CGPoint(x: fpInView.x - offset.x, y: fpInView.y - offset.y)
            
            let newOffsetX = fp.x - (fp.x - offset.x) * scale
            let newOffsetY = fp.y - (fp.y - offset.y) * scale
                        
            let p = CGPoint(x: newOffsetX, y: newOffsetY)
            
            self.contentView.updateOffsetAndScale(offset: p, scale: newScale)
        }
    }
    
}
