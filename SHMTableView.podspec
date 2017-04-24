#
# Be sure to run `pod lib lint SHMTableView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SHMTableView'
  s.version          = '2.0.0'
  s.summary          = 'SHMTableView is a wrapper around UITableView datasource, that helps you define table contents by mapping view types to model instances.'

  s.description      = <<-DESC

HMTableView helps you abstract away the routine stuff in UITableViewDataSource and UITableViewDelegate. Instead you can focus on structure and content to be displayed by UITableView.

To use SHMTableView, you must:

    1. Create data model instances
    2. Map data models to view types
    3. Pass your mapping to the SHMTableView library

SHMTableView creates and configures all UITableViewCell instances to be displayed in UITableView.

                       DESC

  s.homepage         = 'https://github.com/ShowMax/SHMTableView'
  s.license          = { :type => 'Apache', :file => 'LICENSE' }
  s.author           = { 'Showmax' => 'ios@showmax.com' }
  s.source           = { :git => 'https://github.com/ShowMax/SHMTableView.git', :tag => "#{s.version}" }
  s.social_media_url = 'https://twitter.com/showmaxdevs'

  s.platforms = { :ios => "9.0", :tvos => "9.0" }
  s.frameworks = 'UIKit'

  s.source_files = ['Source/*.swift']
end
