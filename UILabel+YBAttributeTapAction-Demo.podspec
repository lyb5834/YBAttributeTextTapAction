Pod::Spec.new do |s|
  s.name         = "YBAttributeTextTapAction"
  s.version      = "1.0.0"
  s.summary      = "一行代码添加文本点击事件"
  s.description  = "Code updated by Lyb."
  s.homepage     = "https://github.com/lyb5834/YBAttributeTextTapAction.git"
  s.license      = "MIT"
  s.author       = { "lyb" => "lyb5834@126.com" }
  s.source       = { :git => "https://github.com/lyb5834/YBAttributeTextTapAction.git", :tag => s.version.to_s }
  s.source_files  = "YBAttributeTextTapAction/*.{h,m}"
  s.requires_arc = true
  s.platform     = :ios, '6.0'
end
