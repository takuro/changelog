class PostsController < ApplicationController
  # GET /posts
  # GET /posts.xml
  def index
    @posts = Post.order("id DESC").all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.xml
  def show
    @post = Post.find_by_permalink(params[:permalink])
    @post_title = @post.title

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.xml
  def new
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find_by_permalink(params[:permalink])
  end

  # POST /posts
  # POST /posts.xml
  def create
    post = params[:post]
    post[:body] = post[:raw_body]
    @post = Post.new(post)
    @post.remove_html_tag
    @post.wiki_syntax_to_html
    @post.remove_break_return_and_add_br_tag

    #Tag.add(@post.id, params[:tag])

    @post.save
    redirect_to "/"
  end

  # PUT /posts/1
  # PUT /posts/1.xml
  def update
    @post = Post.find(params[:id])

    post_params = params[:post]
    post_params[:body] = post_params[:raw_body]
    post = Post.new(post_params)
    post.remove_html_tag
    post.wiki_syntax_to_html
    post.remove_break_return_and_add_br_tag
    update_post_params = {
      :id => params[:id],
      :title => post.title,
      :raw_body => post.raw_body,
      :body => post.body,
      :permalink => post.permalink
    }

    @post.update_attributes(update_post_params)
    redirect_to "/log/#{update_post_params[:permalink]}"
  end

  # DELETE /posts/1
  # DELETE /posts/1.xml
  def destroy
    @post = Post.find_by_permalink(params[:permalink])
    @post.destroy

    redirect_to "/"
  end
end
