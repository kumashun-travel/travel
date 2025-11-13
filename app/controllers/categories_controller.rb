class CategoriesController < ApplicationController

  def show
    @category = Category.find(params[:id])
    @tweets = @category.tweets.includes(:tags, :user)

    if params[:search].present?
      keyword = params[:search].strip
      @tweets = @tweets.where("place_name LIKE ? OR location LIKE ?", "%#{keyword}%", "%#{keyword}%")
    end

    if params[:tag_search].present?
      tag_keywords = params[:tag_search].split(/[,\s　，]+/).map(&:strip).reject(&:blank?)
      tweet_ids = Tag.joins(:tweets)
                       .where(
                         tag_keywords.map { "tags.name LIKE ?" }.join(" OR "),
                         *tag_keywords.map { |kw| "%#{kw}%" }
                       )
                       .pluck("tweets.id")
                       .uniq
       @tweets = Tweet.where(id: tweet_ids).includes(:tags)
    end
  end

end
