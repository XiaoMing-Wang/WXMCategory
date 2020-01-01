Pod::Spec.new do |s|


  s.name         = "WXMCategory"
  s.version      = "1.0.4"
  s.summary      = "类别"
  s.description  = <<-DESC
			一些常用工具类的工具类别
                   DESC

  s.homepage     = "https://github.com/XiaoMing-Wang/WXMCategory"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "wq" => "347511109@qq.com" }
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/XiaoMing-Wang/WXMCategory.git", :tag => "#{s.version}" }

  s.source_files  = "WXMCategory"

  s.requires_arc = true
  #s.dependency "SDWebImage", "~> 4.4.2"

end
