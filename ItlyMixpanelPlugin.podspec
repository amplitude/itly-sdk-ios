Pod::Spec.new do |spec|
  spec.name         = "ItlyMixpanelPlugin"
  spec.version      = "1.0.2"
  spec.summary      = "Iteratively Mixpanel Plugin"
  spec.description  = <<-DESC
                       Mixpanel plugin for Iteratively SDK (Swift & Objective-C)
                       DESC

  spec.homepage     = "https://iterative.ly"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.authors      = { "Iteratively" => "support@iterative.ly",
                        "Justin Fiedler" => "justin@iterative.ly",
                        "Konstantin Dorogan" => "sayd3x@users.noreply.github.com" }
  spec.source       = { :git => "https://github.com/iterativelyhq/itly-sdk-ios.git", :tag => "v#{spec.version}" }

  spec.ios.deployment_target = "11.0"
  spec.tvos.deployment_target = "11.0"
  spec.osx.deployment_target = "10.12"
  spec.watchos.deployment_target = "6.2"

  spec.source_files   = 'MixpanelPlugin/MixpanelPlugin/**/*.{h,swift}'
  spec.frameworks  = "Foundation"
  spec.dependency "Mixpanel-swift", "~> 2.7.0"
  spec.dependency "ItlySdk", "~> 1.0"

  spec.swift_version = '5.3'
  spec.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
end
