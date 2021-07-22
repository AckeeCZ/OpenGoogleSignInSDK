
Pod::Spec.new do |s|
  s.name = "OpenGoogleSignInSDK"
  s.version = "1.1.0"
  s.summary = "OpenGoogleSignInSDK takes care of Google Sign-In flow using OAuth 2.0."
  s.description = <<-DESC
  OpenGoogleSignInSDK is an open-source library which takes care of Google Sign-In flow using OAuth 2.0 and can be used as an alternative to official GoogleSignInSDK
  DESC
  s.homepage = "https://github.com/AckeeCZ/OpenGoogleSignInSDK"
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.authors = { "Ackee" => "info@ackee.cz" }
  s.source = { :git => "https://github.com/AckeeCZ/OpenGoogleSignInSDK.git", :tag => s.version }

  s.ios.deployment_target = "12.0"
  s.osx.deployment_target = "10.15"

  s.swift_version = "5.4.2"

  s.source_files = "Sources/**/*.swift"
end
