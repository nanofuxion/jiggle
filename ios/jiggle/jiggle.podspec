#
# Be sure to run `pod lib lint jiggle.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#


# Read package.json to get metadata
package = JSON.parse(File.read(File.join(__dir__, "..", "..", "package.json")))
author_string = package["author"]
package_description = package["description"]

# Use regex to parse the author string: "Name <email> (url)"
author_match = author_string.match(/(?<name>.*) <(?<email>.*)> \((?<url>.*)\)/)

# Set the author and homepage using the captured groups from the regex
# If the regex doesn't match, provide sensible fallbacks.
author_name = author_match ? author_match[:name] : "Unknown"
author_email = author_match ? author_match[:email] : ""
homepage_url = author_match ? author_match[:url] : "https://github.com"

Pod::Spec.new do |s|
  s.name             = 'jiggle'
  s.version          = package["version"]
  s.summary          = 'A short description of jiggle.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = package_description


  # --- Dynamically Parsed Fields ---
  s.homepage     = homepage_url
  s.authors      = { author_name => author_email }
  # ---------------------------------
  
  s.license      = package["license"]
  s.source       = { :path => '.' }
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '13.0'

  # Include Swift sources and any headers under the Classes directory
  s.source_files = 'jiggle/Classes/**/*'
  
  # s.resource_bundles = {
  #   'jiggle' => ['jiggle/Assets/*.png']
  # }

  # Public headers live in the Classes directory inside the pod
  s.public_header_files = 'jiggle/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency "Lynx"
end
