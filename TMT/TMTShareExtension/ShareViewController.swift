//
//  ShareViewController.swift
//  TMTShareExtension
//
//  Created by 김유빈 on 11/22/24.
//

import UIKit
import Social

class ShareViewController: SLComposeServiceViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        handleSharedImage()
    }

    private func handleSharedImage() {
        guard let inputItem = self.extensionContext?.inputItems.first as? NSExtensionItem,
              let attachment = inputItem.attachments?.first,
              attachment.hasItemConformingToTypeIdentifier("public.image") else {
            return
        }


        attachment.loadItem(forTypeIdentifier: "public.image", options: nil) { item, error in
            if let error = error {
                self.completeExtensionAndOpenApp()
                return
            }

            if let url = item as? URL { // URL로 처리
                self.handleImageFromURL(url)
            } else if let data = item as? Data, let image = UIImage(data: data) { // Data로 처리
                self.saveImageToApp(image)
            } else {
                self.completeExtensionAndOpenApp()
            }
        }
    }

    private func handleImageFromURL(_ url: URL) {
        // URL에서 이미지를 로드
        do {
            let imageData = try Data(contentsOf: url)
            if let image = UIImage(data: imageData) {
                self.saveImageToApp(image)
            } else {
                self.completeExtensionAndOpenApp()
            }
        } catch {
            self.completeExtensionAndOpenApp()
        }
    }

    private func saveImageToApp(_ image: UIImage) {
        if let imageData = image.jpegData(compressionQuality: 1.0),
           let sharedDefaults = UserDefaults(suiteName: "group.twomanythinking.TMT") {
            sharedDefaults.set(imageData, forKey: "sharedImage")
            sharedDefaults.set(true, forKey: "isShared")
            sharedDefaults.synchronize()
        } else {
        }

        self.completeExtensionAndOpenApp()
    }


    private func completeExtensionAndOpenApp() {
        // TODO: 앱으로 이동하기

        // extension 종료
        self.extensionContext?.completeRequest(returningItems: nil)
    }
}
