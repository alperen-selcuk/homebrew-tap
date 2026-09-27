cask "colima-desktop" do
  version "0.1.2"
  sha256 "6ebc764c4e51e17672ad403a1e476d974da268aaa4844983567e13eed9a324fd"

  url "https://github.com/alperen-selcuk/colima-desktop/releases/download/v#{version}/Colima.Desktop_#{version}_universal.dmg"
  name "Colima Desktop"
  desc "Desktop GUI for managing Colima container runtimes"
  homepage "https://github.com/alperen-selcuk/colima-desktop"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on formula: "colima"
  depends_on formula: "docker"
  depends_on :macos

  app "Colima Desktop.app"

  # The current builds are unsigned/unnotarized (no Apple Developer ID is
  # configured yet), so Gatekeeper quarantines the app on first launch.
  # Remove this postflight once release builds are signed and notarized.
  postflight_steps do
    run "/usr/bin/xattr",
        args: ["-dr", "com.apple.quarantine", "{{appdir}}/Colima Desktop.app"],
        sudo: false
  end

  uninstall quit: "dev.colima.desktop"

  zap trash: [
    "~/Library/Application Support/dev.colima.desktop",
    "~/Library/Caches/dev.colima.desktop",
    "~/Library/Preferences/dev.colima.desktop.plist",
    "~/Library/Saved Application State/dev.colima.desktop.savedState",
    "~/Library/WebKit/dev.colima.desktop",
  ]

  caveats <<~EOS
    Colima Desktop drives the `colima` CLI and needs it (plus `docker`) on your PATH;
    both are installed automatically as dependencies of this cask.

    For the Kubernetes view, also install kubectl:
      brew install kubectl
  EOS
end
