class BlogsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_blog, only: %i[ show edit update destroy ]

  # GET /blogs or /blogs.json
  def index
    @pagy, @blogs = pagy(Blog.order(params[:sort] || 'id' => params[:direction] || 'asc'), items: 10)
  end

  # GET /blogs/1 or /blogs/1.json
  def show
  end

  # GET /blogs/new
  def new
    @blog = current_user.blogs.new
  end

  # GET /blogs/1/edit
  def edit
  end

  # POST /blogs or /blogs.json
  def create
    @blog = current_user.blogs.build(blog_params)

    if @blog.save
      redirect_to @blog, notice: 'Blog was successfully created.'
    else
      flash.now[:alert] = 'There was an error creating the blog.'
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /blogs/1 or /blogs/1.json
  def update
    if @blog.update(blog_params)
      redirect_to @blog, notice: 'Blog was successfully updated.'
    else
      flash.now[:alert] = 'There was an error updating the blog.'
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /blogs/1 or /blogs/1.json
  def destroy
    @blog.destroy

    respond_to do |format|
      format.html { redirect_to blogs_url, notice: "Blog was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def import
    file = params[:attachment]
    if file.present?
      file_path = save_uploaded_file(file)
      ImportBlogsWorker.perform_async(file_path, current_user.id)
      redirect_to blogs_path, notice: "Blog import has started. Refresh in a while to check results."
    else
      redirect_to blogs_path, alert: "Please upload a valid CSV file."
    end
  end

  private

    def save_uploaded_file(file)
      dir = Rails.root.join("tmp", "uploads")
      FileUtils.mkdir_p(dir) unless Dir.exist?(dir) # Ensure the directory exists
    
      file_path = dir.join(SecureRandom.hex + ".csv")
      File.open(file_path, "wb") { |f| f.write(file.read) } # Save file contents
      file_path.to_s
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_blog
      @blog = current_user.blogs.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def blog_params
      params.require(:blog).permit(:title, :body, :user_id)
    end
end
