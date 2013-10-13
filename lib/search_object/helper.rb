module SearchObject
  module Helper
    class << self
      def stringify_keys(hash)
        Hash[(hash || {}).map { |k, v| [k.to_s, v]}]
      end

      def select_keys(hash, keys)
        keys.inject({}) do |memo, key|
          memo[key] = hash[key] if hash.has_key? key
          memo
        end
      end
    end
  end
end
