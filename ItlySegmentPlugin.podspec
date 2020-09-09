Pod::Spec.new do |spec|
  spec.name         = "ItlySegmentPlugin"
  spec.version      = "0.0.1"
  spec.summary      = "Iteratively Analytics SDK for iOS — Swift & Objective-C"
  spec.description  = <<-DESC
                       Some meaningful desctiption which is longer than summary
                       DESC

  spec.homepage     = "https://iterative.ly"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "Konstantin Dorogan" => "sayd3x@users.noreply.github.com" }
  #spec.source       = { :git => "https://github.com/iterativelyhq/itly-sdk-ios.git", :tag => "v#{spec.version}" }
  spec.source       = { :git => "/Users/saydex/Documents/iteratively_repos/itly-sdk-ios", :tag => "v#{spec.version}" }

  spec.source_files   = 'ItlySegmentPlugin/ItlySegmentPlugin/**/*.{h,swift}'

  spec.ios.deployment_target = '9.0'
  spec.tvos.deployment_target = '9.0'

  spec.framework  = "Foundation"
  spec.dependency "Analytics", "~> 4.0"
  spec.dependency "ItlyCore"

end
