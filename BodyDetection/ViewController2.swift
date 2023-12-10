/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 The sample app's main view controller.
 */

import UIKit
import RealityKit
import ARKit
import Combine

class ViewController2: UIViewController, ARSessionDelegate {
    var scaleData: String = ""
    var numData: String = ""
    
    
    @IBOutlet var arView: ARView!
    
    
    var character: BodyTrackedEntity?// The 3D character to display.//人間と同期するキャラクターを定義
    var character2: BodyTrackedEntity?// The 3D character to display.//人間と同期するキャラクターを定義
    var character3: BodyTrackedEntity?// The 3D character to display.//人間と同期するキャラクターを定義
    var character4: BodyTrackedEntity?// The 3D character to display.//人間と同期するキャラクターを定義
    let characterOffset: SIMD3<Float> = [-1.0, 0, 0] // Offset the character by one meter to the left（カメラで捉えている人間との距離）
    let characterAnchor = AnchorEntity()
    let characterOffset2: SIMD3<Float> = [1.0, 0, 0] // Offset the character by one meter to the left（カメラで捉えている人間との距離）
    let characterAnchor2 = AnchorEntity()
    let characterOffset3: SIMD3<Float> = [-2.0, 0, 0] // Offset the character by one meter to the left（カメラで捉えている人間との距離）
    let characterAnchor3 = AnchorEntity()
    let characterOffset4: SIMD3<Float> = [2.0, 0, 0] // Offset the character by one meter to the left（カメラで捉えている人間との距離）
    let characterAnchor4 = AnchorEntity()
    
    
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
        
