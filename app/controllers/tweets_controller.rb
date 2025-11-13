class TweetsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def index
    if params[:search].present?
      search = params[:search]
      @tweets = Tweet.joins(:user).where("place_name LIKE ? OR location LIKE ?", "%#{search}%", "%#{search}%")
    else
      @tweets = Tweet.order(created_at: :desc).limit(3)
    end

    if params[:tag_search].present?
       tag_keywords = params[:tag_search].split(/[,\s　，]+/).map(&:strip).reject(&:blank?)

         @tweets = Tweet.joins(:tags)
                 .where(
                   tag_keywords.map { |kw| "tags.name LIKE ?" }.join(" OR "),
                   *tag_keywords.map { |kw| "%#{kw}%" }
                 )
                 .distinct
    end

    @random_knowledge_tweet = Tweet
    .where.not(knowledge: [nil, ""])
    .order("RANDOM()")
    .first

    @popular_tags = Tag
    .left_joins(:tweets)                     # 投稿と結合（投稿がないタグも含む）
    .group(:id, :name)                      # タグごとにグループ化
    .order('COUNT(tweets.id) DESC')          # 投稿数が多い順に並べ替え
    .limit(5) 
  end

  def new
    @tweet = Tweet.new
  end

  def create
    @tweet = Tweet.new(tweet_params.except(:new_tags))
    @tweet.user_id = current_user.id

    if @tweet.save
      if params[:tweet][:new_tags].present?
        new_tag_names = params[:tweet][:new_tags]
                      .split(/[,\s　，]+/)
                      .map(&:strip)
                      .reject(&:blank?)
                      .uniq

        
        new_tag_names.each do |name|
          tag = Tag.find_or_create_by(name: name)
          @tweet.tags << tag unless @tweet.tags.include?(tag)
        end
      end
      redirect_to category_path(@tweet.category), notice: '投稿を作成しました'
    else
      flash.now[:alert] = '投稿の作成に失敗しました'
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @tweet = Tweet.find_by(id: params[:id])
    if @tweet.nil?
      redirect_to tweets_path, alert: "投稿が見つかりません" and return
    end
    @comments = @tweet.comments
    @comment = Comment.new
  end

  def edit
    @tweet = Tweet.find(params[:id])
  end

  def update
    @tweet = Tweet.find(params[:id])

    if @tweet.update(tweet_params.except(:new_tags))
       
     if params[:edit_tags].present?
        params[:edit_tags].each do |tag_id, new_name|
          tag = Tag.find(tag_id)
          tag.update(name: new_name.strip) unless new_name.strip.blank?
        end
     end

      if params[:tweet][:new_tags].present?
       new_tag_names = params[:tweet][:new_tags]
                        .split(/[　，]+/)
                        .map(&:strip)
                        .reject(&:blank?)
        new_tag_names.each do |name|
         tag = Tag.find_or_create_by(name: name)
          @tweet.tags << tag unless @tweet.tags.include?(tag)
        end
     end
     

       redirect_to @tweet, notice: "投稿を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
    
  end

  def destroy
    tweet = Tweet.find(params[:id])
    tweet.destroy
    redirect_to action: :index
  end

  private

  def tweet_params
    params.require(:tweet).permit(:place_name, :price, :location,:parking, :knowledge, :child_price, :image, :category_id, :new_tags, tag_ids: [])
  end
end