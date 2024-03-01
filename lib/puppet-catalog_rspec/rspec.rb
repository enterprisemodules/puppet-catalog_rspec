def dump_catalog
  catalogue.to_rspec
end

def rspec_catalog(output = nil)
  o_stdout = $stdout
  if output
    $stdout = File.open(output, 'w+')
  else
    $stdout = StringIO.new
  end
  catalogue.to_rspec
  yield
  $stdout.string
ensure
  $stdout = o_stdout
end
