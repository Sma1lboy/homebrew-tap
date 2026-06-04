cask "wakey" do
  version "0.1.0"
  sha256 "403e5c31b8c1c8345cc03b180b6eea3138b521b9d166f2868c1af349457e6a47"

  url "https://github.com/Sma1lboy/wakey/releases/download/v#{version}/Wakey-#{version}.zip"
  name "Wakey"
  desc "Tiny macOS menu-bar app that force-keeps your Mac awake"
  homepage "https://github.com/Sma1lboy/wakey"

  depends_on macos: ">= :sonoma"

  app "Wakey.app"

  caveats <<~EOS
    Wakey is ad-hoc signed (no Apple Developer ID / notarization yet). If macOS
    blocks it on first launch, either right-click the app and choose Open, or run:
      xattr -dr com.apple.quarantine "#{appdir}/Wakey.app"
  EOS

  zap trash: [
    "~/Library/Preferences/dev.sma1lboy.Wakey.plist",
  ]
end
