class CommentsController < ApplicationController
    before_action :authenticate_user!

    before_action :set_tweet
    before_action :set_comment, only: [:edit, :update, :destroy]

  def create
    tweet = Tweet.find(params[:tweet_id])
    comment = tweet.comments.build(comment_params) #buildを使い、contentとtweet_idの二つを同時に代入
    comment.user_id = current_user.id
    if comment.save
      flash[:success] = "コメントしました"
      redirect_back(fallback_location: root_path) #直前のページにリダイレクト
    else
      flash[:success] = "コメントできませんでした"
      redirect_back(fallback_location: root_path) #直前のページにリダイレクト
    end
  end

  def edit
  end

  def update
    if @comment.update(comment_params)
      redirect_to tweet_path(@tweet), notice: "コメントを更新しました"
    else
      render :edit
    end
  end

  def destroy
    @comment.destroy
    redirect_to tweet_path(@tweet), notice: "コメントを削除しました"
  end

  private
    def set_tweet
      @tweet = Tweet.find(params[:tweet_id])
    end

    def set_comment
      @comment = @tweet.comments.find(params[:id])
    end

    def comment_params
      params.require(:comment).permit(:content)
    end

end
