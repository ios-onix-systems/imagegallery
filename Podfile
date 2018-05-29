platform :ios, '10.0'
use_frameworks!

def available_pods
    pod 'Alamofire', '4.5.1'
    pod 'AlamofireImage', '3.3.0'
    pod 'RxSwift', '~> 4.1.2'
    pod 'RxCocoa', '~> 4.1.2'
    pod 'RxDataSources', '~> 3.0.2'
    pod 'RxCoreData'
    pod 'Fabric'
    pod 'Crashlytics'
    pod 'SkyFloatingLabelTextField', '~> 3.0'
    pod 'IQKeyboardManagerSwift'
    pod 'MBProgressHUD', '1.0.0'
    pod 'SwiftGifOrigin', '~> 1.6.1'
end

app_targets = ['ImageGallery']

app_targets.each do |app_target|
 target app_target do
   available_pods
 end
end

