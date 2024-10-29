require 'json'
require 'base64'

# Function to recursively encode binary data as Base64 in a Ruby object
def encode_binary_data(obj)
  case obj
  when String
    # Check if the string is valid UTF-8
    if obj.encoding == Encoding::BINARY || !obj.valid_encoding?
      # Encode binary data to Base64
      Base64.encode64(obj)
    else
      obj
    end
  when Array
    obj.map { |el| encode_binary_data(el) }
  when Hash
    obj.each_with_object({}) do |(k, v), new_hash|
      new_hash[k] = encode_binary_data(v)
    end
  else
    obj
  end
end

# Load the minter-state file
minter_state_path = 'hyraxData/minter-state'
minter_state = Marshal.load(File.binread(minter_state_path))

# Encode any binary data to Base64
encoded_minter_state = encode_binary_data(minter_state)

# Write the encoded data to JSON file
File.open("minter_state.json", "w") do |f|
  f.write(encoded_minter_state.to_json)
end

