# frozen_string_literal: true

RSpec.configure do |config|
  config.include RSpec::Rails::RailsExampleGroup, file_path: %r{spec/presenters}
  config.include ActionView::TestCase::Behavior, file_path: %r{spec/presenters}
  config.include RSpec::Rails::Matchers::RenderTemplate, file_path: %r{spec/presenters}
end
