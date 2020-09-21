Pod::Spec.new do |spec|
  spec.name         = "ItlyIterativelyPlugin"
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

  spec.ios.deployment_target = "10.0"
  spec.tvos.deployment_target = "10.0"
  spec.osx.deployment_target = "10.10"

  spec.source_files   = 'ItlyIterativelyPlugin/ItlyIterativelyPlugin/**/*.{h,swift}'
  spec.framework  = "Foundation"
  spec.dependency "ItlyCore"

  spec.swift_version = '4.0'

end
