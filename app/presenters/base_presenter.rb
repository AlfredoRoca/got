# frozen_string_literal: true

class BasePresenter
  def initialize(object, template)
    @object = object
    @template = template
  end

  private

  class << self
    private

    def presents(name)
      define_method(name) do
        @object
      end
    end
  end

  def method_missing(*args, &block)
    @template.send(*args, &block)
  end

  def h
    @template
  end
end
