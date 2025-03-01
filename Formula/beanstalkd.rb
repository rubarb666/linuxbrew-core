class Beanstalkd < Formula
  desc "Generic work queue originally designed to reduce web latency"
  homepage "https://beanstalkd.github.io/"
  url "https://github.com/beanstalkd/beanstalkd/archive/v1.12.tar.gz"
  sha256 "f43a7ea7f71db896338224b32f5e534951a976f13b7ef7a4fb5f5aed9f57883f"

  bottle do
    cellar :any_skip_relocation
    sha256 "eb308ce225c6f335a5a27518b63f8ce70caa263e94afbb7d9c2bb9000c12d974" => :catalina
    sha256 "da06f9b4142a163f26de89e5d67c729fd4edd9fbd2dcf3ada91507f92f45ec93" => :mojave
    sha256 "d57a1db5de295181c1f5596951160cc65b7f27645806fb35834f6409cbc57a6e" => :high_sierra
    sha256 "71c624737a869ad08a91ab865c6a353fb63cbcb5313e18e1294424321e3458c9" => :x86_64_linux
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  plist_options :manual => "beanstalkd"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>KeepAlive</key>
          <true/>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/beanstalkd</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>KeepAlive</key>
          <true/>
          <key>WorkingDirectory</key>
          <string>#{var}</string>
          <key>StandardErrorPath</key>
          <string>#{var}/log/beanstalkd.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/beanstalkd.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    system "#{bin}/beanstalkd", "-v"
  end
end
