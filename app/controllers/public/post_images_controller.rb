class Public::PostImagesController < ApplicationController
  def new
    @post_image = PostImage.new
  end

  def create
    @post_image = PostImage.new(post_image_params)
    @post_image.user_id = current_user.id

    if params[:post]
      if @post_image.save(context: :publicize)
        flash[:notice] = "投稿しました。"
        redirect_to post_image_path(@post_image)
      else
        render :new
      end
    else
      if @post_image.update(is_draft: true)
        redirect_to user_path(current_user)
        flash[:notice] = "下書きを保存しました。"
      else
        render :new
      end
    end
  end

  def index
    respond_to do |format|
      format.html do
        @post_images = PostImage.where(is_draft: :false).page(params[:page])
      end
      format.json do
        @post_images = PostImage.all
      end
    end
  end

  def show
    @post_image = PostImage.find(params[:id])
    @post_comment = PostComment.new
  end

  def edit
    @post_image = PostImage.find(params[:id])
    if @post_image.user_id == current_user.id
      render :edit
    else
      flash.now[:alert] = "この投稿は編集できません。"
      render :show
    end
  end

  def update
    @post_image = PostImage.find(params[:id])
    if params[:publicize_draft]
      @post_image.attributes = post_image_params.merge(is_draft: false)
      if @post_image.save(context: :publicize)
        flash[:notice] = "下書きを投稿しました。"
        redirect_to post_image_path(@post_image)
      else
        @post_image.is_draft = true
        flash.now[:alert] = "下書きの投稿に失敗しました。"
        render :new
      end
    elsif params[:update_post]
      @post_image.attributes = post_image_params
      if @post_image.save(context: :publicize)
        flash[:notice] = "投稿を更新しました。"
        redirect_to post_image_path(@post_image)
      else
        flash.now[:alert] = "投稿の更新に失敗しました。"
        render :new
      end
    else
      if @post_image.update(post_image_params)
        flash[:notice] = "下書きを更新しました。"
        redirect_to post_image_path(@post_image)
      else
        flash.now[:alert] = "下書きを更新できませんでした。"
        render :new
      end
    end
  end

  def destroy
    post_image = PostImage.find(params[:id])
    post_image.destroy
    redirect_to post_images_path(@post_images)
  end

  private
    def post_image_params
      params.require(:post_image).permit(:shop_name, :image, :caption, :address, :is_draft)
    end
end