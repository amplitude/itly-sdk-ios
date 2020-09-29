Pod::Spec.new do |spec|
  spec.name         = "ItlyMixpanelPlugin"
  spec.version      = "0.0.1"
  spec.summary      = "Iteratively Analytics SDK for iOS — Swift & Objective-C"
  spec.description  = <<-DESC
                       Some meaningful desctiption which is longer than summary
                       DESC

  spec.homepage     = "https://iterative.ly"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "Konstantin Dorogan" => "sayd3x@users.noreply.github.com" }
  spec.source       = { :git => "https://github.com/iterativelyhq/itly-sdk-ios.git", :tag => "v#{spec.version}" }

  spec.ios.deployment_target = "11.0"
  spec.tvos.deployment_target = "11.0"
  spec.osx.deployment_target = "10.12"
  spec.watchos.deployment_target = "6.2"

  spec.source_files   = 'ItlyMixpanelPlugin/ItlyMixpanelPlugin/**/*.{h,swift}'
  spec.frameworks  = "Foundation"
  spec.dependency "Mixpanel-swift", "~> 2.7"
  spec.dependency "ItlyCore"

  spec.swift_version = '5.3'

end
