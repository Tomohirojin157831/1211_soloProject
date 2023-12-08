/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The sample app's main view controller.
*/

import UIKit
import RealityKit
import ARKit
import Combine

class ViewController: UIViewController, ARSessionDelegate {

    @IBOutlet var arView: ARView!
    
    
    var character: BodyTrackedEntity?// The 3D character to display.//人間と同期するキャラクターを定義
    let characterOffset: SIMD3<Float> = [-1.0, 0, 0] // Offset the character by one meter to the left（カメラで捉えている人間との距離）
    let characterAnchor = AnchorEntity()
    
//    // Storyboardに変えてARViewをセッティング(ここはビデオを見て追加。下とのコンフリクトをどうするか)→今回はいらない
//    override func viewDidLoad() {
//            super.viewDidLoad()
//            arView = ARView(frame: CGRect.zero,cameraMode: .ar,automaticallyConfigureSession: true)
//            self.view = arView

    
    
    //viewDisAppearメソッドは画面表示直後に呼ばれる・・・チップが対応しているかを確認しているだけなので不要
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        arView.session.delegate = self
        
        // If the iOS device doesn't support body tracking, raise a developer error for
        // this unhandled case.
        //チップA12以上でない場合、エラーとなる。
        guard ARBodyTrackingConfiguration.isSupported else {
            fatalError("This feature is only supported on devices with an A12 chip")
        }
        

        // Run a body tracking configration.ARKitを使用して人物のボディトラッキングの設定を行い、ARセッションで実行。
        //ARBodyTrackingConfigurationは、ARKitが人物の骨格を検出して追跡するための設定を提供します。この設定をARセッションに適用することで、AR空間内でカメラが捉えた映像から人物の骨格をトラッキングし、リアルタイムでその動きを把握することができます。
        let configuration = ARBodyTrackingConfiguration()
        arView.session.run(configuration)
        
        arView.scene.addAnchor(characterAnchor)
        
        // Asynchronously load the 3D character.３Dキャラクターの非同期での読み込み
        var cancellable: AnyCancellable? = nil
        cancellable = Entity.loadBodyTrackedAsync(named: "character/robot").sink(
            //読み込みエラー
            receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Error: Unable to load model: \(error.localizedDescription)")
                }
                cancellable?.cancel()
                //読み込み成功時
        }, receiveValue: { (character: Entity) in
            if let character = character as? BodyTrackedEntity {
                // Scale the character to human size
                character.scale = [1.0, 1.0, 1.0]
                self.character = character
                cancellable?.cancel()
            } else {
                print("Error: Unable to load model as BodyTrackedEntity")
            }
        })
    }
        
        
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        for anchor in anchors {
            guard let bodyAnchor = anchor as? ARBodyAnchor else { continue }
            
            // Update the position of the character anchor's position.
            let bodyPosition = simd_make_float3(bodyAnchor.transform.columns.3)
            characterAnchor.position = bodyPosition + characterOffset//ここのオフセットは上記で指定しているもの
            // Also copy over the rotation of the body anchor, because the skeleton's pose
            // in the world is relative to the body anchor's rotation.
            characterAnchor.orientation = Transform(matrix: bodyAnchor.transform).rotation
   
            if let character = character, character.parent == nil {
                // Attach the character to its anchor as soon as
                // 1. the body anchor was detected and
                // 2. the character was loaded.
                characterAnchor.addChild(character)
            }
        }
    }
}
