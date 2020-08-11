require 'puppet/resource'

# Monky patch Puppet
class Puppet::Resource
  def to_rspec
    type = self.type.downcase.tr(':', '_')
    puts "it { is_expected.to contain_#{type}('#{title}')"
    properties
    puts '}'
    puts ''
  end

  private

  def properties
    hash = to_hash
    keys = hash.keys
    max_length = keys.map(&:length).max
    hash.each do |k, v|
      case k
      when :name
        # Skip name
        next
      when :require
        [v].flatten.each { |r| puts "  .that_requires('#{r}')" }
      when :before
        [v].flatten.each { |r| puts "  .that_comes_before('#{r}')" }
      when :notify
        [v].flatten.each { |r| puts "  .that_notifies('#{r}')" }
      when :subscribe
        [v].flatten.each { |r| puts "  .that_subscribes_to('#{v}')" }
      else
        val = if v.is_a?(String) && (v.match?(%r{'}) || v.dump[1..-2] != v)
                v.dump
              else
                "'#{v}'"
              end
        puts "  .with(#{("'#{k}'").ljust(max_length + 2)} => #{val})"
      end
    end
  end
end
