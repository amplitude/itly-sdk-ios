Pod::Spec.new do |spec|
  spec.name         = "ItlySegmentPlugin"
  spec.version      = "1.2.1"
  spec.summary      = "Iteratively Segment plugin"
  spec.description  = <<-DESC
                       Segment plugin for Iteratively SDK (Swift & Objective-C)
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
  spec.dependency "Analytics", "~> 4.1"
  spec.dependency "ItlySdk", "~> 1.0"

  spec.swift_version = '5.3'
  spec.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
end
