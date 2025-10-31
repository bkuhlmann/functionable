# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "functionable"
  spec.version = "0.0.0"
  spec.authors = ["Brooke Kuhlmann"]
  spec.email = ["brooke@alchemists.io"]
  spec.homepage = "https://alchemists.io/projects/functionable"
  spec.summary = "Enhances modules to be functional by default."
  spec.license = "Hippocratic-2.1"

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/bkuhlmann/functionable/issues",
    "changelog_uri" => "https://alchemists.io/projects/functionable/versions",
    "homepage_uri" => "https://alchemists.io/projects/functionable",
    "funding_uri" => "https://github.com/sponsors/bkuhlmann",
    "label" => "Functionable",
    "rubygems_mfa_required" => "true",
    "source_code_uri" => "https://github.com/bkuhlmann/functionable"
  }

  spec.signing_key = Gem.default_key_path
  spec.cert_chain = [Gem.default_cert_path]

  spec.required_ruby_version = "~> 3.4"

  spec.extra_rdoc_files = Dir["README*", "LICENSE*"]
  spec.files = Dir["*.gemspec", "lib/**/*"]
end
