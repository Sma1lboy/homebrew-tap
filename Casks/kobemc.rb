cask "kobemc" do
  version "0.1.0"

  on_arm do
    sha256 "534edeea07f594362f6944d6766eddcc597a5b511dff3d405d1e1742a62ba300"

    url "https://github.com/Sma1lboy/mc/releases/download/v#{version}/kobeMC_#{version}_aarch64.dmg"
  end
  on_intel do
    sha256 "2d5402e36117ccb28a5ad1c7054778a5d7461046824ab3a48ee5af2bf8fcdda1"

    url "https://github.com/Sma1lboy/mc/releases/download/v#{version}/kobeMC_#{version}_x64.dmg"
  end

  name "kobeMC"
  desc "From-scratch, cross-platform Minecraft launcher"
  homepage "https://github.com/Sma1lboy/mc"

  depends_on macos: :big-sur

  app "kobeMC.app"

  zap trash: [
    "~/Library/Application Support/com.sma1lboy.mclauncher",
    "~/Library/Caches/com.sma1lboy.mclauncher",
    "~/Library/Preferences/com.sma1lboy.mclauncher.plist",
    "~/Library/Saved Application State/com.sma1lboy.mclauncher.savedState",
    "~/Library/WebKit/com.sma1lboy.mclauncher",
  ]

  caveats <<~EOS
    kobeMC is unsigned (no Apple Developer ID / notarization yet). If macOS blocks
    it on first launch, right-click the app and choose Open, or run:
      xattr -dr com.apple.quarantine "#{appdir}/kobeMC.app"
  EOS
end
