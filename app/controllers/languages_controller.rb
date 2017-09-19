class LanguagesController < ApplicationController
  def index
    @languages = Language.search(params[:query])
  end

  def search
    render json: Language.search(params[:query])
  end
end
