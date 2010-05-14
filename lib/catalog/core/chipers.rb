require 'md5'

module Catalog::Core
  class MD5Cipher
    def process(str)
      MD5.new(str).to_s
    end
  end

  class StubCipher
    def process(str)
      str     
    end
  end
end