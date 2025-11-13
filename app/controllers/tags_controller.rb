class TagsController < ApplicationController
    def show
      @tag = Tag.find(params[:id])
      @tweets = @tag.tweets.includes(:user).order(created_at: :desc)
    

      if params[:search].present?
        keyword = params[:search].strip
        @tweets = @tweets.where("place_name LIKE ? OR location LIKE ?", "%#{keyword}%", "%#{keyword}%")
      end
    end
end
