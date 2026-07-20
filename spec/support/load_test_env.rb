# Loads optional local test credentials from spec/.env.test (gitignored).
# Existing ENV values are not overwritten, so CLI exports still take precedence.
module ContentstackTestEnv
  ENV_FILE = File.expand_path("../.env.test", __dir__).freeze

  def self.load!
    return unless File.file?(ENV_FILE)

    File.foreach(ENV_FILE) do |line|
      line = line.strip
      next if line.empty? || line.start_with?("#")

      key, value = line.split("=", 2)
      next if key.nil? || value.nil?

      key = key.strip
      value = value.strip.delete_prefix('"').delete_suffix('"')
      ENV[key] = value unless ENV.key?(key) && !ENV[key].to_s.empty?
    end
  end
end

ContentstackTestEnv.load!
