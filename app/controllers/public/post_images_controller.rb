class Public::PostImagesController < ApplicationController
  def new
    @post_image = PostImage.new
  end

  def create
    @post_image = PostImage.new(post_image_params)
    @post_image.user_id = current_user.id
    
    if params[:draft].present?
      @post_image.status = :draft
    else
      @post_image.status = :published
    end 
    
    if @post_image.save
      if @post_image.draft?
        redirect_to post_images_path
      else
        redirect_to post_images_path
      end
    else
      render :new
    end
  end

  def index
    respond_to do |format|
      format.html do
        @post_images = PostImage.page(params[:page])
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
    if params[:draft].present?
      @post_image.status = :draft
      flash[:notice] = "下書きを保存しました。"
      redirect_to post_images_path
    elsif params[:unpublished].present?
      @post.status = :unpublished
      flash[:notice] = "非公開にしました。"
      redirect_to post_images_path
    else
      @post_image.status = :publish
      flash[:notice] = "投稿を更新しました。"
      redirect_to post_image_path(@post_image)
    end
    
    if @post_image.update(post_image_params)
      redirect_to post_image_path(@post_image)
    else
      render :edit
    end 
    
  end

  def destroy
    post_image = PostImage.find(params[:id])
    post_image.destroy
    redirect_to post_images_path(@post_images)
  end

  private
    def post_image_params
      params.require(:post_image).permit(:shop_name, :image, :caption, :address)
    end
end