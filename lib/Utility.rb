require 'digest/sha2'

module Utility
  def make_hashed_password password, salt=""
    hashed_passwd = Digest::SHA256.hexdigest("#{salt}+#{password}")
  end

  module_function :make_hashed_password
end
