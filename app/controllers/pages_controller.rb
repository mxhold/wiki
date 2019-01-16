class PagesController < ApplicationController
  def home
    @pages = Page.all
  end

  def new
    @page = Page.new
  end

  def create
    @page = Page.new(
      title: page_params[:title],
      content: page_params[:content],
      slug: page_params[:title].gsub(/ /, '_'),
    )

    if @page.save
      redirect_to @page, notice: "Page was successfully created."
    else
      render :new
    end
  end

  def show
    @page = Page.find_by!(slug: params[:slug])
  end

  private

  def page_params
    params.require(:page).permit(:title, :content)
  end
end