        //条件分岐(アンカーと登場するロボット数)
        if numData == "1" {
            arView.scene.addAnchor(characterAnchor)
            
            // Asynchronously load the 3D character.３Dキャラクターの非同期での読み込み
            var cancellable: AnyCancellable? = nil
            cancellable = Entity.loadBodyTrackedAsync(named: "character/originrobot").sink(
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
                        let scale : Float = Float(self.scaleData) ?? 1.0
                        character.scale = [scale, scale, scale]
                        self.character = character
                        cancellable?.cancel()
                    } else {
                        print("Error: Unable to load model as BodyTrackedEntity")
                    }
                })
        }else if numData == "2"{
            arView.scene.addAnchor(characterAnchor)
            arView.scene.addAnchor(characterAnchor2)
            // Asynchronously load the 3D character.３Dキャラクターの非同期での読み込み
            var cancellable: AnyCancellable? = nil
            cancellable = Entity.loadBodyTrackedAsync(named: "character/originrobot").sink(
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
                        let scale : Float = Float(self.scaleData) ?? 1.0
                        character.scale = [scale, scale, scale]
                        self.character = character
                        cancellable?.cancel()
                    } else {
                        print("Error: Unable to load model as BodyTrackedEntity")
                    }
                })
            //2人目の読み込み
            var cancellable2: AnyCancellable? = nil
            cancellable2 = Entity.loadBodyTrackedAsync(named: "character/originrobot").sink(
                //読み込みエラー
                receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        print("Error: Unable to load model: \(error.localizedDescription)")
                    }
                    cancellable2?.cancel()
                    //読み込み成功時
                }, receiveValue: { (character: Entity) in
                    if let character = character as? BodyTrackedEntity {
                        // Scale the character to human size
                        let scale : Float = Float(self.scaleData) ?? 1.0
                        character.scale = [scale, scale, scale]
                        self.character2 = character
                        cancellable2?.cancel()
                    } else {
                        print("Error: Unable to load model as BodyTrackedEntity")
                    }
                })
        }else if numData == "4"{
            arView.scene.addAnchor(characterAnchor)
            arView.scene.addAnchor(characterAnchor2)
            arView.scene.addAnchor(characterAnchor3)
            arView.scene.addAnchor(characterAnchor4)
            // Asynchronously load the 3D character.３Dキャラクターの非同期での読み込み
            var cancellable: AnyCancellable? = nil
            cancellable = Entity.loadBodyTrackedAsync(named: "character/originrobot").sink(
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
                        let scale : Float = Float(self.scaleData) ?? 1.0
                        character.scale = [scale, scale, scale]
                        self.character = character
                        cancellable?.cancel()
                    } else {
                        print("Error: Unable to load model as BodyTrackedEntity")
                    }
                })
            //2人目の読み込み
            var cancellable2: AnyCancellable? = nil
            cancellable2 = Entity.loadBodyTrackedAsync(named: "character/originrobot").sink(
                //読み込みエラー
                receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        print("Error: Unable to load model: \(error.localizedDescription)")
                    }
                    cancellable2?.cancel()
                    //読み込み成功時
                }, receiveValue: { (character: Entity) in
                    if let character = character as? BodyTrackedEntity {
                        // Scale the character to human size
                        let scale : Float = Float(self.scaleData) ?? 1.0
                        character.scale = [scale, scale, scale]
                        self.character2 = character
                        cancellable2?.cancel()
                    } else {
                        print("Error: Unable to load model as BodyTrackedEntity")
                    }
                })
            //3人目の読み込み
            var cancellable3: AnyCancellable? = nil
            cancellable3 = Entity.loadBodyTrackedAsync(named: "character/originrobot").sink(
                //読み込みエラー
                receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        print("Error: Unable to load model: \(error.localizedDescription)")
                    }
                    cancellable3?.cancel()
                    //読み込み成功時
                }, receiveValue: { (character: Entity) in
                    if let character = character as? BodyTrackedEntity {
                        // Scale the character to human size
                        let scale : Float = Float(self.scaleData) ?? 1.0
                        character.scale = [scale, scale, scale]
                        self.character3 = character
                        cancellable3?.cancel()
                    } else {
                        print("Error: Unable to load model as BodyTrackedEntity")
                    }
                })
            //4人目の読み込み
            var cancellable4: AnyCancellable? = nil
            cancellable4 = Entity.loadBodyTrackedAsync(named: "character/originrobot").sink(
                //読み込みエラー
                receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        print("Error: Unable to load model: \(error.localizedDescription)")
                    }
                    cancellable4?.cancel()
                    //読み込み成功時
                }, receiveValue: { (character: Entity) in
                    if let character = character as? BodyTrackedEntity {
                        // Scale the character to human size
                        let scale : Float = Float(self.scaleData) ?? 1.0
                        character.scale = [scale, scale, scale]
                        self.character4 = character
                        cancellable4?.cancel()
                    } else {
                        print("Error: Unable to load model as BodyTrackedEntity")
                    }
                })
        }
        
        
        
        
        
    }
    
    
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        for anchor in anchors {
            guard let bodyAnchor = anchor as? ARBodyAnchor else { continue }
            
            // Update the position of the character anchor's position.
            let bodyPosition = simd_make_float3(bodyAnchor.transform.columns.3)
            
            //条件分岐
            if numData == "1" {
                characterAnchor.position = bodyPosition + characterOffset//ここのオフセットは上記で指定しているもの
                characterAnchor.orientation = Transform(matrix: bodyAnchor.transform).rotation
                if let character = character, character.parent == nil {
                    // Attach the character to its anchor as soon as
                    // 1. the body anchor was detected and
                    // 2. the character was loaded.
                    characterAnchor.addChild(character)
                }
            }else if numData == "2"{
                characterAnchor.position = bodyPosition + characterOffset//ここのオフセットは上記で指定しているもの
                characterAnchor2.position = bodyPosition + characterOffset2//ここのオフセットは上記で指定しているもの
                
                characterAnchor.orientation = Transform(matrix: bodyAnchor.transform).rotation
                characterAnchor2.orientation = Transform(matrix: bodyAnchor.transform).rotation
                
                if let character = character, character.parent == nil {
                    // Attach the character to its anchor as soon as
                    // 1. the body anchor was detected and
                    // 2. the character was loaded.
                    characterAnchor.addChild(character)
                }
                if let character = character2, character.parent == nil {
                    // Attach the character to its anchor as soon as
                    // 1. the body anchor was detected and
                    // 2. the character was loaded.
                    characterAnchor2.addChild(character)
                }
            }else if numData == "4"{
                characterAnchor.position = bodyPosition + characterOffset//ここのオフセットは上記で指定しているもの
                characterAnchor2.position = bodyPosition + characterOffset2//ここのオフセットは上記で指定しているもの
                characterAnchor3.position = bodyPosition + characterOffset3//ここのオフセットは上記で指定しているもの
                characterAnchor4.position = bodyPosition + characterOffset4//ここのオフセットは上記で指定しているもの
                
                characterAnchor.orientation = Transform(matrix: bodyAnchor.transform).rotation
                characterAnchor2.orientation = Transform(matrix: bodyAnchor.transform).rotation
                characterAnchor3.orientation = Transform(matrix: bodyAnchor.transform).rotation
                characterAnchor4.orientation = Transform(matrix: bodyAnchor.transform).rotation
                if let character = character, character.parent == nil {
                    // Attach the character to its anchor as soon as
                    // 1. the body anchor was detected and
                    // 2. the character was loaded.
                    characterAnchor.addChild(character)
                }
                if let character = character2, character.parent == nil {
                    // Attach the character to its anchor as soon as
                    // 1. the body anchor was detected and
                    // 2. the character was loaded.
                    characterAnchor2.addChild(character)
                }
                if let character = character3, character.parent == nil {
                    // Attach the character to its anchor as soon as
                    // 1. the body anchor was detected and
                    // 2. the character was loaded.
                    characterAnchor3.addChild(character)
                }
                if let character = character4, character.parent == nil {
                    // Attach the character to its anchor as soon as
                    // 1. the body anchor was detected and
                    // 2. the character was loaded.
                    characterAnchor4.addChild(character)
                }
                
            }
        }
    }
}
