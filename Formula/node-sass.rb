class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.26.9.tgz"
  sha256 "c97474f4897ef0d85e20893b9f8587903e04e5bfd74d489d493b509b124dbeff"

  bottle do
    cellar :any_skip_relocation
    sha256 "d537d2b694e096afcd4a60d5ad23c14eecb947622a57b68bf8711a5376e9ebdf" => :catalina
    sha256 "5aa46ab77bb306f631759a1cfd502191e8071e3ab4fd3253431dbdd3a03379f1" => :mojave
    sha256 "4fbb3afabbb12ae7bc1cc3c536e48992e67941f803c5eb510dbc9f0c796f2d17" => :high_sierra
    sha256 "88e5165bbaaf1d7c3fd905f21922af0e863af861963c6b09069f7f9ac82d247d" => :x86_64_linux
  end

  depends_on "node"

  # waiting for pull request at #47438
  # conflicts_with "dart-sass", :because => "both install a `sass` binary"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.scss").write <<~EOS
      div {
        img {
          border: 0px;
        }
      }
    EOS

    assert_equal "div img{border:0px}",
    shell_output("#{bin}/sass --style=compressed test.scss").strip
  end
end
