cask "restguard" do
  version "0.1.17"

  on_macos do
    sha256 "a10d48f356b6a647b119374d08df5564455a7f31071b051628b7fe6920bba267"

    url "https://github.com/HansTanzi/RestGuard/releases/download/v#{version}/RestGuard_#{version}_universal.zip"

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
  # 用 Arch 包（只是 zstd 压缩的 tar），取其中通用的可执行文件，依赖的系统库需用户自行安装（见 caveats）。
  # 用 artifact 移动到固定路径而不是 binary 符号链接：开机自启记录的是解析后的可执行文件路径，
  # 指向 Caskroom 里带版本号的目录的话，升级后自启会失效
  on_linux do
    sha256 "cf1fc71dec2f08ae7805580b84c4185c0b65906b491c98697d94883bce756c2f"

    url "https://github.com/HansTanzi/RestGuard/releases/download/v#{version}/RestGuard_#{version}_x86_64.pkg.tar.zst"

    depends_on arch: :x86_64

    artifact "usr/bin/restguard", target: "#{HOMEBREW_PREFIX}/bin/restguard"

    zap trash: [
      "~/.cache/io.github.restguard",
      "~/.config/autostart/RestGuard.desktop",
      "~/.config/io.github.restguard",
      "~/.local/share/io.github.restguard",
    ]

    caveats <<~EOS
      RestGuard needs WebKitGTK 4.1 and libayatana-appindicator from your distro:
        Debian/Ubuntu: sudo apt install libwebkit2gtk-4.1-0 libayatana-appindicator3-1
        Fedora:        sudo dnf install webkit2gtk4.1 libayatana-appindicator-gtk3
        Arch:          sudo pacman -S webkit2gtk-4.1 libayatana-appindicator
        openSUSE:      sudo zypper install libwebkit2gtk-4_1-0 libayatana-appindicator3-1

      Run `restguard` to start it, then enable "Start at login" from the tray menu.
    EOS
  end

  name "RestGuard"
  desc "Break reminder that actually makes you rest"
  homepage "https://github.com/HansTanzi/RestGuard"

  livecheck do
    url :url
    strategy :github_latest
  end
end
