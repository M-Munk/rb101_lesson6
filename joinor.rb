# Improved join
# Write a method called joinor that will produce the following result:

# joinor([1, 2])                   # => "1 or 2"
# joinor([1, 2, 3])                # => "1, 2, or 3"
# joinor([1, 2, 3], '; ')          # => "1; 2; or 3"
# joinor([1, 2, 3], ', ', 'and')   # => "1, 2, and 3"

# input - array
# output - string
# assumptions -> method will join array elements with a , and join the last element 
# with and or unless optional parameters are added.  The first optional parameter will
# replace the ,
# The second optional parameter will replace the or
# optional parameters are entered in the form of strings
# the method will need to be passed the board so that it can obtain the empty squares
# prompt "Choose a square (#{empty_squares(brd).join(', ')}): " -> where it will be called from

def joinor(empty, punctuation = ', ', ending = 'or')
  joined = ''
  len = empty.size

  empty.each.with_index do |word, index|
    case len
    when 1
      joined << word.to_s
      break
    when 2
      joined << "#{word} " unless index == empty.size - 1
    else
      joined << "#{word}#{punctuation}" unless index == empty.size - 1
    end
    joined << "#{ending} #{word}" if index == empty.size - 1
  end
  joined
end

p joinor([1])
p joinor([1, 2])                   # => "1 or 2"
p joinor([1, 2, 3])                # => "1, 2, or 3"
p joinor([1, 2, 3], '; ')          # => "1; 2; or 3"
p joinor([1, 2, 3], ', ', 'and')   # => "1, 2, and 3"
