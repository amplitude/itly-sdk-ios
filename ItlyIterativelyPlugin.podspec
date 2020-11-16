Pod::Spec.new do |spec|
  spec.name         = "ItlyIterativelyPlugin"
  spec.version      = "1.0.0"
  spec.summary      = "Iteratively tracker plugin"
  spec.description  = <<-DESC
                       Iteratively tracker plugin for Iteratively SDK (Swift & Objective-C)
                       DESC

  spec.homepage     = "https://iterative.ly"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.authors      = { "Iteratively" => "support@iterative.ly",
                        "Justin Fiedler" => "justin@iterative.ly",
                        "Konstantin Dorogan" => "sayd3x@users.noreply.github.com" }
  spec.source       = { :git => "https://github.com/iterativelyhq/itly-sdk-ios.git", :tag => "v#{spec.version}" }

  spec.ios.deployment_target = "10.0"
  spec.tvos.deployment_target = "10.0"
  spec.watchos.deployment_target = "3.0"
  spec.osx.deployment_target = "10.12"

  spec.source_files   = 'IterativelyPlugin/IterativelyPlugin/**/*.{h,swift}'
  spec.framework  = "Foundation"
  spec.dependency "ItlySdk", "~> 1.0.0"

  spec.swift_version = '5.3'


  spec.test_spec do |test_spec|
    test_spec.ios.deployment_target = "10.0"
    test_spec.osx.deployment_target = "10.12"
    test_spec.tvos.deployment_target = "10.0"

    test_spec.source_files = 'IterativelyPlugin/IterativelyPluginTests/**/*.{h,swift}'
  end

end
