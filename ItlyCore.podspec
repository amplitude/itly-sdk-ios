Pod::Spec.new do |spec|
  spec.name         = "ItlyCore"
  spec.version      = "0.0.1"
  spec.summary      = "Iteratively Analytics SDK for iOS — Swift & Objective-C"
  spec.description  = <<-DESC
                       Some meaningful desctiption which is longer than summary
                       DESC

  spec.homepage     = "https://iterative.ly"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "Konstantin Dorogan" => "sayd3x@users.noreply.github.com" }
  spec.source       = { :git => "https://github.com/iterativelyhq/itly-sdk-ios.git", :tag => "v#{spec.version}" }

  spec.ios.deployment_target = "9.0"
  spec.osx.deployment_target = "10.10"
  spec.watchos.deployment_target = "2.0"
  spec.tvos.deployment_target = "9.0"

  spec.source_files  = 'ItlyCore/itlycore/**/*.{h,swift}'
  spec.framework  = "Foundation"

  spec.swift_version = '5.3'

  spec.test_spec do |test_spec|
    test_spec.ios.deployment_target = "9.0"
    test_spec.osx.deployment_target = "10.10"
    test_spec.tvos.deployment_target = "9.0"

    test_spec.source_files = 'ItlyCore/ItlyCoreTests/**/*.{h,swift}'
  end

end
