cask "restguard" do
  version "0.1.6"
  sha256 "e0291ca24c539d4fb57ca5cae713e484ca55047c7bada5bd8765fcf22aea4428"

  url "https://github.com/HansTanzi/RestGuard/releases/download/v#{version}/RestGuard_#{version}_universal.zip"
  name "RestGuard"
  desc "Break reminder that actually makes you rest"
  homepage "https://github.com/HansTanzi/RestGuard"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "RestGuard.app"

  # 应用只做了 ad-hoc 签名、未经 Apple 公证，去掉隔离属性，否则 Gatekeeper 会拒绝打开
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/RestGuard.app"]
  end

  uninstall quit: "io.github.restguard"

  zap trash: [
    "~/Library/Application Support/io.github.restguard",
    "~/Library/Caches/io.github.restguard",
    "~/Library/LaunchAgents/RestGuard.plist",
    "~/Library/WebKit/io.github.restguard",
  ]
end
