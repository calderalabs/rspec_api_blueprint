unless "".respond_to?(:indent)
  class String
    def indent(count, char = ' ')
      gsub(/([^\n]*)(\n|$)/) do |match|
        last_iteration = ($1 == "" && $2 == "")
        line = ""
        line << (char * count) unless last_iteration
        line << $1
        line << $2
        line
      end
    end
  end
end