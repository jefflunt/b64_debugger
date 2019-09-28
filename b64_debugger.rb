CONVERTER = [
  ('A'..'Z').to_a,
  ('a'..'z').to_a,
  (0..9).to_a.map{|i| i.to_s},
  '+', '/'
].flatten

def abs_format(bit_str)
  bit_str
    .scan(/.{1,8}/m)
    .join(' ')
end

def bbs_format(bit_str)
  bit_str
    .scan(/.{1,6}/m)
    .join(' ')
end

def ascii_to_bit_str(ascii)
  ascii
    .chars
    .map{|c| c.ord.to_s(2).rjust(8, '0') }
    .join
end

def bit_str_to_b64(bit_str)
  bit_str
    .scan(/.{1,6}/m)
    .map{|bits| CONVERTER[bits.to_i(2)] }
    .join
end

def b64_to_bit_str(b64)
  bit_str = ''
  b64
    .chars
    .map{|c| CONVERTER.index(c) }
    .map{|i| i.to_s(2).rjust(6, '0') }
    .join
end

def bit_str_to_ascii(bit_str)
  bit_str
    .scan(/.{1,8}/m)
    .map{|bits| bits.to_i(2).chr }
    .join
end

ascii_in = ARGV.join(' ')
bit_str8 = ascii_to_bit_str(ascii_in)
b64 = bit_str_to_b64(bit_str8)
bit_str6 = b64_to_bit_str(b64)
ascii_out = bit_str_to_ascii(bit_str6)

puts "ASC: #{ascii_in}"
puts "A>8: #{abs_format(bit_str8)}"
puts "8>6: #{bbs_format(bit_str8)}"
puts "6>B: #{b64}"
puts "B>6: #{bbs_format(bit_str6)}"
puts "6>8: #{abs_format(bit_str6)}"
puts "8>A: #{ascii_out}"
