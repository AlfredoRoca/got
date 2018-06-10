# frozen_string_literal: true

class ImporterController < ApplicationController
  def form; end

  def upload
    @importer_result = []

    CSV.parse(params[:csv].read, csv_options) do |row|
      @importer_result.push Character.create_with(row)
    end
  end

  private

  def csv_options
    {
      headers: true,
      header_converters: :symbol
    }
  end
end
