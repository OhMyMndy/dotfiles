def get_commands_from_commands_file commands_file
    file_name = File.expand_path '~/commands.json'
    commands = JSON.parse(File.read file_name)
    commands = Hash.to_dotted_hash commands
    commands = commands.to_a.map { |pair| [pair.first.downcase, pair.last] }.to_h
end


class Hash
    def self.to_dotted_hash(hash, recursive_key = "")
       hash.each_with_object({}) do |(k, v), ret|
         key = recursive_key + k.to_s
         key.gsub! ' ', '_'
         if v.is_a? Hash
           ret.merge! to_dotted_hash(v, key + ".")
         else
           ret[key] = v
         end
       end
    end
end