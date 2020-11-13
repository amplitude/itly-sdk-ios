Pod::Spec.new do |spec|
  spec.name         = "ItlySegmentPlugin"
  spec.version      = "0.0.1"
  spec.summary      = "Iteratively Analytics SDK for iOS — Swift & Objective-C"
  spec.description  = <<-DESC
                       Segment plugin for Iteratively SDK
                       DESC

  spec.homepage     = "https://iterative.ly"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.authors      = { "Iteratively" => "support@iterative.ly",
                        "Justin Fiedler" => "justin@iterative.ly",
                        "Konstantin Dorogan" => "sayd3x@users.noreply.github.com" }
  spec.source       = { :git => "https://github.com/iterativelyhq/itly-sdk-ios.git", :tag => "v#{spec.version}" }

  spec.source_files   = 'SegmentPlugin/SegmentPlugin/**/*.{h,swift}'

  spec.ios.deployment_target = '11.0'
  spec.tvos.deployment_target = '13.4'

  spec.framework  = "Foundation"
  spec.dependency "Analytics", "~> 4.0.0"
  spec.dependency "ItlySdk"

  spec.swift_version = '5.3'

end
