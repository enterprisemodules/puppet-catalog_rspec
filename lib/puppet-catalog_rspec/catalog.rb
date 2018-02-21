require 'puppet/resource/catalog'

# Monky patch Puppet
class Puppet::Resource::Catalog
  def to_rspec
    resources.each do |resource|
      next if filtered?(resource.to_s)
      resource.to_rspec
    end
  end

  private

  def filtered?(klass)
    ['Class[main]', 'Stage[main]'].include?(klass)
  end

end
