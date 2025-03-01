class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.23.29.tar.gz"
  sha256 "f740dbaf74295aadbea90cf12d441ff18b0831f791ee03418655adc43c320e9e"

  bottle do
    cellar :any_skip_relocation
    sha256 "57b1fcab7d023ee01138206f1fe33537bf720312c0e23eaaf4b6aa9c6741f7d1" => :catalina
    sha256 "b82a1d624900ca866fdbc358a560fa9202aa65a57e401e6fca3cf127fde21f6d" => :mojave
    sha256 "798829e597ce63b37690c13ae7202f1a645fe895efee22de61713bc285fd0446" => :high_sierra
    sha256 "223f4d45227786c13b4b328bb6e9c7dc0eaf16c49998c452f646bce2b5e58cf2" => :x86_64_linux
  end

  depends_on "go" => :build
  depends_on "terraform"

  def install
    system "go", "build", "-ldflags", "-X main.VERSION=v#{version}", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
