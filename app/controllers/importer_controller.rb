class ImporterController < ApplicationController
  def form
  end

  def upload
    CSV.parse(params[:csv].read, csv_options) do |row|
      # TODO
    end
  end

  private

  def csv_options
    {
      headers: true,
      header_converters: :symbol,
    }
  end
end
