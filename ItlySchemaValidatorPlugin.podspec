Pod::Spec.new do |spec|
  spec.name         = "ItlySchemaValidatorPlugin"
  spec.version      = "1.0.2"
  spec.summary      = "Iteratively Schema Validator Plugin"
  spec.description  = <<-DESC
                       Schema validation plugin for Iteratively SDK (Swift & Objective-C)
                       DESC

  spec.homepage     = "https://iterative.ly"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.authors      = { "Iteratively" => "support@iterative.ly",
                        "Justin Fiedler" => "justin@iterative.ly",
                        "Konstantin Dorogan" => "sayd3x@users.noreply.github.com" }
  spec.source       = { :git => "https://github.com/iterativelyhq/itly-sdk-ios.git", :tag => "v#{spec.version}" }

  spec.platform = :ios, '11.0'

  spec.source_files   = 'SchemaValidatorPlugin/SchemaValidatorPlugin/**/*.{h,swift}'
  spec.framework  = "Foundation"
  spec.dependency "DSJSONSchemaValidation", "~> 2.0.0"
  spec.dependency "ItlySdk", "~> 1.0"

  spec.swift_version = '5.3'
  spec.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }

  spec.test_spec do |test_spec|
    test_spec.source_files = 'SchemaValidatorPlugin/SchemaValidatorPluginTests/**/*.{h,swift}'
  end
end
