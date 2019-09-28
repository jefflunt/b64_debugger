CONVERTER = [
  ('A'..'Z').to_a,
  ('a'..'z').to_a,
  (0..9).to_a.map{|i| i.to_s},
  '+', '/', '='
].flatten

def ubs_format(bit_str)
  bit_str
    .scan(/.{1,8}/m)
    .join(' ')
end

def bbs_format(bit_str)
  bit_str
    .scan(/.{1,6}/m)
    .join(' ')
end

def char_to_bits(c)
  ord_bits = c
    .ord
    .to_s(2)

  ord_length = (ord_bits.length / 8.0).ceil * 8
  ord_bits
    .rjust(ord_length, '0')
end

def utf8_to_bit_str(utf8)
  utf8
    .bytes
    .map{|b| b.to_s(2).rjust(8, '0') }
    .join
end

def bit_str_to_b64(bit_str)
  non_padded = bit_str
    .scan(/.{1,6}/m)
    .map{|bits| CONVERTER[bits.ljust(6, '0').to_i(2)] }
    .join

  padded_length = (non_padded.length / 4.0).ceil * 4
  non_padded.ljust(padded_length, '=')
end

def b64_to_bit_str(b64)
  bit_str = ''
  b64
    .chars
    .map{|c| CONVERTER.index(c) }
    .map{|i| i.to_s(2).rjust(6, '0') }
    .join
end

def bit_str_to_utf8(bit_str)
  bit_str
    .scan(/.{1,8}/m)
    .map{|byte_str| byte_str.to_i(2) }
    .pack('c*')
    .force_encoding('UTF-8')
end

utf8_in = STDIN.read
bit_str8 = utf8_to_bit_str(utf8_in)
b64 = bit_str_to_b64(bit_str8)
bit_str6 = b64_to_bit_str(b64)
utf8_out = bit_str_to_utf8(bit_str6)

puts "->        UTF-8: #{utf8_in}"
puts "-> 8-bit binary: #{ubs_format(bit_str8)}"
puts "-> 6-bit binary: #{bbs_format(bit_str8)}"
puts "->       Base64: #{b64}"
puts "-> 6-bit binary: #{bbs_format(bit_str6)}"
puts "-> 8-bit binary: #{ubs_format(bit_str6)}"
puts "->        UTF-8: #{utf8_out}"
