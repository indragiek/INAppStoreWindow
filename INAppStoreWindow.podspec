Pod::Spec.new do |s|
  s.name         = 'INAppStoreWindow'
  s.version      = '1.5'
  s.summary      = 'Mac App Store style NSWindow subclass.'
  s.homepage     = 'https://github.com/indragiek/INAppStoreWindow'
  s.author       = { 'Indragie Karunaratne' => 'i@indragie.com' }
  s.source_files = 'INAppStoreWindow'
  s.source       = { :git => 'https://github.com/indragiek/INAppStoreWindow.git', :tag => 'v1.5' }
  s.platform     = :osx
  s.requires_arc = true
  s.license      = { :type => 'BSD', :text => 'INAppStoreWindow is licensed under the BSD license.'}

  default_subspec = 'INAppStoreWindow/Core'

  s.subspec 'Core' do |core|
    core.source_files  = 'INAppStoreWindow/*.{h,m}'
    core.header_dir    = 'INAppStoreWindow'
    core.exclude_files = 'INAppStoreWindow/Extensions/**'
    core.requires_arc  = true
  end

  s.subspec 'Swizzling' do |swizzling|
    swizzling.dependency 'INAppStoreWindow/Core'

    swizzling.source_files = 'INAppStoreWindow/Extensions/INAppStoreWindowSwizzling.{c,h}'
    swizzling.requires_arc = true
  end

  s.subspec 'CoreUIRendering' do |coreuirendering|
    coreuirendering.dependency 'INAppStoreWindow/Swizzling'

    coreuirendering.source_files = 'INAppStoreWindow/Extensions/INWindowBackgroundView+CoreUIRendering.{h,m}'
    coreuirendering.requires_arc = true
  end

  s.subspec 'NSDocumentFixes' do |nsdocumentfixes|
    nsdocumentfixes.dependency 'INAppStoreWindow/Swizzling'

    nsdocumentfixes.source_files = 'INAppStoreWindow/Extensions/NSDocument+INAppStoreWindowFixes.{h,m}'
    nsdocumentfixes.requires_arc = true
  end
end
