module Admin
  class WordsController < BaseController
    respond_to :html, :js

    def index
      @words = Word.page(params[:page])
      respond_with(@words)
    end

    def new
      @word = Word.new
      respond_with(@word)
    end

    def create
      @words = Word.create_form_list(word_params[:name])
      redirect_to action: :index
    end

    def destroy
      @word = Word.find(params[:id])
      @word.destroy
      respond_with(@word)
    end

    private

    def word_params
      params.require(:word).permit(:name)
    end
  end
end
