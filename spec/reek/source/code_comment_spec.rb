require File.join(File.dirname(File.dirname(File.dirname(File.expand_path(__FILE__)))), 'spec_helper')
require File.join(File.dirname(File.dirname(File.dirname(File.dirname(File.expand_path(__FILE__))))), 'lib', 'reek', 'source', 'code_comment')

include Reek::Source

describe CodeComment do
  context 'comment checks' do
    it 'rejects no comment' do
      CodeComment.new('').is_descriptive?.should be_false
    end
    it 'rejects an empty comment' do
      CodeComment.new('#').is_descriptive?.should be_false
    end
    it 'rejects a 1-word comment' do
      CodeComment.new("# fred\n#  ").is_descriptive?.should be_false
    end
    it 'accepts a 2-word comment' do
      CodeComment.new('# fred here  ').is_descriptive?.should be_true
    end
    it 'accepts a multi-word comment' do
      CodeComment.new("# fred here \n# with \n   # biscuits ").is_descriptive?.should be_true
    end
  end

  context 'comment config' do
    it 'parses hashed options' do
      config = CodeComment.new("# :reek:Duplication: { enabled: false }").config
      config.should include('Duplication')
      config['Duplication'].should include('enabled')
      config['Duplication']['enabled'].should be_false
    end
    it 'parses hashed options with ruby names' do
      config = CodeComment.new("# :reek:nested_iterators: { enabled: true }").config
      config.should include('NestedIterators')
      config['NestedIterators'].should include('enabled')
      config['NestedIterators']['enabled'].should be_true
    end
    it 'parses multiple hashed options' do
      config = CodeComment.new("# :reek:Duplication: { enabled: false }\n:reek:nested_iterators: { enabled: true }").config
      config.should include('Duplication','NestedIterators')
      config['Duplication'].should include('enabled')
      config['Duplication']['enabled'].should be_false
      config['NestedIterators'].should include('enabled')
      config['NestedIterators']['enabled'].should be_true
    end
    it 'parses multiple hashed options on the same line' do
      config = CodeComment.new("# :reek:Duplication: { enabled: false } and :reek:nested_iterators: { enabled: true }").config
      config.should include('Duplication','NestedIterators')
      config['Duplication'].should include('enabled')
      config['Duplication']['enabled'].should be_false
      config['NestedIterators'].should include('enabled')
      config['NestedIterators']['enabled'].should be_true
    end
    it 'disables the smell if no options are specifed' do
      config = CodeComment.new("# :reek:Duplication").config
      config.should include('Duplication')
      config['Duplication'].should include('enabled')
      config['Duplication']['enabled'].should be_false
    end
  end
end
