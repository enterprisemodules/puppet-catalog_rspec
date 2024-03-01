require 'puppet/resource'

# Monky patch Puppet
class Puppet::Resource
  @@rspec_that = {
    require: 'requires',
    before: 'comes_before',
    notify: 'notifies',
    subscribe: 'subscribes_to',
  }

  def to_rspec
    type = self.type.downcase.tr(':', '_')
    props = rspec_properties

    if props[:that].empty? && props[:with].empty?
      puts "it { is_expected.to contain_#{type}('#{title}') }"
    else
      puts "it {"
      puts "  is_expected.to contain_#{type}('#{title}')"
      puts props[:that].join("\n") unless props[:that].empty?
      if props[:with].size.eql?(1)
        puts "    .with(#{props[:with][0]})"
      elsif !props[:with].empty?
        puts "    .with("
        props[:with].each { |prop| puts "      #{prop}," }
        puts "    )"
      end
      puts '}'
    end
    puts ''
  end

  private

  def rspec_value(v)
    if v.is_a?(String)
      (v.dump[1..-2] != v) ? v.dump : "'#{v}'"
    else
      v.inspect
    end
  end

  def rspec_properties
    props = {
      that: [],
      with: [],
    }
    hash = to_hash
    keys = hash.keys
    max_length = keys.map(&:length).max

    hash.each do |k, v|
      next if k.eql?(:name)

      if @@rspec_that[k]
        [v].flatten.each { |r| props[:that] << "    .that_#{@@rspec_that[k]}('#{r}')" }
      else
        props[:with] << "#{(k.to_s + ':').ljust(max_length + 1)} #{rspec_value(v)}"
      end
    end

    props
  end
end
