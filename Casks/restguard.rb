cask "restguard" do
  version "0.1.9"
  sha256 "268f41682bcd55bc3f21c058132e3b72e71d31cb058b4b4c75b458052ea67872"

  url "https://github.com/HansTanzi/RestGuard/releases/download/v#{version}/RestGuard_#{version}_universal.zip"
  name "RestGuard"
  desc "Break reminder that actually makes you rest"
  homepage "https://github.com/HansTanzi/RestGuard"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on :macos

  app "RestGuard.app"

  # 应用只做了 ad-hoc 签名、未经 Apple 公证，去掉隔离属性，否则 Gatekeeper 会拒绝打开
  postflight_steps do
    run "/usr/bin/xattr",
        args:           ["-dr", "com.apple.quarantine", "{{appdir}}/RestGuard.app"],
        writable_paths: ["RestGuard.app"],
        writable_base:  :appdir
  end

  uninstall quit: "io.github.restguard"

  zap trash: [
    "~/Library/Application Support/io.github.restguard",
    "~/Library/Caches/io.github.restguard",
    "~/Library/LaunchAgents/RestGuard.plist",
    "~/Library/WebKit/io.github.restguard",
  ]
end
